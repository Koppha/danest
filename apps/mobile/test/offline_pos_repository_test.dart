import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/local/offline_pos_repository.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late OfflinePosRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      // Forced offline: these tests exercise the "no connectivity" path
      // (the online push path is covered by the manual end-to-end run
      // against the real backend, not unit tests, since it needs a live
      // Dio/server round trip).
      connectivityProvider.overrideWith(() => _AlwaysOffline()),
      appDatabaseProvider.overrideWithValue(db),
    ]);
    repo = container.read(offlinePosRepositoryProvider);
  });

  tearDown(() async {
    await db.close();
    container.dispose();
  });

  test('creating a customer offline writes it locally and queues an outbox entry', () async {
    final customer = await repo.createCustomer(fullName: 'Thabo Mokoena', phone: '+26658123456', branchId: 'branch-1');

    final rows = await db.select(db.localCustomers).get();
    expect(rows.length, 1);
    expect(rows.first.fullName, 'Thabo Mokoena');
    expect(rows.first.dirty, true);

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox.length, 1);
    expect(outbox.first.entityType, 'customer');
    expect(outbox.first.entityId, customer.id);
  });

  test('creating a vehicle offline normalizes the registration number', () async {
    await repo.createVehicle(customerId: 'cust-1', regNumber: 'abc 123');
    final rows = await db.select(db.localVehicles).get();
    expect(rows.first.regNumberNormalized, 'ABC123');
    expect(rows.first.regNumberDisplay, 'ABC 123');
  });

  test('starting a wash offline computes the total from the cached catalog', () async {
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 60, durationMinutes: 15),
        );
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 20),
        );

    final wash = await repo.startWash(
      branchId: 'branch-1',
      vehicleId: 'veh-1',
      customerId: 'cust-1',
      items: [
        {'itemType': 'SERVICE', 'serviceId': 'svc-1'},
        {'itemType': 'EXTRA', 'extraId': 'ext-1'},
      ],
    );

    expect(wash.totalAmount, 80);
    final orders = await db.select(db.localWashOrders).get();
    expect(orders.first.status, 'WAITING');
    final items = await db.select(db.localWashOrderItems).get();
    expect(items.length, 2);
  });

  test('finishing a wash offline with cash succeeds and marks the wash COMPLETED', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );

    await repo.finishWash('wash-1', [
      {'method': 'CASH', 'amount': 60},
    ]);

    final orders = await db.select(db.localWashOrders).get();
    expect(orders.first.status, 'COMPLETED');
    final payments = await db.select(db.localPayments).get();
    expect(payments.length, 1);
  });

  test('finishing a wash offline with a wallet payment is rejected when nothing is cached for that customer', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );

    await expectLater(
      repo.finishWash('wash-1', [
        {'method': 'WALLET', 'amount': 60},
      ]),
      throwsA(isA<OfflineInsufficientCachedBalanceException>()),
    );

    // The wash must be left untouched, not partially completed.
    final orders = await db.select(db.localWashOrders).get();
    expect(orders.first.status, 'READY');
  });

  test('finishing a wash offline with a wallet payment succeeds when the cached balance covers it, and debits the cache', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );
    await db.into(db.localPrepaidWallets).insert(
          LocalPrepaidWalletsCompanion.insert(customerId: 'c', balance: 100, asOf: DateTime.now()),
        );

    await repo.finishWash('wash-1', [
      {'method': 'WALLET', 'amount': 60},
    ]);

    final orders = await db.select(db.localWashOrders).get();
    expect(orders.first.status, 'COMPLETED');
    final wallet = await db.select(db.localPrepaidWallets).getSingle();
    expect(wallet.balance, 40); // debited so this device can't spend it twice
  });

  test('finishing a wash offline with a wallet payment is rejected when the cached balance is insufficient', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );
    await db.into(db.localPrepaidWallets).insert(
          LocalPrepaidWalletsCompanion.insert(customerId: 'c', balance: 30, asOf: DateTime.now()),
        );

    await expectLater(
      repo.finishWash('wash-1', [
        {'method': 'WALLET', 'amount': 60},
      ]),
      throwsA(isA<OfflineInsufficientCachedBalanceException>()),
    );
  });

  test('finishing a wash offline with a loyalty free wash is rejected when nothing is cached as available', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );

    await expectLater(
      repo.finishWash('wash-1', [
        {'method': 'LOYALTY_FREE_WASH', 'amount': 60},
      ]),
      throwsA(isA<OfflineInsufficientCachedBalanceException>()),
    );
  });

  test('finishing a wash offline with a loyalty free wash succeeds when cached as available, and marks it spent', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );
    await db.into(db.localLoyaltySummaries).insert(
          LocalLoyaltySummariesCompanion.insert(vehicleId: 'v', qualifyingCount: 5, hasAvailableReward: true, asOf: DateTime.now()),
        );

    await repo.finishWash('wash-1', [
      {'method': 'LOYALTY_FREE_WASH', 'amount': 60},
    ]);

    final orders = await db.select(db.localWashOrders).get();
    expect(orders.first.status, 'COMPLETED');
    final loyalty = await db.select(db.localLoyaltySummaries).getSingle();
    expect(loyalty.hasAvailableReward, isFalse); // spent, so this device can't redeem it twice
  });

  test('finishing a wash offline with a package payment succeeds when a cached purchase has washes remaining, and decrements it', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );
    await db.into(db.localPrepaidPackagePurchases).insert(
          LocalPrepaidPackagePurchasesCompanion.insert(
            id: 'pp-1',
            packageId: 'pkg-1',
            customerId: 'c',
            expiresAt: DateTime.now().add(const Duration(days: 10)),
            remainingCount: 2,
          ),
        );

    await repo.finishWash('wash-1', [
      {'method': 'PACKAGE', 'amount': 0},
    ]);

    final purchase = await db.select(db.localPrepaidPackagePurchases).getSingle();
    expect(purchase.remainingCount, 1);
  });

  test('finishing a wash offline with a package payment is rejected when the cached purchase has no washes remaining', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'READY', totalAmount: 60, createdAt: DateTime.now()),
        );
    await db.into(db.localPrepaidPackagePurchases).insert(
          LocalPrepaidPackagePurchasesCompanion.insert(
            id: 'pp-1',
            packageId: 'pkg-1',
            customerId: 'c',
            expiresAt: DateTime.now().add(const Duration(days: 10)),
            remainingCount: 0,
          ),
        );

    await expectLater(
      repo.finishWash('wash-1', [
        {'method': 'PACKAGE', 'amount': 0},
      ]),
      throwsA(isA<OfflineInsufficientCachedBalanceException>()),
    );
  });

  test('the wash queue reads from the local cache when offline', () async {
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(id: 'wash-1', branchId: 'b', vehicleId: 'v', customerId: 'c', status: 'WAITING', totalAmount: 60, createdAt: DateTime.now()),
        );
    final queue = await repo.queue();
    expect(queue.length, 1);
    expect(queue.first.status, 'WAITING');
  });

  test('updating a service price offline applies to the cache immediately and preserves the tier, and queues a PATCH', () async {
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'premium', basePrice: 60, durationMinutes: 15),
        );

    await repo.updateService(id: 'svc-1', name: 'Standard Wash', basePrice: 75, durationMinutes: 20);

    final service = await db.select(db.localWashServices).getSingle();
    expect(service.basePrice, 75);
    expect(service.durationMinutes, 20);
    expect(service.tier, 'premium'); // untouched field must survive the update

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'service');
    expect(outbox.single.opType, 'update');
  });

  test('updating an extra price offline applies to the cache immediately and queues a PATCH', () async {
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 20),
        );

    await repo.updateExtra(id: 'ext-1', name: 'Tyre Shine', price: 25);

    final extra = await db.select(db.localWashExtras).getSingle();
    expect(extra.price, 25);

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'extra');
    expect(outbox.single.opType, 'update');
  });

  test('creating a user offline stores it as pending (with the plaintext password, until synced) and lists it as pending', () async {
    await repo.createUser(branchId: 'branch-1', fullName: 'New Attendant', username: 'newattendant', password: 'supersecret1', role: 'ATTENDANT');

    final pendingUsers = await db.select(db.localPendingUsers).get();
    expect(pendingUsers, hasLength(1));
    expect(pendingUsers.single.password, 'supersecret1');

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'user');
    expect(outbox.single.opType, 'create');

    final listed = await repo.listUsers();
    expect(listed, hasLength(1));
    expect(listed.single['pending'], isTrue);
    expect(listed.single['username'], 'newattendant');
  });

  test('watchFailedSyncOps only surfaces FAILED rows, and dismissSyncIssue removes one for good', () async {
    await db.into(db.pendingSyncOps).insert(
          PendingSyncOpsCompanion.insert(
            entityType: 'user',
            entityId: 'u-1',
            opType: 'create',
            payloadJson: '{}',
            idempotencyKey: 'create:user:u-1:a',
            status: const Value('FAILED'),
            lastError: const Value('Username already taken'),
          ),
        );
    final stillPendingId = await db.into(db.pendingSyncOps).insertReturning(
          PendingSyncOpsCompanion.insert(
            entityType: 'expense',
            entityId: 'e-1',
            opType: 'create',
            payloadJson: '{}',
            idempotencyKey: 'create:expense:e-1:b',
          ),
        );
    expect(stillPendingId.status, 'PENDING'); // sanity: not surfaced as an issue

    final failed = await repo.watchFailedSyncOps().first;
    expect(failed, hasLength(1));
    expect(failed.single.entityType, 'user');
    expect(failed.single.lastError, 'Username already taken');

    await repo.dismissSyncIssue(failed.single.rowId);

    final remaining = await db.select(db.pendingSyncOps).get();
    expect(remaining, hasLength(1));
    expect(remaining.single.entityType, 'expense'); // the still-pending op is untouched
  });
}

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}
