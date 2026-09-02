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

/// Cache of active expense categories — read-only, refreshed alongside the
/// wash-service/extra catalog.
class LocalExpenseCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Expenses created offline get a client UUID and `dirty=true` until pushed
/// — same pattern as LocalCustomers.
class LocalExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get categoryId => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache of purchasable prepaid packages — read-only reference data.
class LocalPrepaidPackages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get eligibleTiers => text()(); // comma-separated; empty = all tiers
  IntColumn get washCount => integer()();
  RealColumn get price => real()();
  IntColumn get validityDays => integer()();
  TextColumn get applicableScope => text()(); // ANY_VEHICLE_OF_CUSTOMER | SPECIFIC_VEHICLE

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per customer with a wallet — cached balance, refreshed on every
/// online overview fetch and optimistically mutated on offline
/// deposits/spends. The server remains authoritative: a spend that turns
/// out to exceed the real balance is rejected at sync time and surfaces in
/// the Sync Issues screen rather than failing silently.
class LocalPrepaidWallets extends Table {
  TextColumn get customerId => text()();
  RealColumn get balance => real()();
  DateTimeColumn get asOf => dateTime()();

  @override
  Set<Column> get primaryKey => {customerId};
}

/// Cached prepaid package purchases, for offline eligibility checks
/// (tier/vehicle/expiry/remaining-count) before allowing an offline PACKAGE
/// spend — same "provisional, server can still reject" model as the wallet.
class LocalPrepaidPackagePurchases extends Table {
  TextColumn get id => text()();
  TextColumn get packageId => text()();
  TextColumn get customerId => text()();
  TextColumn get vehicleId => text().nullable()();
  DateTimeColumn get expiresAt => dateTime()();
  IntColumn get remainingCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cash collection confirmations queued offline. Deliberately has no
/// expected/variance/result columns — computeExpected() aggregates every
/// device's transactions since the last cutoff, which a single offline
/// device cannot know. The server computes those once the sync lands,
/// using `countedAt` (not "now") as the period end.
class LocalCashCollections extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  RealColumn get countedCash => real()();
  TextColumn get varianceReason => text().nullable()();
  TextColumn get witness => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get countedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Users created offline. Holds the plaintext password only until it syncs
/// — password hashing is server-only (argon2), so this account cannot log
/// in anywhere until the create request actually reaches the server.
class LocalPendingUsers extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get pin => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The device's own local user directory — no server, so this is the
/// permanent credential store, not a cache. `passwordHash`/`pinHash` are
/// bcrypt hashes; plaintext credentials are never persisted.
class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get pinHash => text().nullable()();
  TextColumn get role => text()(); // ATTENDANT | SUPERVISOR | ADMINISTRATOR | OWNER
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
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
  LocalExpenseCategories,
  LocalExpenses,
  LocalPrepaidPackages,
  LocalPrepaidWallets,
  LocalPrepaidPackagePurchases,
  LocalCashCollections,
  LocalPendingUsers,
  LocalUsers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(localExpenseCategories);
            await m.createTable(localExpenses);
            await m.createTable(localPrepaidPackages);
            await m.createTable(localPrepaidWallets);
            await m.createTable(localPrepaidPackagePurchases);
            await m.createTable(localCashCollections);
            await m.createTable(localPendingUsers);
          }
          if (from < 3) {
            await m.createTable(localUsers);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'de_nest.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
