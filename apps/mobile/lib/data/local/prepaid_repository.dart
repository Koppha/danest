import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

/// Thrown by [PrepaidRepository.debitForWash] when the wallet doesn't have
/// enough balance to cover the requested amount.
class InsufficientWalletBalanceException implements Exception {
  final int available;
  final int requested;
  InsufficientWalletBalanceException(this.available, this.requested);
  @override
  String toString() => 'Insufficient prepaid balance: available $available, requested $requested';
}

/// Thrown by [PrepaidRepository.useForWash] when the purchase has no washes
/// left — a defensive re-check even though [findApplicablePurchase] already
/// filters on remainingCount, in case a caller skips straight to useForWash.
class PackageExhaustedException implements Exception {
  @override
  String toString() => 'This package has no washes remaining';
}

/// Thrown by [PrepaidRepository.purchasePackage] when a SPECIFIC_VEHICLE
/// package is bought without naming which vehicle it covers.
class VehicleRequiredException implements Exception {
  @override
  String toString() => 'This package requires a specific vehicle to be selected';
}

/// Two independent sub-systems sharing one customer-facing "prepaid"
/// concept: a wallet (cash-value balance) and packages (prepaid bundles of
/// N washes). Both are backed by real append-only ledgers now, not a
/// provisional cache the server could still override.
class PrepaidRepository {
  final AppDatabase _db;
  PrepaidRepository(this._db);

  // -------------------------------------------------------------- wallet

  Future<LocalPrepaidWallet> _getOrCreateWallet(String customerId) async {
    final existing = await (_db.select(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).getSingleOrNull();
    if (existing != null) return existing;
    final row = LocalPrepaidWalletsCompanion.insert(customerId: customerId, balance: 0, asOf: DateTime.now());
    await _db.into(_db.localPrepaidWallets).insert(row);
    return (await (_db.select(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).getSingle());
  }

  Future<int> walletBalance(String customerId) async {
    final wallet = await (_db.select(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).getSingleOrNull();
    return wallet?.balance ?? 0;
  }

  /// Purely additive — never a double-spend risk. Idempotent on
  /// [clientEntryId]. Deposits are explicitly never credited to the
  /// loyalty ledger — only actually washing counts toward the reward.
  Future<void> deposit({
    required String customerId,
    required int amount, // cents
    required String method,
    String? reference,
    required String clientEntryId,
    required String actorId,
  }) async {
    final existing =
        await (_db.select(_db.localPrepaidWalletLedger)..where((l) => l.clientEntryId.equals(clientEntryId))).getSingleOrNull();
    if (existing != null) return;

    final wallet = await _getOrCreateWallet(customerId);
    final newBalance = wallet.balance + amount;
    await _db.into(_db.localPrepaidWalletLedger).insert(
          LocalPrepaidWalletLedgerCompanion.insert(
            id: _uuid.v4(),
            customerId: customerId,
            entryType: 'DEPOSIT',
            amount: amount,
            balanceAfter: newBalance,
            method: Value(method),
            reference: Value(reference ?? '$method deposit'),
            createdById: actorId,
            clientEntryId: clientEntryId,
          ),
        );
    await (_db.update(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).write(
      LocalPrepaidWalletsCompanion(balance: Value(newBalance), asOf: Value(DateTime.now())),
    );
  }

  /// Idempotent on [clientEntryId] — a retried wash-finish never double
  /// debits. Throws [InsufficientWalletBalanceException] if the cached
  /// balance can't cover it; this is the one real enforcement point for the
  /// non-negative-balance invariant (no DB-level backstop, deliberately).
  Future<void> debitForWash({
    required String customerId,
    required int amount, // cents
    required String washOrderId,
    required String clientEntryId,
    required String actorId,
  }) async {
    final existing =
        await (_db.select(_db.localPrepaidWalletLedger)..where((l) => l.clientEntryId.equals(clientEntryId))).getSingleOrNull();
    if (existing != null) return;

    final wallet = await (_db.select(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).getSingleOrNull();
    if (wallet == null || wallet.balance < amount) {
      throw InsufficientWalletBalanceException(wallet?.balance ?? 0, amount);
    }
    final newBalance = wallet.balance - amount;
    await _db.into(_db.localPrepaidWalletLedger).insert(
          LocalPrepaidWalletLedgerCompanion.insert(
            id: _uuid.v4(),
            customerId: customerId,
            entryType: 'DEBIT',
            amount: -amount,
            balanceAfter: newBalance,
            reference: Value('Wash $washOrderId'),
            createdById: actorId,
            clientEntryId: clientEntryId,
          ),
        );
    await (_db.update(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).write(
      LocalPrepaidWalletsCompanion(balance: Value(newBalance), asOf: Value(DateTime.now())),
    );
  }

  /// The compensating credit used when voiding a payment. Idempotent on
  /// [clientEntryId]. Distinct entry type from DEPOSIT — this is a system
  /// correction, not new money the customer put in.
  Future<void> refundToWallet({
    required String customerId,
    required int amount, // cents
    required String reference,
    required String clientEntryId,
    required String actorId,
  }) async {
    final existing =
        await (_db.select(_db.localPrepaidWalletLedger)..where((l) => l.clientEntryId.equals(clientEntryId))).getSingleOrNull();
    if (existing != null) return;

    final wallet = await _getOrCreateWallet(customerId);
    final newBalance = wallet.balance + amount;
    await _db.into(_db.localPrepaidWalletLedger).insert(
          LocalPrepaidWalletLedgerCompanion.insert(
            id: _uuid.v4(),
            customerId: customerId,
            entryType: 'ADJUSTMENT',
            amount: amount,
            balanceAfter: newBalance,
            reference: Value(reference),
            createdById: actorId,
            clientEntryId: clientEntryId,
          ),
        );
    await (_db.update(_db.localPrepaidWallets)..where((w) => w.customerId.equals(customerId))).write(
      LocalPrepaidWalletsCompanion(balance: Value(newBalance), asOf: Value(DateTime.now())),
    );
  }

  // ------------------------------------------------------------ packages

  Future<List<LocalPrepaidPackage>> listPackages() => _db.select(_db.localPrepaidPackages).get();

  /// Idempotent on [id] if supplied (client-UUID re-fetch-and-return
  /// pattern, same as customers/vehicles/wash orders). SPECIFIC_VEHICLE
  /// packages require a vehicleId; ANY_VEHICLE_OF_CUSTOMER ignores it.
  Future<LocalPrepaidPackagePurchase> purchasePackage({
    String? id,
    required String customerId,
    required String packageId,
    String? vehicleId,
  }) async {
    if (id != null) {
      final existing = await (_db.select(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(id))).getSingleOrNull();
      if (existing != null) return existing;
    }
    final package = await (_db.select(_db.localPrepaidPackages)..where((p) => p.id.equals(packageId))).getSingle();
    if (package.applicableScope == 'SPECIFIC_VEHICLE' && vehicleId == null) {
      throw VehicleRequiredException();
    }
    final purchaseId = id ?? _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.localPrepaidPackagePurchases).insert(
          LocalPrepaidPackagePurchasesCompanion.insert(
            id: purchaseId,
            packageId: packageId,
            customerId: customerId,
            vehicleId: Value(vehicleId),
            purchasedAt: Value(now),
            expiresAt: now.add(Duration(days: package.validityDays)),
            remainingCount: package.washCount,
          ),
        );
    return (await (_db.select(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchaseId))).getSingle());
  }

  /// Among purchases covering this vehicle (either scoped to it directly,
  /// or covering "any vehicle of the customer"), not expired, with washes
  /// remaining, and whose package's eligibleTiers is either empty ("covers
  /// every tier") or explicitly contains [tier] — returns the one expiring
  /// soonest. A customer can hold several simultaneous packages; the
  /// soonest-to-expire one that actually covers this tier is always spent
  /// first, never "cheapest" or "most specific."
  Future<LocalPrepaidPackagePurchase?> findApplicablePurchase(String customerId, String vehicleId, String tier) async {
    final purchases = await (_db.select(_db.localPrepaidPackagePurchases)
          ..where(
            (p) =>
                p.customerId.equals(customerId) &
                p.expiresAt.isBiggerThanValue(DateTime.now()) &
                p.remainingCount.isBiggerThanValue(0) &
                (p.vehicleId.isNull() | p.vehicleId.equals(vehicleId)),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.expiresAt)]))
        .get();
    final packageRows = await _db.select(_db.localPrepaidPackages).get();
    final packagesById = {for (final pk in packageRows) pk.id: pk};
    for (final purchase in purchases) {
      final package = packagesById[purchase.packageId];
      final tiers = package == null || package.eligibleTiers.isEmpty ? const <String>[] : package.eligibleTiers.split(',');
      if (tiers.isEmpty || tiers.contains(tier)) return purchase;
    }
    return null;
  }

  /// Idempotent on [clientEntryId]. Re-checks remainingCount defensively
  /// even though [findApplicablePurchase] already filtered on it.
  Future<void> useForWash({
    required String purchaseId,
    required String washOrderId,
    required String vehicleId,
    required String clientEntryId,
    required String actorId,
  }) async {
    final existing =
        await (_db.select(_db.localPrepaidPackageUsage)..where((u) => u.clientEntryId.equals(clientEntryId))).getSingleOrNull();
    if (existing != null) return;

    final purchase = await (_db.select(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchaseId))).getSingle();
    if (purchase.remainingCount <= 0) throw PackageExhaustedException();

    await _db.into(_db.localPrepaidPackageUsage).insert(
          LocalPrepaidPackageUsageCompanion.insert(
            id: _uuid.v4(),
            purchaseId: purchaseId,
            washOrderId: washOrderId,
            vehicleId: vehicleId,
            usedById: actorId,
            clientEntryId: clientEntryId,
          ),
        );
    await (_db.update(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchaseId))).write(
      LocalPrepaidPackagePurchasesCompanion(remainingCount: Value(purchase.remainingCount - 1)),
    );
  }

  /// The compensating credit used when voiding a payment — simply gives the
  /// wash back. Does not delete or flag the original usage row (append-only
  /// ledger philosophy, same as the wallet).
  Future<void> refundPackageUsage(String purchaseId) async {
    final purchase = await (_db.select(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchaseId))).getSingle();
    await (_db.update(_db.localPrepaidPackagePurchases)..where((p) => p.id.equals(purchaseId))).write(
      LocalPrepaidPackagePurchasesCompanion(remainingCount: Value(purchase.remainingCount + 1)),
    );
  }

  /// {balance, packages: [unexpired purchases with package details]} — only
  /// filters on expiry, not remainingCount, so a purchase with 0 washes
  /// left but not yet expired still shows.
  Future<Map<String, dynamic>> customerOverview(String customerId) async {
    final balance = await walletBalance(customerId);
    final purchases = await (_db.select(_db.localPrepaidPackagePurchases)
          ..where((p) => p.customerId.equals(customerId) & p.expiresAt.isBiggerThanValue(DateTime.now())))
        .get();
    final packageRows = await _db.select(_db.localPrepaidPackages).get();
    final packagesById = {for (final pk in packageRows) pk.id: pk};
    return {
      'balance': balance,
      'packages': purchases.map((p) {
        final pkg = packagesById[p.packageId];
        return {
          'id': p.id,
          'packageId': p.packageId,
          'customerId': p.customerId,
          'vehicleId': p.vehicleId,
          'expiresAt': p.expiresAt.toIso8601String(),
          'remainingCount': p.remainingCount,
          'package': {
            'id': p.packageId,
            'name': pkg?.name ?? 'Unknown',
            'eligibleTiers': pkg == null || pkg.eligibleTiers.isEmpty ? <String>[] : pkg.eligibleTiers.split(','),
          },
        };
      }).toList(),
    };
  }
}

final prepaidRepositoryProvider = Provider<PrepaidRepository>((ref) => PrepaidRepository(ref.watch(appDatabaseProvider)));
