import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';

void main() {
  late AppDatabase db;
  late LoyaltyRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = LoyaltyRepository(db);
  });

  tearDown(() => db.close());

  final month = DateTime(2026, 3);

  test('exactly the 5th qualifying wash earns a reward, valid next calendar month', () async {
    for (var i = 1; i <= 4; i++) {
      final r = await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
      expect(r.earned, isFalse, reason: 'wash $i should not earn yet');
    }
    final fifth = await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w5', at: month, actorId: 'u1');
    expect(fifth.earned, isTrue);
    expect(fifth.count, 5);
    expect(fifth.rewardId, isNotNull);

    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    expect(reward.earnedMonth, DateTime(2026, 3));
    expect(reward.validMonth, DateTime(2026, 4));
    expect(reward.status, 'AVAILABLE');
  });

  test('washes 6 and beyond in the same month never earn a second reward', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    final sixth = await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w6', at: month, actorId: 'u1');
    expect(sixth.earned, isFalse);
    expect(sixth.count, 6);

    final rewards = await db.select(db.localLoyaltyRewards).get();
    expect(rewards, hasLength(1));
  });

  test('crediting the same wash twice is idempotent — no double count, no duplicate ledger row', () async {
    await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w1', at: month, actorId: 'u1');
    final second = await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w1', at: month, actorId: 'u1');
    expect(second.count, 1);

    final ledgerRows = await db.select(db.localLoyaltyLedger).get();
    expect(ledgerRows.where((l) => l.eventType == 'WASH_CREDITED'), hasLength(1));
  });

  test('loyalty progress is tracked per vehicle, not per customer', () async {
    await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w1', at: month, actorId: 'u1');
    await repo.creditQualifyingWash(vehicleId: 'v2', washOrderId: 'w2', at: month, actorId: 'u1');

    expect(await repo.qualifyingCount('v1', month), 1);
    expect(await repo.qualifyingCount('v2', month), 1);
  });

  test('reversing a wash that never qualified (e.g. paid entirely by a redeemed reward) is a safe no-op', () async {
    final result = await repo.reverseWash(washOrderId: 'never-credited', actorId: 'u1');
    expect(result.count, 0);
    expect(result.flaggedForReview, isFalse);
    expect(await db.select(db.localLoyaltyLedger).get(), isEmpty);
  });

  test('reversing a wash that drops the count below threshold revokes an AVAILABLE reward', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    expect(reward.status, 'AVAILABLE');

    final result = await repo.reverseWash(washOrderId: 'w5', actorId: 'supervisor1');
    expect(result.count, 4);
    expect(result.downgradedRewardId, reward.id);
    expect(result.flaggedForReview, isFalse);

    final updated = await db.select(db.localLoyaltyRewards).getSingle();
    expect(updated.status, 'REVOKED');
    expect(updated.expiredAt, isNotNull);
  });

  test('reversing a wash does not touch the reward if the count is still at or above threshold', () async {
    for (var i = 1; i <= 6; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    final result = await repo.reverseWash(washOrderId: 'w6', actorId: 'u1');
    expect(result.count, 5); // still exactly at threshold
    expect(result.downgradedRewardId, isNull);

    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    expect(reward.status, 'AVAILABLE');
  });

  test('reversing a wash twice is idempotent — no duplicate reversal row, no duplicate adjustment', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    await repo.reverseWash(washOrderId: 'w5', actorId: 'u1');
    final second = await repo.reverseWash(washOrderId: 'w5', actorId: 'u1');
    expect(second.downgradedRewardId, isNull); // already revoked, nothing left to downgrade

    final reversedRows = await (db.select(db.localLoyaltyLedger)..where((l) => l.eventType.equals('WASH_REVERSED'))).get();
    expect(reversedRows, hasLength(1));
    final adjustmentRows = await (db.select(db.localLoyaltyLedger)..where((l) => l.eventType.equals('MANAGER_ADJUSTMENT'))).get();
    expect(adjustmentRows, hasLength(1));
  });

  test('reversing a wash whose reward was already redeemed elsewhere flags for review without touching the other wash', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    // Redeemed the following month, against a different, later wash order.
    await repo.redeemReward(rewardId: reward.id, washOrderId: 'later-wash', actorId: 'u1');

    final result = await repo.reverseWash(washOrderId: 'w5', actorId: 'u1');
    expect(result.flaggedForReview, isTrue);
    expect(result.downgradedRewardId, isNull);

    // The other wash's redemption is left completely alone.
    final untouched = await db.select(db.localLoyaltyRewards).getSingle();
    expect(untouched.status, 'REDEEMED');
    expect(untouched.redeemedWashOrderId, 'later-wash');
  });

  test('findAvailableReward only matches a reward whose validMonth is exactly this calendar month', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    // Earned in March, valid in April — not visible as "available" in March itself.
    expect(await repo.findAvailableReward('v1', month), isNull);
    expect(await repo.findAvailableReward('v1', DateTime(2026, 4)), isNotNull);
    expect(await repo.findAvailableReward('v1', DateTime(2026, 5)), isNull);
  });

  test('summaryForVehicle reports remaining count clamped at the threshold and reflects an available reward', () async {
    final noProgress = await repo.summaryForVehicle('v1', asOf: month);
    expect(noProgress.qualifyingCount, 0);
    expect(noProgress.remaining, 5);
    expect(noProgress.hasAvailableReward, isFalse);

    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    final nextMonthSummary = await repo.summaryForVehicle('v1', asOf: DateTime(2026, 4));
    expect(nextMonthSummary.hasAvailableReward, isTrue);
  });

  test('expireStaleRewards flips a past-validMonth AVAILABLE reward to EXPIRED and records it', () async {
    for (var i = 1; i <= 5; i++) {
      await repo.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'w$i', at: month, actorId: 'u1');
    }
    // Valid in April; asking for a June summary should sweep it as stale.
    await repo.expireStaleRewards(asOf: DateTime(2026, 6));

    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    expect(reward.status, 'EXPIRED');
    expect(reward.expiredAt, isNotNull);

    final expiredRows = await (db.select(db.localLoyaltyLedger)..where((l) => l.eventType.equals('REWARD_EXPIRED'))).get();
    expect(expiredRows, hasLength(1));
    expect(expiredRows.single.createdById, systemActorId);
  });

  test('manualAdjustment writes a note without changing any count or reward', () async {
    await repo.manualAdjustment(vehicleId: 'v1', note: 'Customer complaint, goodwill gesture noted', actorId: 'owner1');
    expect(await repo.qualifyingCount('v1', DateTime.now()), 0);
    final rows = await (db.select(db.localLoyaltyLedger)..where((l) => l.eventType.equals('MANAGER_ADJUSTMENT'))).get();
    expect(rows, hasLength(1));
    expect(rows.single.notes, 'Customer complaint, goodwill gesture noted');
  });
}
