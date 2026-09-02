import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/prepaid_repository.dart';

void main() {
  late AppDatabase db;
  late PrepaidRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = PrepaidRepository(db);
  });

  tearDown(() => db.close());

  group('wallet', () {
    test('a new customer has a zero balance', () async {
      expect(await repo.walletBalance('c1'), 0);
    });

    test('deposits are additive and never touch loyalty', () async {
      await repo.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await repo.deposit(customerId: 'c1', amount: 5000, method: 'CARD', clientEntryId: 'd2', actorId: 'u1');
      expect(await repo.walletBalance('c1'), 15000);

      final ledger = await db.select(db.localPrepaidWalletLedger).get();
      expect(ledger, hasLength(2));
      expect(ledger.every((l) => l.entryType == 'DEPOSIT'), isTrue);
    });

    test('a deposit retried with the same clientEntryId is a no-op', () async {
      await repo.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await repo.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      expect(await repo.walletBalance('c1'), 10000);
      expect(await db.select(db.localPrepaidWalletLedger).get(), hasLength(1));
    });

    test('debiting more than the balance throws and changes nothing', () async {
      await repo.deposit(customerId: 'c1', amount: 3000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await expectLater(
        repo.debitForWash(customerId: 'c1', amount: 6000, washOrderId: 'w1', clientEntryId: 'x1', actorId: 'u1'),
        throwsA(isA<InsufficientWalletBalanceException>()),
      );
      expect(await repo.walletBalance('c1'), 3000);
    });

    test('debiting a customer with no wallet at all throws (not a crash)', () async {
      await expectLater(
        repo.debitForWash(customerId: 'ghost', amount: 100, washOrderId: 'w1', clientEntryId: 'x1', actorId: 'u1'),
        throwsA(isA<InsufficientWalletBalanceException>()),
      );
    });

    test('a wash-finish debit retried with the same clientEntryId never double-debits', () async {
      await repo.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await repo.debitForWash(customerId: 'c1', amount: 6000, washOrderId: 'w1', clientEntryId: 'finish:w1:wallet', actorId: 'u1');
      await repo.debitForWash(customerId: 'c1', amount: 6000, washOrderId: 'w1', clientEntryId: 'finish:w1:wallet', actorId: 'u1');
      expect(await repo.walletBalance('c1'), 4000); // debited once, not twice
    });

    test('refundToWallet credits the balance back and is idempotent, distinct from a deposit', () async {
      await repo.deposit(customerId: 'c1', amount: 10000, method: 'CASH', clientEntryId: 'd1', actorId: 'u1');
      await repo.debitForWash(customerId: 'c1', amount: 6000, washOrderId: 'w1', clientEntryId: 'finish:w1:wallet', actorId: 'u1');

      await repo.refundToWallet(customerId: 'c1', amount: 6000, reference: 'Void refund: wash w1', clientEntryId: 'void:w1:wallet', actorId: 'u1');
      await repo.refundToWallet(customerId: 'c1', amount: 6000, reference: 'Void refund: wash w1', clientEntryId: 'void:w1:wallet', actorId: 'u1');
      expect(await repo.walletBalance('c1'), 10000); // refunded once

      final adjustment = (await db.select(db.localPrepaidWalletLedger).get()).firstWhere((l) => l.entryType == 'ADJUSTMENT');
      expect(adjustment.amount, 6000);
    });

    test('refundToWallet works even if the customer never had a wallet row yet', () async {
      await repo.refundToWallet(customerId: 'new-customer', amount: 500, reference: 'goodwill', clientEntryId: 'r1', actorId: 'u1');
      expect(await repo.walletBalance('new-customer'), 500);
    });
  });

  group('packages', () {
    Future<void> seedPackage({
      String id = 'pkg-1',
      List<String> tiers = const [],
      int washCount = 5,
      int price = 20000,
      int validityDays = 90,
      String scope = 'ANY_VEHICLE_OF_CUSTOMER',
    }) =>
        db.into(db.localPrepaidPackages).insert(
              LocalPrepaidPackagesCompanion.insert(
                id: id,
                name: 'Test Package',
                eligibleTiers: tiers.join(','),
                washCount: washCount,
                price: price,
                validityDays: validityDays,
                applicableScope: scope,
              ),
            );

    test('purchasing a package sets remainingCount to the package washCount and expiresAt from validityDays', () async {
      await seedPackage(washCount: 5, validityDays: 30);
      final before = DateTime.now();
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      expect(purchase.remainingCount, 5);
      final expectedExpiry = before.add(const Duration(days: 30));
      expect(purchase.expiresAt.difference(expectedExpiry).inSeconds.abs(), lessThan(5));
    });

    test('purchasing a SPECIFIC_VEHICLE package without a vehicle throws', () async {
      await seedPackage(scope: 'SPECIFIC_VEHICLE');
      await expectLater(repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1'), throwsA(isA<VehicleRequiredException>()));
    });

    test('purchasing the same id twice returns the existing purchase (idempotent)', () async {
      await seedPackage();
      final first = await repo.purchasePackage(id: 'purchase-1', customerId: 'c1', packageId: 'pkg-1');
      final second = await repo.purchasePackage(id: 'purchase-1', customerId: 'c1', packageId: 'pkg-1');
      expect(second.id, first.id);
      expect(await db.select(db.localPrepaidPackagePurchases).get(), hasLength(1));
    });

    test('findApplicablePurchase picks the soonest-expiring purchase that covers the tier, not the cheapest or most specific', () async {
      await seedPackage(id: 'pkg-standard', tiers: ['standard']);
      await seedPackage(id: 'pkg-any', tiers: []); // covers every tier
      final soonExpiring = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-any');
      await db.update(db.localPrepaidPackagePurchases).replace(
            soonExpiring.copyWith(expiresAt: DateTime.now().add(const Duration(days: 5))),
          );
      final laterExpiring = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-standard');
      await db.update(db.localPrepaidPackagePurchases).replace(
            laterExpiring.copyWith(expiresAt: DateTime.now().add(const Duration(days: 60))),
          );

      final applicable = await repo.findApplicablePurchase('c1', 'v1', 'standard');
      expect(applicable?.id, soonExpiring.id); // both cover 'standard'; sooner-expiring wins
    });

    test('findApplicablePurchase skips a purchase whose package does not cover the requested tier', () async {
      await seedPackage(id: 'pkg-deluxe', tiers: ['deluxe']);
      await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-deluxe');
      expect(await repo.findApplicablePurchase('c1', 'v1', 'standard'), isNull);
    });

    test('findApplicablePurchase matches a SPECIFIC_VEHICLE purchase only for its own vehicle', () async {
      await seedPackage(scope: 'SPECIFIC_VEHICLE');
      await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1', vehicleId: 'v1');
      expect(await repo.findApplicablePurchase('c1', 'v1', 'standard'), isNotNull);
      expect(await repo.findApplicablePurchase('c1', 'v2', 'standard'), isNull);
    });

    test('findApplicablePurchase ignores an expired or exhausted purchase', () async {
      await seedPackage(washCount: 1);
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      await repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'u1', actorId: 'u1');
      expect(await repo.findApplicablePurchase('c1', 'v1', 'standard'), isNull); // exhausted
    });

    test('useForWash decrements remainingCount and is idempotent on clientEntryId', () async {
      await seedPackage(washCount: 3);
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      await repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'finish:w1:package', actorId: 'u1');
      await repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'finish:w1:package', actorId: 'u1');

      final updated = await (db.select(db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchase.id))).getSingle();
      expect(updated.remainingCount, 2); // decremented once, not twice
    });

    test('useForWash throws when the purchase has no washes remaining, even bypassing findApplicablePurchase', () async {
      await seedPackage(washCount: 0);
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      await expectLater(
        repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'x1', actorId: 'u1'),
        throwsA(isA<PackageExhaustedException>()),
      );
    });

    test('refundPackageUsage gives the wash back without touching the original usage row', () async {
      await seedPackage(washCount: 3);
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      await repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'c1', actorId: 'u1');
      await repo.refundPackageUsage(purchase.id);

      final updated = await (db.select(db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchase.id))).getSingle();
      expect(updated.remainingCount, 3);
      expect(await db.select(db.localPrepaidPackageUsage).get(), hasLength(1)); // usage row untouched
    });

    test('customerOverview includes an unexpired purchase even with zero washes remaining', () async {
      await seedPackage(washCount: 1, validityDays: 30);
      final purchase = await repo.purchasePackage(customerId: 'c1', packageId: 'pkg-1');
      await repo.useForWash(purchaseId: purchase.id, washOrderId: 'w1', vehicleId: 'v1', clientEntryId: 'x1', actorId: 'u1');

      final overview = await repo.customerOverview('c1');
      expect(overview['balance'], 0);
      expect((overview['packages'] as List), hasLength(1));
      expect((overview['packages'] as List).single['remainingCount'], 0);
    });
  });
}
