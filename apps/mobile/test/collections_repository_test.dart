import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/collections_repository.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/local/prepaid_repository.dart';
import 'package:de_nest/data/local/wash_orders_repository.dart';

void main() {
  late AppDatabase db;
  late CollectionsRepository collections;
  late WashOrdersRepository washOrders;
  late PrepaidRepository prepaid;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    collections = CollectionsRepository(db);
    prepaid = PrepaidRepository(db);
    washOrders = WashOrdersRepository(db, prepaid, LoyaltyRepository(db));

    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
  });

  tearDown(() => db.close());

  Future<String> finishCashWash({String method = 'CASH', String? reference}) async {
    final order = await washOrders.startWash(vehicleId: 'v1', customerId: 'c1', items: [
      {'itemType': 'SERVICE', 'serviceId': 'svc-1'},
    ], actorId: 'u1');
    await washOrders.finishWash(order.id, [
      {'method': method, 'amount': 6000, if (reference != null) 'externalReference': reference},
    ], actorId: 'u1');
    return order.id;
  }

  test('lastCollectionCutoff is epoch when nothing has ever been confirmed', () async {
    final cutoff = await collections.lastCollectionCutoff();
    expect(cutoff, DateTime.fromMillisecondsSinceEpoch(0));
  });

  test('computeExpected throws if periodEnd is not after the cutoff', () async {
    await expectLater(
      collections.computeExpected(periodEnd: DateTime.fromMillisecondsSinceEpoch(0)),
      throwsA(isA<PeriodEndBeforeCutoffException>()),
    );
  });

  test('a cash sale contributes to cashSales and the expected total', () async {
    await finishCashWash();
    final expected = await collections.computeExpected();
    expect(expected.cashSales, 6000);
    expect(expected.expected, 6000);
  });

  test('a card sale does not contribute to cashSales, but shows in the verification breakdown', () async {
    await finishCashWash(method: 'CARD');
    final expected = await collections.computeExpected();
    expect(expected.cashSales, 0);
    expect(expected.cardTotal, 6000);
    expect(expected.expected, 0);
  });

  test('a cash deposit to a wallet contributes to cashDeposits and the expected total', () async {
    await prepaid.deposit(customerId: 'c1', amount: 5000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
    final expected = await collections.computeExpected();
    expect(expected.cashDeposits, 5000);
    expect(expected.expected, 5000);
  });

  test('a cash expense reduces the expected total', () async {
    await db.into(db.localExpenses).insert(
          LocalExpensesCompanion.insert(
            id: 'e1',
            branchId: 'main',
            categoryId: 'cat-1',
            description: 'Detergent',
            amount: 1500,
            paymentMethod: 'CASH',
            createdAt: DateTime.now(),
          ),
        );
    await finishCashWash();
    final expected = await collections.computeExpected();
    expect(expected.cashExpenses, 1500);
    expect(expected.expected, 6000 - 1500);
  });

  test('a voided cash sale is windowed by voidedAt, not completedAt', () async {
    final washId = await finishCashWash();
    // Confirm one collection now, so the void below lands in a *new* window.
    await collections.confirm(countedCash: 6000, countedAt: DateTime.now(), actorId: 'u1');

    await washOrders.voidPayment(washId, 'customer disputed', actorId: 'u1', approvedByUserId: 's1');
    final expected = await collections.computeExpected();
    // The sale itself is before this window's cutoff, but the void just
    // happened — it's the refund's window that matters, not the sale's.
    expect(expected.cashSales, 0);
    expect(expected.cashRefunds, 6000);
    expect(expected.expected, -6000);
  });

  test('WALLET payments show in the verification breakdown (fixing the backend\'s documented gap)', () async {
    await prepaid.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
    await finishCashWash(method: 'WALLET');
    final expected = await collections.computeExpected();
    expect(expected.walletTotal, 6000);
    // Wallet spend isn't cash moving today — already counted at deposit time.
    expect(expected.cashSales, 0);
  });

  group('confirm', () {
    test('matching the counted cash to expected needs no reason and results in MATCHED', () async {
      await finishCashWash();
      final collection = await collections.confirm(countedCash: 6000, countedAt: DateTime.now(), actorId: 'u1');
      expect(collectionResultFor(countedCash: collection.countedCash, expected: 6000), 'MATCHED');
    });

    test('confirming records a CASH_COLLECTION_CONFIRMED audit entry', () async {
      await finishCashWash();
      final collection = await collections.confirm(countedCash: 6000, countedAt: DateTime.now(), actorId: 'u1');

      final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(collection.id))).get();
      expect(entries, hasLength(1));
      expect(entries.single.action, 'CASH_COLLECTION_CONFIRMED');
      expect(entries.single.actorId, 'u1');
    });

    test('a mismatch without a reason is rejected', () async {
      await finishCashWash();
      await expectLater(
        collections.confirm(countedCash: 5000, countedAt: DateTime.now(), actorId: 'u1'),
        throwsA(isA<VarianceReasonRequiredException>()),
      );
    });

    test('a mismatch with a reason succeeds and is classified SHORT or OVER correctly', () async {
      await finishCashWash();
      await collections.confirm(countedCash: 5000, countedAt: DateTime.now(), varianceReason: 'Miscounted', actorId: 'u1');
      expect(collectionResultFor(countedCash: 5000, expected: 6000), 'SHORT');
      expect(collectionResultFor(countedCash: 7000, expected: 6000), 'OVER');
    });

    test('confirming with the same id twice is idempotent', () async {
      await finishCashWash();
      final first = await collections.confirm(id: 'fixed-id', countedCash: 6000, countedAt: DateTime.now(), actorId: 'u1');
      final second = await collections.confirm(id: 'fixed-id', countedCash: 6000, countedAt: DateTime.now(), actorId: 'u1');
      expect(second.id, first.id);
      expect(await db.select(db.localCashCollections).get(), hasLength(1));
    });

    test('using the attendant-supplied countedAt as periodEnd excludes transactions after it', () async {
      final earlier = DateTime.now().subtract(const Duration(hours: 2));
      await finishCashWash(); // happens "now", after `earlier`
      final expected = await collections.computeExpected(periodEnd: earlier);
      expect(expected.cashSales, 0); // the sale hadn't happened yet as of `earlier`
    });
  });
}
