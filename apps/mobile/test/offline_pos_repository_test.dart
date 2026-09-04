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

  test('updating a customer changes name/phone, marks it dirty, audits it, and queues a PATCH', () async {
    final customer = await repo.createCustomer(fullName: 'Thabo Mokoena', phone: '+26658123456', branchId: 'branch-1');

    await repo.updateCustomer(id: customer.id, fullName: 'Thabo M. Mokoena', phone: '+26658999999', actorId: 'u1');

    final row = await (db.select(db.localCustomers)..where((c) => c.id.equals(customer.id))).getSingle();
    expect(row.fullName, 'Thabo M. Mokoena');
    expect(row.phone, '+26658999999');
    expect(row.active, true);

    final audit = await db.select(db.localAuditLog).get();
    expect(audit.any((a) => a.action == 'CUSTOMER_UPDATED' && a.entityId == customer.id), isTrue);

    final outbox = await (db.select(db.pendingSyncOps)..where((o) => o.opType.equals('update'))).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityId, customer.id);
  });

  test('updating a customer that does not exist throws instead of silently no-op-ing', () async {
    await expectLater(
      repo.updateCustomer(id: 'ghost', fullName: 'x', phone: 'y', actorId: 'u1'),
      throwsA(isA<CustomerNotFoundException>()),
    );
  });

  test('deleting a customer is a soft flag, not a row removal, and hides them from search', () async {
    final customer = await repo.createCustomer(fullName: 'Palesa Nkosi', phone: '+26658000000', branchId: 'branch-1');

    await repo.deleteCustomer(id: customer.id, actorId: 'u1');

    final row = await (db.select(db.localCustomers)..where((c) => c.id.equals(customer.id))).getSingle();
    expect(row.active, false);
    expect(row.fullName, 'Palesa Nkosi'); // history-preserving, not wiped

    final results = await repo.searchCustomers('');
    expect(results.any((c) => c.id == customer.id), isFalse);

    final audit = await db.select(db.localAuditLog).get();
    expect(audit.any((a) => a.action == 'CUSTOMER_DELETED' && a.entityId == customer.id), isTrue);

    final outbox = await (db.select(db.pendingSyncOps)..where((o) => o.opType.equals('delete'))).get();
    expect(outbox, hasLength(1));
  });

  test('deleting a customer that does not exist throws instead of silently no-op-ing', () async {
    await expectLater(
      repo.deleteCustomer(id: 'ghost', actorId: 'u1'),
      throwsA(isA<CustomerNotFoundException>()),
    );
  });

  test('a deleted customer is excluded from a filtered search too, not just the unfiltered list', () async {
    final customer = await repo.createCustomer(fullName: 'Kopano', phone: '62227247', branchId: 'branch-1');
    await repo.deleteCustomer(id: customer.id, actorId: 'u1');

    final results = await repo.searchCustomers('Kopano');
    expect(results, isEmpty);
  });

  test('creating a vehicle offline normalizes the registration number', () async {
    await repo.createVehicle(customerId: 'cust-1', regNumber: 'abc 123');
    final rows = await db.select(db.localVehicles).get();
    expect(rows.first.regNumberNormalized, 'ABC123');
    expect(rows.first.regNumberDisplay, 'ABC 123');
  });

  test('updating a service price applies immediately and preserves the tier', () async {
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'premium', basePrice: 6000, durationMinutes: 15),
        );

    await repo.updateService(id: 'svc-1', name: 'Standard Wash', basePrice: 7500, durationMinutes: 20);

    final service = await db.select(db.localWashServices).getSingle();
    expect(service.basePrice, 7500);
    expect(service.durationMinutes, 20);
    expect(service.tier, 'premium'); // untouched field must survive the update
  });

  test('creating a service is real and immediate, defaulting to the standard tier', () async {
    final created = await repo.createService(name: 'Premium Wash', basePrice: 9000, durationMinutes: 25);

    final service = await (db.select(db.localWashServices)..where((s) => s.id.equals(created.id))).getSingle();
    expect(service.name, 'Premium Wash');
    expect(service.basePrice, 9000);
    expect(service.tier, 'standard');
  });

  test('updating an extra price applies immediately', () async {
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 2000),
        );

    await repo.updateExtra(id: 'ext-1', name: 'Tyre Shine', price: 2500);

    final extra = await db.select(db.localWashExtras).getSingle();
    expect(extra.price, 2500);
  });

  test('creating an extra is real and immediate', () async {
    final created = await repo.createExtra(name: 'Air Freshener', price: 1500);

    final extra = await (db.select(db.localWashExtras)..where((e) => e.id.equals(created.id))).getSingle();
    expect(extra.name, 'Air Freshener');
    expect(extra.price, 1500);
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
