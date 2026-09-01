import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Reference data pulled from the server when online — read-only offline.
class LocalWashServices extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tier => text()();
  RealColumn get basePrice => real()();
  IntColumn get durationMinutes => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalWashExtras extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Customers/vehicles: created offline get a client UUID and `dirty=true`
/// until pushed; ones pulled from the server are clean/read-write cached.
class LocalCustomers extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get fullName => text()();
  TextColumn get phone => text()();
  TextColumn get altPhone => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalVehicles extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  TextColumn get regNumberNormalized => text()();
  TextColumn get regNumberDisplay => text()();
  TextColumn get make => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get colour => text().nullable()();
  TextColumn get vehicleType => text().withDefault(const Constant('SEDAN'))();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cached, read-only display of the vehicle's monthly loyalty progress —
/// redemption of a free wash still requires connectivity (the reward's
/// validity must be checked live), this is for showing the badge meter.
class LocalLoyaltySummaries extends Table {
  TextColumn get vehicleId => text()();
  IntColumn get qualifyingCount => integer()();
  BoolColumn get hasAvailableReward => boolean()();
  DateTimeColumn get asOf => dateTime()();

  @override
  Set<Column> get primaryKey => {vehicleId};
}

enum WashSyncStatus { pending, syncing, synced, failed }

class LocalWashOrders extends Table {
  TextColumn get id => text()(); // client-generated UUID, offline dedup key
  TextColumn get branchId => text()();
  TextColumn get vehicleId => text()();
  TextColumn get customerId => text()();
  TextColumn get status => text()(); // WAITING | WASHING | READY | COMPLETED | CANCELLED
  RealColumn get totalAmount => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  TextColumn get cancelReason => text().nullable()();
  TextColumn get syncStatus => textEnum<WashSyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalWashOrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get washOrderId => text()();
  TextColumn get itemType => text()(); // SERVICE | EXTRA
  TextColumn get serviceId => text().nullable()();
  TextColumn get extraId => text().nullable()();
  TextColumn get nameSnapshot => text()();
  RealColumn get priceSnapshot => real()();
  IntColumn get qty => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Only qualifying-without-a-live-check methods are allowed offline: CASH,
/// CARD, MOBILE_MONEY, BANK_TRANSFER. WALLET/PACKAGE/LOYALTY_FREE_WASH
/// require an online balance/validity check and are disabled in the UI
/// when offline — see NewWash/FinishWash screens.
class LocalPayments extends Table {
  TextColumn get id => text()();
  TextColumn get washOrderId => text()();
  RealColumn get totalAmount => real()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalPaymentComponents extends Table {
  TextColumn get id => text()();
  TextColumn get paymentId => text()();
  TextColumn get method => text()();
  RealColumn get amount => real()();
  TextColumn get externalReference => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The outbox: every offline-created/modified entity gets one row here,
/// keyed by a deterministic idempotency key so retries and duplicate
/// pushes are safe. Coalesced on (entityType, entityId, opType) — a second
/// local edit before the first sync just updates the existing row.
class PendingSyncOps extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get entityType => text()(); // customer | vehicle | wash_order | payment
  TextColumn get entityId => text()();
  TextColumn get opType => text()(); // create | transition | finish
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // PENDING | SYNCING | FAILED
  TextColumn get lastError => text().nullable()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
}

/// Per-reference-table pull cursor, so a resumed sync only re-fetches what
/// changed since last time.
class SyncMeta extends Table {
  TextColumn get key => text()();
  DateTimeColumn get lastPulledAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  LocalWashServices,
  LocalWashExtras,
  LocalCustomers,
  LocalVehicles,
  LocalLoyaltySummaries,
  LocalWashOrders,
  LocalWashOrderItems,
  LocalPayments,
  LocalPaymentComponents,
  PendingSyncOps,
  SyncMeta,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'de_nest.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
