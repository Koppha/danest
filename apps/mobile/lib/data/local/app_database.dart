import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// [Migrator.addColumn] is a plain `ALTER TABLE ... ADD COLUMN`, with no
/// `IF NOT EXISTS` guard (SQLite has no such syntax for columns — unlike
/// `createTable`/`deleteTable`, which Drift already issues as `CREATE TABLE
/// IF NOT EXISTS`/`DROP TABLE IF EXISTS` and so are already safe to repeat).
/// If the app is ever killed between `onCreate` finishing (which creates
/// every table using today's Dart definitions, columns and all) and Drift
/// persisting the bumped `user_version`, the next launch replays every
/// `onUpgrade` step from scratch against a database that already has these
/// columns — a real, if narrow, first-launch crash window, not just a
/// hypothetical. Treating "already there" as success instead of a crash is
/// what makes that survivable.
Future<void> _addColumnIfMissing(Migrator m, TableInfo table, GeneratedColumn column) async {
  try {
    await m.addColumn(table, column);
  } on SqliteException catch (e) {
    if (!e.message.contains('duplicate column name')) rethrow;
  }
}

/// Reference data pulled from the server when online — read-only offline.
class LocalWashServices extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tier => text()();
  IntColumn get basePrice => integer()(); // cents
  IntColumn get durationMinutes => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalWashExtras extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get price => integer()(); // cents

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
  // Deleting a customer is a soft flag, not a row removal — they may have
  // real wash/loyalty/prepaid history that must keep resolving correctly.
  // Hidden from search (and so from New Wash's customer picker) once false.
  BoolColumn get active => boolean().withDefault(const Constant(true))();

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

/// Cached, read-only display of the vehicle's monthly loyalty progress.
/// Superseded by LocalLoyaltyLedger/LocalLoyaltyRewards (the real,
/// always-locally-computable source of truth now that there's no server
/// round-trip to avoid) — kept only so old rows don't linger as dead data;
/// nothing reads or writes it anymore.
class LocalLoyaltySummaries extends Table {
  TextColumn get vehicleId => text()();
  IntColumn get qualifyingCount => integer()();
  BoolColumn get hasAvailableReward => boolean()();
  DateTimeColumn get asOf => dateTime()();

  @override
  Set<Column> get primaryKey => {vehicleId};
}

/// Append-only — "qualifying count" is never a stored counter, always
/// recomputed by scanning this ledger. That's what makes crediting or
/// reversing the same wash twice safe to retry: `(washOrderId, eventType)`
/// can only ever appear once for the wash-linked event types
/// (WASH_CREDITED/WASH_REVERSED/REWARD_EARNED); MANAGER_ADJUSTMENT and
/// REWARD_REDEEMED rows aren't wash-order-keyed the same way and don't rely
/// on this constraint (multiple NULLs don't collide under it).
class LocalLoyaltyLedger extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  // Denormalized from the vehicle's owner at write time. Lets the same
  // append-only ledger be read either per-vehicle or pooled per-customer,
  // switched by a Settings toggle, without needing two separate ledgers or
  // a rewrite when the owner flips the setting. Nullable only so the
  // migration that adds this column can add it before backfilling it.
  TextColumn get customerId => text().nullable()();
  TextColumn get washOrderId => text().nullable()();
  TextColumn get eventType =>
      text()(); // WASH_CREDITED | WASH_REVERSED | REWARD_EARNED | REWARD_REDEEMED | REWARD_EXPIRED | MANAGER_ADJUSTMENT
  DateTimeColumn get periodMonth => dateTime()(); // first-of-month
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdById => text()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {washOrderId, eventType},
      ];
}

class LocalLoyaltyRewards extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  // Same denormalization as LocalLoyaltyLedger.customerId, same reason.
  TextColumn get customerId => text().nullable()();
  DateTimeColumn get earnedMonth => dateTime()();
  DateTimeColumn get validMonth => dateTime()();
  TextColumn get status => text().withDefault(const Constant('AVAILABLE'))(); // AVAILABLE | REDEEMED | EXPIRED | REVOKED
  TextColumn get earnedFromLedgerId => text()();
  TextColumn get redeemedWashOrderId => text().nullable()();
  DateTimeColumn get redeemedAt => dateTime().nullable()();
  DateTimeColumn get expiredAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

enum WashSyncStatus { pending, syncing, synced, failed }

class LocalWashOrders extends Table {
  TextColumn get id => text()(); // client-generated UUID, offline dedup key
  TextColumn get branchId => text()();
  TextColumn get vehicleId => text()();
  TextColumn get customerId => text()();
  TextColumn get status => text()(); // WAITING | WASHING | READY | COMPLETED | CANCELLED
  IntColumn get totalAmount => integer()(); // cents
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
  IntColumn get priceSnapshot => integer()(); // cents
  IntColumn get qty => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per status change (including the initial WAITING on creation) —
/// a full audit trail of a wash order's lifecycle.
class LocalWashStatusHistory extends Table {
  TextColumn get id => text()();
  TextColumn get washOrderId => text()();
  TextColumn get fromStatus => text().nullable()();
  TextColumn get toStatus => text()();
  TextColumn get changedById => text()();
  DateTimeColumn get changedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalPayments extends Table {
  TextColumn get id => text()();
  TextColumn get washOrderId => text()();
  IntColumn get totalAmount => integer()(); // cents
  DateTimeColumn get completedAt => dateTime()();
  BoolColumn get voided => boolean().withDefault(const Constant(false))();
  DateTimeColumn get voidedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalPaymentComponents extends Table {
  TextColumn get id => text()();
  TextColumn get paymentId => text()();
  TextColumn get method => text()();
  IntColumn get amount => integer()(); // cents
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
  IntColumn get amount => integer()(); // cents; negative on a reversal row, so sums net out automatically
  TextColumn get paymentMethod => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  // Set on the original once reversed, pointing at the compensating row.
  TextColumn get reversedByExpenseId => text().nullable()();
  // Set on the compensating row itself, pointing back at the original.
  TextColumn get reversalOfExpenseId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache of purchasable prepaid packages — read-only reference data.
class LocalPrepaidPackages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get eligibleTiers => text()(); // comma-separated; empty = all tiers
  IntColumn get washCount => integer()();
  IntColumn get price => integer()(); // cents
  IntColumn get validityDays => integer()();
  TextColumn get applicableScope => text()(); // ANY_VEHICLE_OF_CUSTOMER | SPECIFIC_VEHICLE

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per customer with a wallet. `balance` is a running total kept in
/// sync with LocalPrepaidWalletLedger on every write — always recomputable
/// from the ledger, cached here purely so reads don't have to re-sum it.
class LocalPrepaidWallets extends Table {
  TextColumn get customerId => text()();
  IntColumn get balance => integer()(); // cents
  DateTimeColumn get asOf => dateTime()();

  @override
  Set<Column> get primaryKey => {customerId};
}

/// Every wallet mutation, signed (+deposit/refund, -debit) — the real
/// history, not just a cached balance. `clientEntryId` is the idempotency
/// key: a retried deposit/debit/refund with the same id is a no-op.
class LocalPrepaidWalletLedger extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
  TextColumn get entryType => text()(); // DEPOSIT | DEBIT | ADJUSTMENT
  IntColumn get amount => integer()(); // cents, signed
  IntColumn get balanceAfter => integer()(); // cents
  TextColumn get method => text().nullable()(); // set on DEPOSIT only
  TextColumn get reference => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdById => text()();
  TextColumn get clientEntryId => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A customer's purchase of a prepaid wash bundle — the canonical record,
/// not a cache. `vehicleId` is set only when the package's applicableScope
/// is SPECIFIC_VEHICLE; null means it covers any vehicle of the customer.
class LocalPrepaidPackagePurchases extends Table {
  TextColumn get id => text()();
  TextColumn get packageId => text()();
  TextColumn get customerId => text()();
  TextColumn get vehicleId => text().nullable()();
  DateTimeColumn get purchasedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();
  IntColumn get remainingCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Idempotent per clientEntryId — one row per wash a package purchase was
/// spent on, decrementing that purchase's remainingCount by exactly one.
/// Refunding a void doesn't delete or flag this row (append-only, same as
/// the rest of the ledger); reconciling net usage means cross-referencing
/// void events separately.
class LocalPrepaidPackageUsage extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text()();
  TextColumn get washOrderId => text()();
  TextColumn get vehicleId => text()();
  DateTimeColumn get usedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get usedById => text()();
  TextColumn get clientEntryId => text().unique()();

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
  IntColumn get countedCash => integer()(); // cents
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
/// A single, append-only who-did-what trail spanning every module. The
/// domain ledgers (loyalty, prepaid, wash status history) already record
/// their own state changes in full detail; this exists for what those
/// don't cover — account management, PIN-gated reversals, cash counts —
/// so one screen can show a unified history instead of five.
class LocalAuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get actorId => text().nullable()(); // null only for pre-login system events
  TextColumn get action => text()(); // see AuditAction for the canonical list
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get metadataJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per SMS attempt — sent directly from the tablet now, with its
/// own retry/backoff state machine standing in for the NestJS cron this
/// was ported from.
class LocalSmsMessages extends Table {
  TextColumn get id => text()();
  TextColumn get washOrderId => text().nullable()();
  TextColumn get phone => text()();
  TextColumn get renderedBody => text()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // PENDING | SENT | FAILED
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get sentAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// History of local backup exports — [BackupRepository] writes one row per
/// attempt, success or failure, so a manager can see when the last one
/// actually worked.
class LocalBackupRuns extends Table {
  TextColumn get id => text()();
  TextColumn get filePath => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get status => text()(); // SUCCESS | FAILED
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

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
  LocalLoyaltyLedger,
  LocalLoyaltyRewards,
  LocalWashOrders,
  LocalWashOrderItems,
  LocalWashStatusHistory,
  LocalPayments,
  LocalPaymentComponents,
  PendingSyncOps,
  SyncMeta,
  LocalExpenseCategories,
  LocalExpenses,
  LocalPrepaidPackages,
  LocalPrepaidWallets,
  LocalPrepaidWalletLedger,
  LocalPrepaidPackagePurchases,
  LocalPrepaidPackageUsage,
  LocalCashCollections,
  LocalUsers,
  LocalAuditLog,
  LocalSmsMessages,
  LocalBackupRuns,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 13;

  // Default storage truncates DateTime to whole-second unix timestamps,
  // which let two events in the same second compare as equal instead of
  // ordered. Stored as ISO-8601 text instead, preserving full precision.
  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);

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
            // LocalPendingUsers used to be created here; it's dropped
            // unconditionally in the `from < 9` step below (deleteTable is
            // a no-op if it was never created), so there's nothing to do
            // for it at this step any more.
          }
          if (from < 3) {
            await m.createTable(localUsers);
          }
          if (from < 4) {
            // Money columns moved from REAL (currency units) to INTEGER
            // (cents) — the values themselves aren't reinterpretable
            // (they'd be off by 100x), and this is pre-release data with
            // nothing worth preserving, so every money-bearing table is
            // dropped and recreated empty rather than migrated in place.
            await m.deleteTable(localWashServices.actualTableName);
            await m.createTable(localWashServices);
            await m.deleteTable(localWashExtras.actualTableName);
            await m.createTable(localWashExtras);
            await m.deleteTable(localWashOrders.actualTableName);
            await m.createTable(localWashOrders);
            await m.deleteTable(localWashOrderItems.actualTableName);
            await m.createTable(localWashOrderItems);
            await m.deleteTable(localPayments.actualTableName);
            await m.createTable(localPayments);
            await m.deleteTable(localPaymentComponents.actualTableName);
            await m.createTable(localPaymentComponents);
            await m.deleteTable(localExpenses.actualTableName);
            await m.createTable(localExpenses);
            await m.deleteTable(localPrepaidPackages.actualTableName);
            await m.createTable(localPrepaidPackages);
            await m.deleteTable(localPrepaidWallets.actualTableName);
            await m.createTable(localPrepaidWallets);
            await m.deleteTable(localCashCollections.actualTableName);
            await m.createTable(localCashCollections);
          }
          if (from < 5) {
            await m.createTable(localLoyaltyLedger);
            await m.createTable(localLoyaltyRewards);
          }
          if (from < 6) {
            await m.createTable(localPrepaidWalletLedger);
            await m.createTable(localPrepaidPackageUsage);
            await _addColumnIfMissing(m, localPrepaidPackagePurchases, localPrepaidPackagePurchases.purchasedAt);
          }
          if (from < 7) {
            await m.createTable(localWashStatusHistory);
          }
          if (from < 8) {
            await _addColumnIfMissing(m, localPayments, localPayments.voided);
            await _addColumnIfMissing(m, localPayments, localPayments.voidedAt);
          }
          if (from < 9) {
            // Superseded by LocalUsers, which AuthRepository has written
            // directly to (bcrypt hash and all) since Phase 0 — nothing
            // reads this table any more.
            await m.deleteTable('local_pending_users');
            await m.createTable(localAuditLog);
            await _addColumnIfMissing(m, localExpenses, localExpenses.reversedByExpenseId);
            await _addColumnIfMissing(m, localExpenses, localExpenses.reversalOfExpenseId);
          }
          if (from < 10) {
            await m.createTable(localSmsMessages);
          }
          if (from < 11) {
            await m.createTable(localBackupRuns);
          }
          if (from < 12) {
            // Backfilled from the vehicle's current owner — a one-time,
            // best-effort denormalization, not a live-updating relation. If
            // a vehicle is ever reassigned to a different customer later,
            // historical ledger/reward rows keep the owner as of the wash,
            // which is the correct thing for a loyalty history anyway.
            await _addColumnIfMissing(m, localLoyaltyLedger, localLoyaltyLedger.customerId);
            await _addColumnIfMissing(m, localLoyaltyRewards, localLoyaltyRewards.customerId);
            await customStatement(
              'UPDATE local_loyalty_ledger SET customer_id = '
              '(SELECT customer_id FROM local_vehicles WHERE local_vehicles.id = local_loyalty_ledger.vehicle_id) '
              'WHERE customer_id IS NULL',
            );
            await customStatement(
              'UPDATE local_loyalty_rewards SET customer_id = '
              '(SELECT customer_id FROM local_vehicles WHERE local_vehicles.id = local_loyalty_rewards.vehicle_id) '
              'WHERE customer_id IS NULL',
            );
          }
          if (from < 13) {
            await _addColumnIfMissing(m, localCustomers, localCustomers.active);
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
