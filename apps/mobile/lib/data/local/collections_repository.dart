import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';
import 'audit_log.dart';
import 'database_provider.dart';

const _uuid = Uuid();

class PeriodEndBeforeCutoffException implements Exception {
  @override
  String toString() => 'periodEnd must be after the last collection cut-off';
}

class VarianceReasonRequiredException implements Exception {
  @override
  String toString() => 'A reason is required when actual cash does not match expected cash';
}

/// MATCHED | SHORT | OVER. Safe to compare exactly now that money is
/// integer cents — the backend this was ported from had to compare
/// floating-point sums for this, a genuinely fragile equality check.
String collectionResultFor({required int countedCash, required int expected}) {
  final variance = countedCash - expected;
  if (variance == 0) return 'MATCHED';
  return variance < 0 ? 'SHORT' : 'OVER';
}

/// What the till should hold, and why — computed fresh from local
/// transactions since the last confirmed collection. There's only ever one
/// device now, so this is just a straightforward local query; the backend
/// this was ported from needed this to aggregate across every device,
/// which no single device could ever know on its own.
class CollectionsExpected {
  final int cashSales;
  final int cashRefunds;
  final int cashDeposits;
  final int cashExpenses;
  final int cardTotal;
  final int mobileMoneyTotal;
  final int bankTransferTotal;
  final int walletTotal;
  final int packageUsageTotal;
  final int loyaltyRedemptionsTotal;
  final DateTime periodStart;
  final DateTime periodEnd;

  CollectionsExpected({
    required this.cashSales,
    required this.cashRefunds,
    required this.cashDeposits,
    required this.cashExpenses,
    required this.cardTotal,
    required this.mobileMoneyTotal,
    required this.bankTransferTotal,
    required this.walletTotal,
    required this.packageUsageTotal,
    required this.loyaltyRedemptionsTotal,
    required this.periodStart,
    required this.periodEnd,
  });

  int get expected => cashSales + cashDeposits - cashRefunds - cashExpenses;
}

class CollectionsRepository {
  final AppDatabase _db;
  CollectionsRepository(this._db);

  /// The end-timestamp of the most recently confirmed collection, or epoch
  /// if none yet — one running cursor, since single-device means single
  /// implicit branch.
  Future<DateTime> lastCollectionCutoff() async {
    final last = await (_db.select(_db.localCashCollections)..orderBy([(c) => OrderingTerm.desc(c.countedAt)])).getSingleOrNull();
    return last?.countedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<CollectionsExpected> computeExpected({DateTime? periodEnd}) async {
    final periodStart = await lastCollectionCutoff();
    final end = periodEnd ?? DateTime.now();
    if (!end.isAfter(periodStart)) throw PeriodEndBeforeCutoffException();

    final payments = await (_db.select(_db.localPayments)
          ..where((p) => p.completedAt.isBiggerOrEqualValue(periodStart) & p.completedAt.isSmallerThanValue(end)))
        .get();
    final voidedInWindow = await (_db.select(_db.localPayments)
          ..where((p) => p.voided.equals(true) & p.voidedAt.isBiggerOrEqualValue(periodStart) & p.voidedAt.isSmallerThanValue(end)))
        .get();
    final deposits = await (_db.select(_db.localPrepaidWalletLedger)
          ..where(
            (l) =>
                l.entryType.equals('DEPOSIT') &
                l.method.equals('CASH') &
                l.createdAt.isBiggerOrEqualValue(periodStart) &
                l.createdAt.isSmallerThanValue(end),
          ))
        .get();
    final expenses = await (_db.select(_db.localExpenses)
          ..where(
            (e) =>
                e.paymentMethod.equals('CASH') &
                e.createdAt.isBiggerOrEqualValue(periodStart) &
                e.createdAt.isSmallerThanValue(end),
          ))
        .get();

    Future<int> sumComponents(List<LocalPayment> forPayments, String method) async {
      var total = 0;
      for (final p in forPayments) {
        final components =
            await (_db.select(_db.localPaymentComponents)..where((c) => c.paymentId.equals(p.id) & c.method.equals(method))).get();
        for (final c in components) {
          total += c.amount;
        }
      }
      return total;
    }

    final cashSales = await sumComponents(payments.where((p) => !p.voided).toList(), 'CASH');
    final cashRefunds = await sumComponents(voidedInWindow, 'CASH');
    final cardTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'CARD');
    final mobileMoneyTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'MOBILE_MONEY');
    final bankTransferTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'BANK_TRANSFER');
    // WALLET is deliberately included here — the backend this was ported
    // from left it out of both the cash total (correctly — that cash was
    // already counted when the deposit happened) and this verification
    // breakdown (a documented gap), leaving a manager unable to see how
    // much was spent via wallet in the period at all.
    final walletTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'WALLET');
    final packageUsageTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'PACKAGE');
    final loyaltyRedemptionsTotal = await sumComponents(payments.where((p) => !p.voided).toList(), 'LOYALTY_FREE_WASH');
    final cashDeposits = deposits.fold<int>(0, (sum, d) => sum + d.amount);
    // Expense reversal rows carry a negative amount and net out automatically.
    final cashExpenses = expenses.fold<int>(0, (sum, e) => sum + e.amount);

    return CollectionsExpected(
      cashSales: cashSales,
      cashRefunds: cashRefunds,
      cashDeposits: cashDeposits,
      cashExpenses: cashExpenses,
      cardTotal: cardTotal,
      mobileMoneyTotal: mobileMoneyTotal,
      bankTransferTotal: bankTransferTotal,
      walletTotal: walletTotal,
      packageUsageTotal: packageUsageTotal,
      loyaltyRedemptionsTotal: loyaltyRedemptionsTotal,
      periodStart: periodStart,
      periodEnd: end,
    );
  }

  /// Idempotent on [id]. [countedAt] is the attendant's own wall-clock time
  /// of the count — using that as periodEnd (not "now") means a delayed
  /// confirm never absorbs transactions the attendant never actually saw.
  Future<LocalCashCollection> confirm({
    String? id,
    String? varianceReason,
    String? witness,
    String? notes,
    required int countedCash,
    required DateTime countedAt,
    required String actorId,
  }) async {
    if (id != null) {
      final existing = await (_db.select(_db.localCashCollections)..where((c) => c.id.equals(id))).getSingleOrNull();
      if (existing != null) return existing;
    }
    final expected = await computeExpected(periodEnd: countedAt);
    final result = collectionResultFor(countedCash: countedCash, expected: expected.expected);
    if (result != 'MATCHED' && (varianceReason == null || varianceReason.trim().isEmpty)) {
      throw VarianceReasonRequiredException();
    }

    final collectionId = id ?? _uuid.v4();
    await _db.into(_db.localCashCollections).insert(
          LocalCashCollectionsCompanion.insert(
            id: collectionId,
            branchId: 'main',
            countedCash: countedCash,
            varianceReason: Value(varianceReason),
            witness: Value(witness),
            notes: Value(notes),
            countedAt: countedAt,
          ),
        );
    await recordAudit(
      _db,
      action: AuditAction.cashCollectionConfirmed,
      actorId: actorId,
      entityType: 'CashCollection',
      entityId: collectionId,
      metadata: {'countedCash': countedCash, 'expected': expected.expected, 'result': result},
    );
    return (await (_db.select(_db.localCashCollections)..where((c) => c.id.equals(collectionId))).getSingle());
  }

  Future<List<LocalCashCollection>> list() =>
      (_db.select(_db.localCashCollections)..orderBy([(c) => OrderingTerm.desc(c.countedAt)])).get();
}

final collectionsRepositoryProvider = Provider<CollectionsRepository>((ref) => CollectionsRepository(ref.watch(appDatabaseProvider)));
