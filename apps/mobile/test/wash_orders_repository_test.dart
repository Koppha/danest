import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/local/prepaid_repository.dart';
import 'package:de_nest/data/local/wash_orders_repository.dart';

void main() {
  late AppDatabase db;
  late WashOrdersRepository repo;
  late PrepaidRepository prepaid;
  late LoyaltyRepository loyalty;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    prepaid = PrepaidRepository(db);
    loyalty = LoyaltyRepository(db);
    repo = WashOrdersRepository(db, prepaid, loyalty);

    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-standard', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 2000),
        );
  });

  tearDown(() => db.close());

  Future<String> startBasicWash({String? id, int extraCount = 0}) async {
    final items = [
      {'itemType': 'SERVICE', 'serviceId': 'svc-standard'},
      if (extraCount > 0) {'itemType': 'EXTRA', 'extraId': 'ext-1'},
    ];
    final order = await repo.startWash(id: id, vehicleId: 'v1', customerId: 'c1', items: items, actorId: 'u1');
    return order.id;
  }

  group('startWash', () {
    test('computes the total from the current catalog and snapshots service/extra names+prices', () async {
      final id = await startBasicWash(extraCount: 1);
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.totalAmount, 8000); // 6000 + 2000
      expect(order.status, 'WAITING');

      final items = await (db.select(db.localWashOrderItems)..where((i) => i.washOrderId.equals(id))).get();
      expect(items, hasLength(2));
    });

    test('records the initial WAITING status history row', () async {
      final id = await startBasicWash();
      final history = await (db.select(db.localWashStatusHistory)..where((h) => h.washOrderId.equals(id))).get();
      expect(history, hasLength(1));
      expect(history.single.fromStatus, isNull);
      expect(history.single.toStatus, 'WAITING');
    });

    test('a later catalog price change does not retroactively affect an existing order', () async {
      final id = await startBasicWash();
      await (db.update(db.localWashServices)..where((s) => s.id.equals('svc-standard'))).write(const LocalWashServicesCompanion(basePrice: Value(9999)));
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.totalAmount, 6000); // unchanged
    });

    test('starting the same id twice returns the existing order, not a duplicate', () async {
      final id = await startBasicWash(id: 'fixed-id');
      final second = await repo.startWash(id: 'fixed-id', vehicleId: 'v1', customerId: 'c1', items: [
        {'itemType': 'SERVICE', 'serviceId': 'svc-standard'},
      ], actorId: 'u1');
      expect(second.id, id);
      expect(await db.select(db.localWashOrders).get(), hasLength(1));
    });
  });

  group('transition', () {
    test('WAITING -> WASHING -> READY is legal', () async {
      final id = await startBasicWash();
      await repo.transition(id, 'WASHING', actorId: 'u1');
      await repo.transition(id, 'READY', actorId: 'u1');
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'READY');
    });

    test('WAITING -> READY directly is illegal (must pass through WASHING)', () async {
      final id = await startBasicWash();
      await expectLater(repo.transition(id, 'READY', actorId: 'u1'), throwsA(isA<IllegalWashTransitionException>()));
    });

    test('READY -> WASHING is legal (step-back for a mis-tap)', () async {
      final id = await startBasicWash();
      await repo.transition(id, 'WASHING', actorId: 'u1');
      await repo.transition(id, 'READY', actorId: 'u1');
      await repo.transition(id, 'WASHING', actorId: 'u1');
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'WASHING');
    });

    test('COMPLETED is unreachable through transition() — only finishWash can reach it', () async {
      final id = await startBasicWash();
      await expectLater(repo.transition(id, 'COMPLETED', actorId: 'u1'), throwsA(isA<IllegalWashTransitionException>()));
    });
  });

  group('cancel', () {
    test('cancelling a WAITING wash succeeds and records the reason', () async {
      final id = await startBasicWash();
      await repo.cancel(id, 'Customer changed their mind', actorId: 'attendant1', approvedByUserId: 'supervisor1');
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'CANCELLED');
      expect(order.cancelReason, 'Customer changed their mind');
      expect(order.cancelledAt, isNotNull);
    });

    test('cancelling an already-completed wash is illegal', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      await expectLater(repo.cancel(id, 'too late', actorId: 'u1', approvedByUserId: 's1'), throwsA(isA<IllegalWashTransitionException>()));
    });
  });

  group('finishWash', () {
    test('finishing a wash with cash marks it COMPLETED and credits a qualifying wash', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');

      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'COMPLETED');
      expect(order.completedAt, isNotNull);
      expect(await loyalty.qualifyingCount('v1', DateTime.now()), 1);
    });

    test('finishing an already-COMPLETED wash is an idempotent no-op, not an error', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      final result = await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      expect(result.status, 'COMPLETED');
      expect(await loyalty.qualifyingCount('v1', DateTime.now()), 1); // not credited twice
    });

    test('finishing a CANCELLED wash throws', () async {
      final id = await startBasicWash();
      await repo.cancel(id, 'reason', actorId: 'u1', approvedByUserId: 's1');
      await expectLater(
        repo.finishWash(id, [
          {'method': 'CASH', 'amount': 6000},
        ], actorId: 'u1'),
        throwsA(isA<WashAlreadyCancelledException>()),
      );
    });

    test('a WAITING (not READY) wash can still be paid directly', () async {
      final id = await startBasicWash();
      final result = await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      expect(result.status, 'COMPLETED');
    });

    test('component amounts that do not sum to the order total are rejected', () async {
      final id = await startBasicWash();
      await expectLater(
        repo.finishWash(id, [
          {'method': 'CASH', 'amount': 5000},
        ], actorId: 'u1'),
        throwsA(isA<PaymentAmountMismatchException>()),
      );
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'WAITING'); // untouched
    });

    test('MOBILE_MONEY without a reference is rejected', () async {
      final id = await startBasicWash();
      await expectLater(
        repo.finishWash(id, [
          {'method': 'MOBILE_MONEY', 'amount': 6000},
        ], actorId: 'u1'),
        throwsA(isA<ReferenceRequiredException>()),
      );
    });

    test('MOBILE_MONEY with a reference succeeds', () async {
      final id = await startBasicWash();
      final result = await repo.finishWash(id, [
        {'method': 'MOBILE_MONEY', 'amount': 6000, 'externalReference': 'MP12345'},
      ], actorId: 'u1');
      expect(result.status, 'COMPLETED');
    });

    test('WALLET payment debits the customer and succeeds', () async {
      await prepaid.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'WALLET', 'amount': 6000},
      ], actorId: 'u1');
      expect(await prepaid.walletBalance('c1'), 4000);
    });

    test('WALLET payment with insufficient balance throws and completes nothing', () async {
      await prepaid.deposit(customerId: 'c1', amount: 1000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      final id = await startBasicWash();
      await expectLater(
        repo.finishWash(id, [
          {'method': 'WALLET', 'amount': 6000},
        ], actorId: 'u1'),
        throwsA(isA<InsufficientWalletBalanceException>()),
      );
      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'WAITING');
    });

    test('PACKAGE payment with no applicable purchase throws', () async {
      final id = await startBasicWash();
      await expectLater(
        repo.finishWash(id, [
          {'method': 'PACKAGE', 'amount': 6000},
        ], actorId: 'u1'),
        throwsA(isA<NoApplicablePackageException>()),
      );
    });

    test('PACKAGE payment with an applicable purchase succeeds and decrements it', () async {
      await db.into(db.localPrepaidPackages).insert(
            LocalPrepaidPackagesCompanion.insert(
              id: 'pkg-1',
              name: 'Standard bundle',
              eligibleTiers: '',
              washCount: 5,
              price: 20000,
              validityDays: 90,
              applicableScope: 'ANY_VEHICLE_OF_CUSTOMER',
            ),
          );
      final purchase = await prepaid.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      final id = await startBasicWash();
      final result = await repo.finishWash(id, [
        {'method': 'PACKAGE', 'amount': 6000},
      ], actorId: 'u1');
      expect(result.status, 'COMPLETED');
      final updated = await (db.select(db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchase.id))).getSingle();
      expect(updated.remainingCount, 4);
    });

    test('LOYALTY_FREE_WASH with no available reward throws', () async {
      final id = await startBasicWash();
      await expectLater(
        repo.finishWash(id, [
          {'method': 'LOYALTY_FREE_WASH', 'amount': 6000},
        ], actorId: 'u1'),
        throwsA(isA<NoAvailableRewardException>()),
      );
    });

    test('a wash paid entirely by LOYALTY_FREE_WASH does not itself earn a new qualifying credit', () async {
      // Earn a reward on v1 last month, so it's valid (redeemable) this
      // month — findAvailableReward only matches the current calendar month.
      final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1, 15);
      for (var i = 1; i <= 5; i++) {
        await loyalty.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'seed-$i', at: lastMonth, actorId: 'u1');
      }
      final reward = await loyalty.findAvailableReward('v1', DateTime.now());
      expect(reward, isNotNull);

      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'LOYALTY_FREE_WASH', 'amount': 6000},
      ], actorId: 'u1');

      final countAfter = await loyalty.qualifyingCount('v1', lastMonth);
      expect(countAfter, 5); // unchanged in that period — redeeming a reward doesn't earn another
      final rewardAfter = await db.select(db.localLoyaltyRewards).getSingle();
      expect(rewardAfter.status, 'REDEEMED');
    });

    test('a \$0 wash order never earns a qualifying credit even if "paid"', () async {
      await db.into(db.localWashOrders).insert(
            LocalWashOrdersCompanion.insert(id: 'zero-wash', branchId: 'main', vehicleId: 'v9', customerId: 'c9', status: 'WAITING', totalAmount: 0, createdAt: DateTime.now()),
          );
      await repo.finishWash('zero-wash', [], actorId: 'u1');
      expect(await loyalty.qualifyingCount('v9', DateTime.now()), 0);
    });
  });

  group('voidPayment', () {
    test('voiding a wash with no payment throws', () async {
      final id = await startBasicWash();
      await expectLater(repo.voidPayment(id, 'reason', actorId: 'u1', approvedByUserId: 's1'), throwsA(isA<NoActivePaymentException>()));
    });

    test('voiding a cash payment cancels the wash and reverses loyalty credit', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      expect(await loyalty.qualifyingCount('v1', DateTime.now()), 1);

      await repo.voidPayment(id, 'Customer disputed charge', actorId: 'u1', approvedByUserId: 's1');

      final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals(id))).getSingle();
      expect(order.status, 'CANCELLED'); // not some separate REFUNDED status
      expect(order.cancelReason, 'Customer disputed charge');
      expect(await loyalty.qualifyingCount('v1', DateTime.now()), 0);
    });

    test('voiding a WALLET payment refunds the wallet', () async {
      await prepaid.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'WALLET', 'amount': 6000},
      ], actorId: 'u1');
      expect(await prepaid.walletBalance('c1'), 4000);

      await repo.voidPayment(id, 'reason', actorId: 'u1', approvedByUserId: 's1');
      expect(await prepaid.walletBalance('c1'), 10000);
    });

    test('voiding a PACKAGE payment gives the wash back to the purchase', () async {
      await db.into(db.localPrepaidPackages).insert(
            LocalPrepaidPackagesCompanion.insert(
              id: 'pkg-1',
              name: 'Standard bundle',
              eligibleTiers: '',
              washCount: 5,
              price: 20000,
              validityDays: 90,
              applicableScope: 'ANY_VEHICLE_OF_CUSTOMER',
            ),
          );
      final purchase = await prepaid.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'PACKAGE', 'amount': 6000},
      ], actorId: 'u1');
      var updated = await (db.select(db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchase.id))).getSingle();
      expect(updated.remainingCount, 4);

      await repo.voidPayment(id, 'reason', actorId: 'u1', approvedByUserId: 's1');
      updated = await (db.select(db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchase.id))).getSingle();
      expect(updated.remainingCount, 5);
    });

    test('voiding marks the payment itself voided, with a voidedAt timestamp', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');
      final before = DateTime.now();

      await repo.voidPayment(id, 'reason', actorId: 'u1', approvedByUserId: 's1');

      final payment = await (db.select(db.localPayments)..where((p) => p.washOrderId.equals(id))).getSingle();
      expect(payment.voided, isTrue);
      expect(payment.voidedAt, isNotNull);
      expect(payment.voidedAt!.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
    });

    test('voiding an already-voided payment throws instead of double-refunding', () async {
      await prepaid.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'WALLET', 'amount': 6000},
      ], actorId: 'u1');
      await repo.voidPayment(id, 'first void', actorId: 'u1', approvedByUserId: 's1');
      expect(await prepaid.walletBalance('c1'), 10000);

      await expectLater(
        repo.voidPayment(id, 'second void attempt', actorId: 'u1', approvedByUserId: 's1'),
        throwsA(isA<NoActivePaymentException>()),
      );
      expect(await prepaid.walletBalance('c1'), 10000); // not refunded twice
    });
  });

  group('audit trail', () {
    test('finishing a wash records a WASH_ORDER_COMPLETED entry', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');

      final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(id))).get();
      expect(entries.map((e) => e.action), contains('WASH_ORDER_COMPLETED'));
      expect(entries.firstWhere((e) => e.action == 'WASH_ORDER_COMPLETED').actorId, 'u1');
    });

    test('cancelling a wash records a WASH_ORDER_CANCELLED entry with the approver attached', () async {
      final id = await startBasicWash();
      await repo.cancel(id, 'customer left', actorId: 'u1', approvedByUserId: 's1');

      final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(id))).get();
      final entry = entries.singleWhere((e) => e.action == 'WASH_ORDER_CANCELLED');
      expect(entry.actorId, 'u1');
      expect(entry.metadataJson, contains('s1'));
    });

    test('voiding a payment records a PAYMENT_VOIDED entry with the approver attached', () async {
      final id = await startBasicWash();
      await repo.finishWash(id, [
        {'method': 'CASH', 'amount': 6000},
      ], actorId: 'u1');

      await repo.voidPayment(id, 'refund requested', actorId: 'u1', approvedByUserId: 's1');

      final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(id))).get();
      final entry = entries.singleWhere((e) => e.action == 'PAYMENT_VOIDED');
      expect(entry.actorId, 'u1');
      expect(entry.metadataJson, contains('s1'));
    });
  });
}
