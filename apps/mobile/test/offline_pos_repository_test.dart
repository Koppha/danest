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

  test('updating a service price offline applies to the cache immediately and preserves the tier, and queues a PATCH', () async {
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'premium', basePrice: 6000, durationMinutes: 15),
        );

    await repo.updateService(id: 'svc-1', name: 'Standard Wash', basePrice: 7500, durationMinutes: 20);

    final service = await db.select(db.localWashServices).getSingle();
    expect(service.basePrice, 7500);
    expect(service.durationMinutes, 20);
    expect(service.tier, 'premium'); // untouched field must survive the update

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'service');
    expect(outbox.single.opType, 'update');
  });

  test('updating an extra price offline applies to the cache immediately and queues a PATCH', () async {
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 2000),
        );

    await repo.updateExtra(id: 'ext-1', name: 'Tyre Shine', price: 2500);

    final extra = await db.select(db.localWashExtras).getSingle();
    expect(extra.price, 2500);

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
