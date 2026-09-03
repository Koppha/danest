import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/collections_repository.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/local/prepaid_repository.dart';
import 'package:de_nest/data/local/reports_repository.dart';
import 'package:de_nest/data/local/wash_orders_repository.dart';

void main() {
  late AppDatabase db;
  late ReportsRepository reports;
  late WashOrdersRepository washOrders;
  late PrepaidRepository prepaid;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    prepaid = PrepaidRepository(db);
    washOrders = WashOrdersRepository(db, prepaid, LoyaltyRepository(db));
    reports = ReportsRepository(db, CollectionsRepository(db));

    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
    await db.into(db.localVehicles).insert(
          LocalVehiclesCompanion.insert(id: 'v1', customerId: 'c1', regNumberNormalized: 'V1', regNumberDisplay: 'V1'),
        );
  });

  tearDown(() => db.close());

  DateTime monthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  Future<String> finishWash({String method = 'CASH', String vehicleId = 'v1'}) async {
    final order = await washOrders.startWash(vehicleId: vehicleId, customerId: 'c1', items: [
      {'itemType': 'SERVICE', 'serviceId': 'svc-1'},
    ], actorId: 'u1');
    await washOrders.finishWash(order.id, [
      {'method': method, 'amount': 6000},
    ], actorId: 'u1');
    return order.id;
  }

  group('summary', () {
    test('totalSales sums every non-voided payment method, not just cash', () async {
      await finishWash(method: 'CASH');
      await finishWash(method: 'CARD', vehicleId: 'v2');

      final s = await reports.summary(from: monthStart(), to: DateTime.now());
      expect(s.totalSales, 12000);
      expect(s.totalCompletedWashes, 2);
      expect(s.salesByMethod['Cash'], 6000);
      expect(s.salesByMethod['Card'], 6000);
    });

    test('a voided payment is excluded from sales and the completed-washes count', () async {
      final id = await finishWash();
      await washOrders.voidPayment(id, 'refund', actorId: 'u1', approvedByUserId: 's1');

      final s = await reports.summary(from: monthStart(), to: DateTime.now());
      expect(s.totalSales, 0);
      expect(s.totalCompletedWashes, 0);
    });

    test('totalFreeWashes counts washes redeemed via a loyalty reward, and only those', () async {
      final loyalty = LoyaltyRepository(db);
      final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1, 15);
      for (var i = 0; i < 5; i++) {
        await loyalty.creditQualifyingWash(
          vehicleId: 'v1',
          customerId: 'c1',
          scope: LoyaltyScope.vehicle,
          washOrderId: 'seed-wash-$i',
          at: lastMonth,
          actorId: 'u1',
        );
      }
      final rewardOrder = await washOrders.startWash(vehicleId: 'v1', customerId: 'c1', items: [
        {'itemType': 'SERVICE', 'serviceId': 'svc-1'},
      ], actorId: 'u1');
      await washOrders.finishWash(rewardOrder.id, [
        {'method': 'LOYALTY_FREE_WASH', 'amount': 6000},
      ], actorId: 'u1');
      await finishWash(method: 'CASH', vehicleId: 'v2'); // a normal wash, not a redemption

      final s = await reports.summary(from: monthStart(), to: DateTime.now());
      expect(s.totalFreeWashes, 1);
      expect(s.totalCompletedWashes, 2);
    });

    test('totalPrepaidDeposits includes every deposit method, unlike the cash-only collections figure', () async {
      await prepaid.deposit(customerId: 'c1', amount: 5000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await prepaid.deposit(customerId: 'c1', amount: 3000, method: 'CARD', clientEntryId: 'd2', actorId: 'u1');

      final s = await reports.summary(from: monthStart(), to: DateTime.now());
      expect(s.totalPrepaidDeposits, 8000);
    });

    test('netOperatingCash matches cash sales plus cash deposits minus cash expenses', () async {
      await finishWash(method: 'CASH');
      await prepaid.deposit(customerId: 'c1', amount: 2000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await db.into(db.localExpenses).insert(
            LocalExpensesCompanion.insert(
              id: 'e1',
              branchId: 'main',
              categoryId: 'cat-1',
              description: 'Detergent',
              amount: 1000,
              paymentMethod: 'CASH',
              createdAt: DateTime.now(),
            ),
          );

      final s = await reports.summary(from: monthStart(), to: DateTime.now());
      expect(s.netOperatingCash, 6000 + 2000 - 1000);
    });
  });

  group('transactions', () {
    test('lists a payment with its vehicle, methods, and voided flag', () async {
      await finishWash();

      final list = await reports.transactions(from: monthStart(), to: DateTime.now().add(const Duration(minutes: 1)));
      expect(list, hasLength(1));
      expect(list.single.id, isNotEmpty);
      expect(list.single.vehicleRegNumber, 'V1');
      expect(list.single.methods, ['CASH']);
      expect(list.single.voided, isFalse);
    });

    test('a voided payment still appears, flagged as voided', () async {
      final id = await finishWash();
      await washOrders.voidPayment(id, 'refund', actorId: 'u1', approvedByUserId: 's1');

      final list = await reports.transactions(from: monthStart(), to: DateTime.now().add(const Duration(minutes: 1)));
      expect(list.single.voided, isTrue);
    });
  });
}
