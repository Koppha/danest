import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'collections_repository.dart';
import 'database_provider.dart';

/// Human labels for payment method codes, in the order they should appear
/// in a breakdown — matches what the backend this was ported from rendered
/// directly as the "sales by method" map keys.
const paymentMethodLabels = {
  'CASH': 'Cash',
  'CARD': 'Card',
  'MOBILE_MONEY': 'Mobile Money',
  'BANK_TRANSFER': 'Bank Transfer',
  'WALLET': 'Wallet',
  'PACKAGE': 'Free Wash',
  'LOYALTY_FREE_WASH': 'Loyalty Free Wash',
};

class ReportsSummary {
  final int totalSales;
  final int totalCompletedWashes;
  final int totalFreeWashes;
  final int totalPrepaidDeposits;
  final Map<String, int> salesByMethod; // label -> cents, zero entries omitted
  final int netOperatingCash;

  ReportsSummary({
    required this.totalSales,
    required this.totalCompletedWashes,
    required this.totalFreeWashes,
    required this.totalPrepaidDeposits,
    required this.salesByMethod,
    required this.netOperatingCash,
  });
}

class TransactionSummary {
  final String id;
  final String? vehicleRegNumber;
  final int totalAmount;
  final List<String> methods;
  final bool voided;
  final DateTime completedAt;

  TransactionSummary({
    required this.id,
    required this.vehicleRegNumber,
    required this.totalAmount,
    required this.methods,
    required this.voided,
    required this.completedAt,
  });
}

/// Reports/transactions used to be the two screens with no offline path at
/// all — every number here is now a local query instead of a server
/// round-trip. The money breakdown reuses [CollectionsRepository]'s
/// computation (same cash-sales/deposits/refunds/expenses logic, just over
/// an arbitrary date range instead of "since the last confirmed count").
class ReportsRepository {
  final AppDatabase _db;
  final CollectionsRepository _collections;
  ReportsRepository(this._db, this._collections);

  Future<ReportsSummary> summary({required DateTime from, required DateTime to}) async {
    final expected = await _collections.computeExpected(periodStart: from, periodEnd: to);

    final completedPayments = await (_db.select(_db.localPayments)
          ..where((p) => p.completedAt.isBiggerOrEqualValue(from) & p.completedAt.isSmallerThanValue(to) & p.voided.equals(false)))
        .get();

    var freeWashes = 0;
    for (final p in completedPayments) {
      final hasFreeWash = await (_db.select(_db.localPaymentComponents)
            ..where((c) => c.paymentId.equals(p.id) & c.method.equals('LOYALTY_FREE_WASH')))
          .get();
      if (hasFreeWash.isNotEmpty) freeWashes++;
    }

    final deposits = await (_db.select(_db.localPrepaidWalletLedger)
          ..where(
            (l) => l.entryType.equals('DEPOSIT') & l.createdAt.isBiggerOrEqualValue(from) & l.createdAt.isSmallerThanValue(to),
          ))
        .get();
    final totalPrepaidDeposits = deposits.fold<int>(0, (sum, d) => sum + d.amount);

    final byMethod = {
      'CASH': expected.cashSales,
      'CARD': expected.cardTotal,
      'MOBILE_MONEY': expected.mobileMoneyTotal,
      'BANK_TRANSFER': expected.bankTransferTotal,
      'WALLET': expected.walletTotal,
      'PACKAGE': expected.packageUsageTotal,
      'LOYALTY_FREE_WASH': expected.loyaltyRedemptionsTotal,
    };
    final salesByMethod = <String, int>{
      for (final entry in byMethod.entries)
        if (entry.value > 0) paymentMethodLabels[entry.key]!: entry.value,
    };
    final totalSales = byMethod.values.fold<int>(0, (sum, v) => sum + v);

    return ReportsSummary(
      totalSales: totalSales,
      totalCompletedWashes: completedPayments.length,
      totalFreeWashes: freeWashes,
      totalPrepaidDeposits: totalPrepaidDeposits,
      salesByMethod: salesByMethod,
      netOperatingCash: expected.expected,
    );
  }

  Future<List<TransactionSummary>> transactions({required DateTime from, required DateTime to}) async {
    final payments = await (_db.select(_db.localPayments)
          ..where((p) => p.completedAt.isBiggerOrEqualValue(from) & p.completedAt.isSmallerThanValue(to))
          ..orderBy([(p) => OrderingTerm.desc(p.completedAt)]))
        .get();

    final out = <TransactionSummary>[];
    for (final p in payments) {
      final components = await (_db.select(_db.localPaymentComponents)..where((c) => c.paymentId.equals(p.id))).get();
      final wash = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(p.washOrderId))).getSingleOrNull();
      String? regNumber;
      if (wash != null) {
        final vehicle = await (_db.select(_db.localVehicles)..where((v) => v.id.equals(wash.vehicleId))).getSingleOrNull();
        regNumber = vehicle?.regNumberDisplay;
      }
      out.add(TransactionSummary(
        id: p.id,
        vehicleRegNumber: regNumber,
        totalAmount: p.totalAmount,
        methods: components.map((c) => c.method).toList(),
        voided: p.voided,
        completedAt: p.completedAt,
      ));
    }
    return out;
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => ReportsRepository(ref.watch(appDatabaseProvider), ref.watch(collectionsRepositoryProvider)),
);
