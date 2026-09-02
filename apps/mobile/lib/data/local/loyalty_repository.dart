import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

/// Every automated write (reward expiry) that isn't triggered by a specific
/// logged-in user's action is attributed to this sentinel id — there's no
/// server-seeded "system" account anymore, and no FK constraint that would
/// require one to actually exist as a row.
const systemActorId = 'system';

/// Number of qualifying washes in a calendar month that earns one free-wash
/// reward. Hardcoded here, same as the backend this was ported from — not
/// configurable via any settings screen.
const qualifyingWashThreshold = 5;

DateTime _monthStart(DateTime d) => DateTime(d.year, d.month);
DateTime _addMonths(DateTime d, int months) => DateTime(d.year, d.month + months);

/// Loyalty tracking is per-vehicle, not per-customer — a customer with two
/// cars tracks two independent monthly counters. The ledger
/// (LocalLoyaltyLedger) is append-only and the sole source of truth:
/// "qualifying count" is never a stored counter, always recomputed by
/// scanning it, which is what makes offline replay/reversal safe.
class LoyaltyRepository {
  final AppDatabase _db;
  LoyaltyRepository(this._db);

  Future<int> qualifyingCount(String vehicleId, DateTime periodMonth) async {
    final period = _monthStart(periodMonth);
    final credited = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.vehicleId.equals(vehicleId) & l.periodMonth.equals(period) & l.eventType.equals('WASH_CREDITED')))
        .get();
    final reversed = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.vehicleId.equals(vehicleId) & l.periodMonth.equals(period) & l.eventType.equals('WASH_REVERSED')))
        .get();
    final reversedWashIds = reversed.map((r) => r.washOrderId).whereType<String>().toSet();
    return credited.where((c) => c.washOrderId == null || !reversedWashIds.contains(c.washOrderId)).length;
  }

  /// Idempotent per wash (the `(washOrderId, eventType)` unique key backs
  /// this up, but this checks first so a retry is a clean no-op rather than
  /// a caught constraint violation). Earns exactly one reward on the 5th
  /// qualifying wash of the calendar month — never a second one, no matter
  /// how many more washes follow, until next month.
  Future<({bool earned, int count, String? rewardId})> creditQualifyingWash({
    required String vehicleId,
    required String washOrderId,
    required DateTime at,
    required String actorId,
  }) async {
    final period = _monthStart(at);
    final existing = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.washOrderId.equals(washOrderId) & l.eventType.equals('WASH_CREDITED')))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: vehicleId,
              washOrderId: Value(washOrderId),
              eventType: 'WASH_CREDITED',
              periodMonth: period,
              createdById: actorId,
            ),
          );
    }

    final count = await qualifyingCount(vehicleId, period);
    final alreadyEarned = await (_db.select(_db.localLoyaltyRewards)
          ..where((r) => r.vehicleId.equals(vehicleId) & r.earnedMonth.equals(period)))
        .getSingleOrNull();

    if (count == qualifyingWashThreshold && alreadyEarned == null) {
      final ledgerId = _uuid.v4();
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: ledgerId,
              vehicleId: vehicleId,
              washOrderId: Value(washOrderId),
              eventType: 'REWARD_EARNED',
              periodMonth: period,
              createdById: actorId,
              notes: const Value('Five qualifying washes in the month'),
            ),
          );
      final rewardId = _uuid.v4();
      await _db.into(_db.localLoyaltyRewards).insert(
            LocalLoyaltyRewardsCompanion.insert(
              id: rewardId,
              vehicleId: vehicleId,
              earnedMonth: period,
              validMonth: _addMonths(period, 1),
              earnedFromLedgerId: ledgerId,
            ),
          );
      return (earned: true, count: count, rewardId: rewardId);
    }
    return (earned: false, count: count, rewardId: null);
  }

  /// The refund/void walk-back. If the wash never actually qualified (e.g.
  /// paid entirely with a redeemed reward), this is a safe no-op. If a
  /// reward was earned from this wash and is still AVAILABLE, it's revoked.
  /// If it was already REDEEMED against some other, later wash, that other
  /// wash is deliberately NOT auto-unwound — this is flagged for manual
  /// review instead (a business judgment call, not an oversight).
  Future<({int count, bool flaggedForReview, String? downgradedRewardId})> reverseWash({
    required String washOrderId,
    required String actorId,
  }) async {
    final credited = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.washOrderId.equals(washOrderId) & l.eventType.equals('WASH_CREDITED')))
        .getSingleOrNull();
    if (credited == null) {
      return (count: 0, flaggedForReview: false, downgradedRewardId: null);
    }

    final alreadyReversed = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.washOrderId.equals(washOrderId) & l.eventType.equals('WASH_REVERSED')))
        .getSingleOrNull();
    if (alreadyReversed == null) {
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: credited.vehicleId,
              washOrderId: Value(washOrderId),
              eventType: 'WASH_REVERSED',
              periodMonth: credited.periodMonth,
              createdById: actorId,
            ),
          );
    }

    final count = await qualifyingCount(credited.vehicleId, credited.periodMonth);
    final reward = await (_db.select(_db.localLoyaltyRewards)
          ..where((r) => r.vehicleId.equals(credited.vehicleId) & r.earnedMonth.equals(credited.periodMonth)))
        .getSingleOrNull();
    // No reward this month, or still >= threshold even after the
    // reversal — nothing to unwind. Also naturally makes a repeat call
    // idempotent once the reward's status has already moved on below.
    if (reward == null || count >= qualifyingWashThreshold) {
      return (count: count, flaggedForReview: false, downgradedRewardId: null);
    }

    if (reward.status == 'AVAILABLE') {
      await (_db.update(_db.localLoyaltyRewards)..where((r) => r.id.equals(reward.id))).write(
        LocalLoyaltyRewardsCompanion(status: const Value('REVOKED'), expiredAt: Value(DateTime.now())),
      );
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: credited.vehicleId,
              eventType: 'MANAGER_ADJUSTMENT',
              periodMonth: credited.periodMonth,
              createdById: actorId,
              notes: Value('Reward revoked: wash $washOrderId reversed, dropping the vehicle below $qualifyingWashThreshold qualifying washes'),
            ),
          );
      return (count: count, flaggedForReview: false, downgradedRewardId: reward.id);
    }

    if (reward.status == 'REDEEMED') {
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: credited.vehicleId,
              eventType: 'MANAGER_ADJUSTMENT',
              periodMonth: credited.periodMonth,
              createdById: actorId,
              notes: Value(
                'NEEDS REVIEW: reward ${reward.id} was already redeemed against wash ${reward.redeemedWashOrderId}, but the wash that earned it ($washOrderId) was just reversed',
              ),
            ),
          );
      return (count: count, flaggedForReview: true, downgradedRewardId: null);
    }

    return (count: count, flaggedForReview: false, downgradedRewardId: null);
  }

  /// Only matches a reward whose validMonth is exactly the current calendar
  /// month — one not redeemed within its single valid month simply becomes
  /// invisible here (see [expireStaleRewards] for the actual status flip).
  Future<LocalLoyaltyReward?> findAvailableReward(String vehicleId, DateTime asOf) {
    final period = _monthStart(asOf);
    return (_db.select(_db.localLoyaltyRewards)
          ..where((r) => r.vehicleId.equals(vehicleId) & r.status.equals('AVAILABLE') & r.validMonth.equals(period)))
        .getSingleOrNull();
  }

  Future<void> redeemReward({required String rewardId, required String washOrderId, required String actorId}) async {
    final reward = await (_db.select(_db.localLoyaltyRewards)..where((r) => r.id.equals(rewardId))).getSingle();
    await (_db.update(_db.localLoyaltyRewards)..where((r) => r.id.equals(rewardId))).write(
      LocalLoyaltyRewardsCompanion(status: const Value('REDEEMED'), redeemedWashOrderId: Value(washOrderId), redeemedAt: Value(DateTime.now())),
    );
    await _db.into(_db.localLoyaltyLedger).insert(
          LocalLoyaltyLedgerCompanion.insert(
            id: _uuid.v4(),
            vehicleId: reward.vehicleId,
            washOrderId: Value(washOrderId),
            eventType: 'REWARD_REDEEMED',
            periodMonth: _monthStart(DateTime.now()), // redemption month, not earned month
            createdById: actorId,
          ),
        );
  }

  /// Admin-only free-text note — does NOT itself grant or revoke a reward
  /// or change any count, purely an annotated record (matches the backend's
  /// own scope for this method).
  Future<void> manualAdjustment({required String vehicleId, required String note, required String actorId}) async {
    await _db.into(_db.localLoyaltyLedger).insert(
          LocalLoyaltyLedgerCompanion.insert(
            id: _uuid.v4(),
            vehicleId: vehicleId,
            eventType: 'MANAGER_ADJUSTMENT',
            periodMonth: _monthStart(DateTime.now()),
            createdById: actorId,
            notes: Value(note),
          ),
        );
  }

  Future<LoyaltySummary> summaryForVehicle(String vehicleId, {DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    await expireStaleRewards(asOf: now);
    final count = await qualifyingCount(vehicleId, now);
    final reward = await findAvailableReward(vehicleId, now);
    return LoyaltySummary(
      qualifyingCount: count,
      remaining: (qualifyingWashThreshold - count).clamp(0, qualifyingWashThreshold),
      hasAvailableReward: reward != null,
    );
  }

  /// Flips any AVAILABLE reward whose validMonth has passed to EXPIRED.
  /// The backend never actually wired this to a scheduler either — here
  /// it's called opportunistically from [summaryForVehicle] instead, so it
  /// stays current without needing a background task.
  Future<void> expireStaleRewards({DateTime? asOf}) async {
    final period = _monthStart(asOf ?? DateTime.now());
    final stale = await (_db.select(_db.localLoyaltyRewards)
          ..where((r) => r.status.equals('AVAILABLE') & r.validMonth.isSmallerThanValue(period)))
        .get();
    for (final reward in stale) {
      await (_db.update(_db.localLoyaltyRewards)..where((r) => r.id.equals(reward.id))).write(
        LocalLoyaltyRewardsCompanion(status: const Value('EXPIRED'), expiredAt: Value(DateTime.now())),
      );
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: reward.vehicleId,
              eventType: 'REWARD_EXPIRED',
              periodMonth: period,
              createdById: systemActorId,
            ),
          );
    }
  }
}

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) => LoyaltyRepository(ref.watch(appDatabaseProvider)));
