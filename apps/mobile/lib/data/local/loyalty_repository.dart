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

/// Whether a customer's monthly progress toward a free wash counts each of
/// their vehicles separately, or pools across all of them. Owner-configurable
/// (see SettingsRepository) — every method below takes the *current* value
/// explicitly rather than reading settings itself, so this repository stays
/// a plain, deterministic function of its inputs (easy to test, no hidden
/// async settings read buried inside "business logic" methods).
enum LoyaltyScope { vehicle, customer }

/// One row of the loyalty report — see [LoyaltyRepository.report].
/// [vehicleRegNumber] is null under [LoyaltyScope.customer], where the row
/// already represents the customer's pooled progress across every vehicle.
class LoyaltyReportRow {
  final String customerName;
  final String? vehicleRegNumber;
  final int qualifyingCount;
  final int remaining;
  final bool hasAvailableReward;

  LoyaltyReportRow({
    required this.customerName,
    required this.vehicleRegNumber,
    required this.qualifyingCount,
    required this.remaining,
    required this.hasAvailableReward,
  });
}

DateTime _monthStart(DateTime d) => DateTime(d.year, d.month);
DateTime _addMonths(DateTime d, int months) => DateTime(d.year, d.month + months);

/// The ledger (LocalLoyaltyLedger) is append-only and the sole source of
/// truth: "qualifying count" is never a stored counter, always recomputed
/// by scanning it, which is what makes offline replay/reversal safe. Every
/// row carries both vehicleId and customerId (denormalized from the
/// vehicle's owner at write time) so the same history can be read either
/// per-vehicle or pooled per-customer depending on [LoyaltyScope], without
/// needing two separate ledgers or a rewrite when the setting changes.
class LoyaltyRepository {
  final AppDatabase _db;
  LoyaltyRepository(this._db);

  Expression<bool> _subject($LocalLoyaltyLedgerTable l, LoyaltyScope scope, String vehicleId, String customerId) =>
      scope == LoyaltyScope.customer ? l.customerId.equals(customerId) : l.vehicleId.equals(vehicleId);

  Expression<bool> _rewardSubject($LocalLoyaltyRewardsTable r, LoyaltyScope scope, String vehicleId, String customerId) =>
      scope == LoyaltyScope.customer ? r.customerId.equals(customerId) : r.vehicleId.equals(vehicleId);

  Future<int> qualifyingCount({
    required String vehicleId,
    required String customerId,
    required LoyaltyScope scope,
    required DateTime periodMonth,
  }) async {
    final period = _monthStart(periodMonth);
    final credited = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => _subject(l, scope, vehicleId, customerId) & l.periodMonth.equals(period) & l.eventType.equals('WASH_CREDITED')))
        .get();
    final reversed = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => _subject(l, scope, vehicleId, customerId) & l.periodMonth.equals(period) & l.eventType.equals('WASH_REVERSED')))
        .get();
    final reversedWashIds = reversed.map((r) => r.washOrderId).whereType<String>().toSet();
    return credited.where((c) => c.washOrderId == null || !reversedWashIds.contains(c.washOrderId)).length;
  }

  /// Idempotent per wash (the `(washOrderId, eventType)` unique key backs
  /// this up, but this checks first so a retry is a clean no-op rather than
  /// a caught constraint violation). Earns exactly one reward once the
  /// month's qualifying count reaches the threshold — never a second one,
  /// no matter how many more washes follow, until next month. `>=` rather
  /// than `==` on purpose: robust to a count that jumps past the threshold
  /// in one step (e.g. right after the owner switches [LoyaltyScope] and a
  /// customer's pooled count is already ahead of any single wash crediting
  /// it), not just one that lands on it exactly.
  Future<({bool earned, int count, String? rewardId})> creditQualifyingWash({
    required String vehicleId,
    required String customerId,
    required LoyaltyScope scope,
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
              customerId: Value(customerId),
              washOrderId: Value(washOrderId),
              eventType: 'WASH_CREDITED',
              periodMonth: period,
              createdById: actorId,
            ),
          );
    }

    final count = await qualifyingCount(vehicleId: vehicleId, customerId: customerId, scope: scope, periodMonth: period);
    final alreadyEarned = await (_db.select(_db.localLoyaltyRewards)
          ..where((r) => _rewardSubject(r, scope, vehicleId, customerId) & r.earnedMonth.equals(period)))
        .getSingleOrNull();

    if (count >= qualifyingWashThreshold && alreadyEarned == null) {
      final ledgerId = _uuid.v4();
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: ledgerId,
              vehicleId: vehicleId,
              customerId: Value(customerId),
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
              customerId: Value(customerId),
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
  ///
  /// Doesn't take vehicleId/customerId — both are read back off the
  /// WASH_CREDITED row this wash originally wrote, so a void always
  /// resolves against the same subject the credit used, even if [scope]
  /// has since changed.
  Future<({int count, bool flaggedForReview, String? downgradedRewardId})> reverseWash({
    required String washOrderId,
    required LoyaltyScope scope,
    required String actorId,
  }) async {
    final credited = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.washOrderId.equals(washOrderId) & l.eventType.equals('WASH_CREDITED')))
        .getSingleOrNull();
    if (credited == null) {
      return (count: 0, flaggedForReview: false, downgradedRewardId: null);
    }
    final vehicleId = credited.vehicleId;
    final customerId = credited.customerId!;

    final alreadyReversed = await (_db.select(_db.localLoyaltyLedger)
          ..where((l) => l.washOrderId.equals(washOrderId) & l.eventType.equals('WASH_REVERSED')))
        .getSingleOrNull();
    if (alreadyReversed == null) {
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: vehicleId,
              customerId: Value(customerId),
              washOrderId: Value(washOrderId),
              eventType: 'WASH_REVERSED',
              periodMonth: credited.periodMonth,
              createdById: actorId,
            ),
          );
    }

    final count = await qualifyingCount(vehicleId: vehicleId, customerId: customerId, scope: scope, periodMonth: credited.periodMonth);
    final reward = await (_db.select(_db.localLoyaltyRewards)
          ..where((r) => _rewardSubject(r, scope, vehicleId, customerId) & r.earnedMonth.equals(credited.periodMonth)))
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
              vehicleId: vehicleId,
              customerId: Value(customerId),
              eventType: 'MANAGER_ADJUSTMENT',
              periodMonth: credited.periodMonth,
              createdById: actorId,
              notes: Value('Reward revoked: wash $washOrderId reversed, dropping below $qualifyingWashThreshold qualifying washes'),
            ),
          );
      return (count: count, flaggedForReview: false, downgradedRewardId: reward.id);
    }

    if (reward.status == 'REDEEMED') {
      await _db.into(_db.localLoyaltyLedger).insert(
            LocalLoyaltyLedgerCompanion.insert(
              id: _uuid.v4(),
              vehicleId: vehicleId,
              customerId: Value(customerId),
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
  Future<LocalLoyaltyReward?> findAvailableReward({
    required String vehicleId,
    required String customerId,
    required LoyaltyScope scope,
    DateTime? asOf,
  }) {
    final period = _monthStart(asOf ?? DateTime.now());
    return (_db.select(_db.localLoyaltyRewards)
          ..where((r) => _rewardSubject(r, scope, vehicleId, customerId) & r.status.equals('AVAILABLE') & r.validMonth.equals(period)))
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
            customerId: Value(reward.customerId),
            washOrderId: Value(washOrderId),
            eventType: 'REWARD_REDEEMED',
            periodMonth: _monthStart(DateTime.now()), // redemption month, not earned month
            createdById: actorId,
          ),
        );
  }

  /// Admin-only free-text note — does NOT itself grant or revoke a reward
  /// or change any count, purely an annotated record (matches the backend's
  /// own scope for this method). Always vehicle-keyed regardless of
  /// [LoyaltyScope]: it's a note about what happened with a specific car,
  /// not a counted event.
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

  /// One row per vehicle ([LoyaltyScope.vehicle]) or per customer
  /// ([LoyaltyScope.customer], one row pooling all of that customer's
  /// vehicles) — "how many washes before a free wash" for everyone,
  /// sorted by whoever's closest first. A customer with no vehicles yet
  /// can't have washed anything, so they're left out entirely.
  Future<List<LoyaltyReportRow>> report({required LoyaltyScope scope, DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    await expireStaleRewards(asOf: now);
    final customers = {for (final c in await _db.select(_db.localCustomers).get()) c.id: c};
    final vehicles = await _db.select(_db.localVehicles).get();
    final rows = <LoyaltyReportRow>[];

    if (scope == LoyaltyScope.vehicle) {
      for (final v in vehicles) {
        final customer = customers[v.customerId];
        if (customer == null) continue;
        final count = await qualifyingCount(vehicleId: v.id, customerId: v.customerId, scope: scope, periodMonth: now);
        final reward = await findAvailableReward(vehicleId: v.id, customerId: v.customerId, scope: scope, asOf: now);
        rows.add(LoyaltyReportRow(
          customerName: customer.fullName,
          vehicleRegNumber: v.regNumberDisplay,
          qualifyingCount: count,
          remaining: (qualifyingWashThreshold - count).clamp(0, qualifyingWashThreshold),
          hasAvailableReward: reward != null,
        ));
      }
    } else {
      for (final customer in customers.values) {
        final ownVehicles = vehicles.where((v) => v.customerId == customer.id);
        if (ownVehicles.isEmpty) continue;
        final representativeVehicleId = ownVehicles.first.id; // unused by the query when scope is customer; just satisfies the signature
        final count = await qualifyingCount(vehicleId: representativeVehicleId, customerId: customer.id, scope: scope, periodMonth: now);
        final reward = await findAvailableReward(vehicleId: representativeVehicleId, customerId: customer.id, scope: scope, asOf: now);
        rows.add(LoyaltyReportRow(
          customerName: customer.fullName,
          vehicleRegNumber: null,
          qualifyingCount: count,
          remaining: (qualifyingWashThreshold - count).clamp(0, qualifyingWashThreshold),
          hasAvailableReward: reward != null,
        ));
      }
    }

    rows.sort((a, b) => b.qualifyingCount.compareTo(a.qualifyingCount));
    return rows;
  }

  Future<LoyaltySummary> summaryForVehicle({
    required String vehicleId,
    required String customerId,
    required LoyaltyScope scope,
    DateTime? asOf,
  }) async {
    final now = asOf ?? DateTime.now();
    await expireStaleRewards(asOf: now);
    final count = await qualifyingCount(vehicleId: vehicleId, customerId: customerId, scope: scope, periodMonth: now);
    final reward = await findAvailableReward(vehicleId: vehicleId, customerId: customerId, scope: scope, asOf: now);
    return LoyaltySummary(
      qualifyingCount: count,
      remaining: (qualifyingWashThreshold - count).clamp(0, qualifyingWashThreshold),
      hasAvailableReward: reward != null,
    );
  }

  /// Flips any AVAILABLE reward whose validMonth has passed to EXPIRED —
  /// this is how a reward earned one month but never redeemed disappears
  /// once the month after that ends, i.e. "resets" on the 1st. Scope-
  /// agnostic: it scans every reward regardless of vehicle or customer, so
  /// it behaves identically no matter which [LoyaltyScope] is active. The
  /// backend never actually wired this to a scheduler either — here it's
  /// called opportunistically from [summaryForVehicle] instead, so it stays
  /// current without needing a background task.
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
              customerId: Value(reward.customerId),
              eventType: 'REWARD_EXPIRED',
              periodMonth: period,
              createdById: systemActorId,
            ),
          );
    }
  }
}

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) => LoyaltyRepository(ref.watch(appDatabaseProvider)));
