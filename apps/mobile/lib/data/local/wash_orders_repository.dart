import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/session.dart';
import '../models/models.dart';
import 'app_database.dart';
import 'database_provider.dart';
import 'loyalty_repository.dart';
import 'prepaid_repository.dart';

const _uuid = Uuid();

/// Everything except LOYALTY_FREE_WASH counts toward the qualifying-wash
/// count — redeeming a free wash can't itself earn another one.
const _qualifyingMethods = {'CASH', 'CARD', 'MOBILE_MONEY', 'BANK_TRANSFER', 'WALLET', 'PACKAGE'};
const _referenceRequiredMethods = {'MOBILE_MONEY', 'BANK_TRANSFER'};

const _legalTransitions = <String, Set<String>>{
  'WAITING': {'WASHING', 'CANCELLED'},
  'WASHING': {'READY', 'CANCELLED'},
  'READY': {'WASHING', 'CANCELLED'},
  // COMPLETED and CANCELLED are terminal — absent here means "no legal exit".
};

bool isLegalWashTransition(String from, String to) => _legalTransitions[from]?.contains(to) ?? false;

class WashNotFoundException implements Exception {
  @override
  String toString() => 'Wash order not found';
}

class IllegalWashTransitionException implements Exception {
  final String from;
  final String to;
  IllegalWashTransitionException(this.from, this.to);
  @override
  String toString() => 'Cannot move a wash from $from to $to';
}

class WashAlreadyCancelledException implements Exception {
  @override
  String toString() => 'This wash was cancelled and cannot be completed';
}

class PaymentAmountMismatchException implements Exception {
  final int componentsTotal;
  final int orderTotal;
  PaymentAmountMismatchException(this.componentsTotal, this.orderTotal);
  @override
  String toString() => 'Payment components sum to $componentsTotal but the wash total is $orderTotal';
}

class ReferenceRequiredException implements Exception {
  final String method;
  ReferenceRequiredException(this.method);
  @override
  String toString() => '$method requires an external reference';
}

class NoApplicablePackageException implements Exception {
  @override
  String toString() => 'No active package covers this service for this vehicle';
}

class NoAvailableRewardException implements Exception {
  @override
  String toString() => 'No free wash is available for this vehicle this month';
}

class NoActivePaymentException implements Exception {
  @override
  String toString() => 'This wash has no active payment to void';
}

/// The wash-order lifecycle and its money flow — the real business logic,
/// not a provisional offline guess. There's no server left to defer to, so
/// this is authoritative: it either succeeds outright or throws.
class WashOrdersRepository {
  final AppDatabase _db;
  final PrepaidRepository _prepaid;
  final LoyaltyRepository _loyalty;
  WashOrdersRepository(this._db, this._prepaid, this._loyalty);

  Future<List<WashOrder>> queue() async {
    final rows = await (_db.select(_db.localWashOrders)
          ..where((w) => w.status.isIn(['WAITING', 'WASHING', 'READY']))
          ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
        .get();
    final out = <WashOrder>[];
    for (final w in rows) {
      out.add(await _toWashOrder(w));
    }
    return out;
  }

  Future<WashOrder> _toWashOrder(LocalWashOrder w) async {
    final vehicle = await (_db.select(_db.localVehicles)..where((v) => v.id.equals(w.vehicleId))).getSingleOrNull();
    final customer = await (_db.select(_db.localCustomers)..where((c) => c.id.equals(w.customerId))).getSingleOrNull();
    return WashOrder(
      id: w.id,
      status: w.status,
      totalAmount: w.totalAmount,
      createdAt: w.createdAt,
      vehicle: vehicle == null
          ? null
          : Vehicle(id: vehicle.id, customerId: vehicle.customerId, regNumberDisplay: vehicle.regNumberDisplay),
      customer: customer == null ? null : Customer(id: customer.id, fullName: customer.fullName, phone: customer.phone),
    );
  }

  Future<void> _appendHistory({required String washOrderId, String? from, required String to, required String actorId}) {
    return _db.into(_db.localWashStatusHistory).insert(
          LocalWashStatusHistoryCompanion.insert(
            id: _uuid.v4(),
            washOrderId: washOrderId,
            fromStatus: Value(from),
            toStatus: to,
            changedById: actorId,
          ),
        );
  }

  /// Idempotent on [id] — a retried create returns the existing order
  /// unchanged, no re-pricing. Prices are snapshotted from the current
  /// catalog at creation time so later price changes never retroactively
  /// affect an existing order.
  Future<WashOrder> startWash({
    String? id,
    required String vehicleId,
    required String customerId,
    required List<Map<String, dynamic>> items,
    required String actorId,
  }) async {
    if (id != null) {
      final existing = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(id))).getSingleOrNull();
      if (existing != null) return _toWashOrder(existing);
    }
    final washId = id ?? _uuid.v4();
    final services = await _db.select(_db.localWashServices).get();
    final extras = await _db.select(_db.localWashExtras).get();
    int total = 0;
    final itemRows = <LocalWashOrderItemsCompanion>[];
    for (final item in items) {
      if (item['itemType'] == 'SERVICE') {
        final svc = services.firstWhere((s) => s.id == item['serviceId']);
        total += svc.basePrice;
        itemRows.add(LocalWashOrderItemsCompanion.insert(
          id: _uuid.v4(),
          washOrderId: washId,
          itemType: 'SERVICE',
          serviceId: Value(svc.id),
          nameSnapshot: svc.name,
          priceSnapshot: svc.basePrice,
        ));
      } else {
        final extra = extras.firstWhere((e) => e.id == item['extraId']);
        total += extra.price;
        itemRows.add(LocalWashOrderItemsCompanion.insert(
          id: _uuid.v4(),
          washOrderId: washId,
          itemType: 'EXTRA',
          extraId: Value(extra.id),
          nameSnapshot: extra.name,
          priceSnapshot: extra.price,
        ));
      }
    }

    await _db.transaction(() async {
      await _db.into(_db.localWashOrders).insert(
            LocalWashOrdersCompanion.insert(
              id: washId,
              branchId: localBranchId,
              vehicleId: vehicleId,
              customerId: customerId,
              status: 'WAITING',
              totalAmount: total,
              createdAt: DateTime.now(),
            ),
          );
      await _db.batch((batch) => batch.insertAll(_db.localWashOrderItems, itemRows));
      await _appendHistory(washOrderId: washId, to: 'WAITING', actorId: actorId);
    });

    return WashOrder(id: washId, status: 'WAITING', totalAmount: total, createdAt: DateTime.now());
  }

  /// Only WASHING or READY — cancellation goes through [cancel] instead.
  /// WAITING -> READY directly is illegal (must pass through WASHING).
  Future<void> transition(String washOrderId, String toStatus, {required String actorId}) async {
    final wash = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).getSingleOrNull();
    if (wash == null) throw WashNotFoundException();
    if (!isLegalWashTransition(wash.status, toStatus)) {
      throw IllegalWashTransitionException(wash.status, toStatus);
    }
    await _db.transaction(() async {
      await (_db.update(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).write(
        LocalWashOrdersCompanion(status: Value(toStatus)),
      );
      await _appendHistory(washOrderId: washOrderId, from: wash.status, to: toStatus, actorId: actorId);
    });
  }

  /// PIN-gated at the UI layer — this method trusts [approvedByUserId] was
  /// already verified by a supervisor-or-above's PIN before being called.
  Future<void> cancel(String washOrderId, String reason, {required String actorId, required String approvedByUserId}) async {
    final wash = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).getSingleOrNull();
    if (wash == null) throw WashNotFoundException();
    if (!isLegalWashTransition(wash.status, 'CANCELLED')) {
      throw IllegalWashTransitionException(wash.status, 'CANCELLED');
    }
    await _db.transaction(() async {
      await (_db.update(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).write(
        LocalWashOrdersCompanion(status: const Value('CANCELLED'), cancelledAt: Value(DateTime.now()), cancelReason: Value(reason)),
      );
      await _appendHistory(washOrderId: washOrderId, from: wash.status, to: 'CANCELLED', actorId: actorId);
    });
  }

  /// The full finish/payment orchestration. Not gated on the wash being
  /// READY — WAITING or WASHING can be paid directly too (going through the
  /// queue to READY first is a UX convention, not an enforced rule).
  Future<WashOrder> finishWash(String washOrderId, List<Map<String, dynamic>> components, {required String actorId}) async {
    final wash = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).getSingleOrNull();
    if (wash == null) throw WashNotFoundException();

    if (wash.status == 'COMPLETED') return _toWashOrder(wash); // idempotent no-op
    if (wash.status == 'CANCELLED') throw WashAlreadyCancelledException();

    final componentsTotal = components.fold<int>(0, (sum, c) => sum + (c['amount'] as num).toInt());
    if (componentsTotal != wash.totalAmount) {
      throw PaymentAmountMismatchException(componentsTotal, wash.totalAmount);
    }
    for (final c in components) {
      final method = c['method'] as String;
      final reference = c['externalReference'] as String?;
      if (_referenceRequiredMethods.contains(method) && (reference == null || reference.trim().isEmpty)) {
        throw ReferenceRequiredException(method);
      }
    }

    // Tier resolution: only the first SERVICE line item's (current) tier
    // matters for package eligibility; defaults to 'standard' if the order
    // is all-extras somehow.
    final items = await (_db.select(_db.localWashOrderItems)..where((i) => i.washOrderId.equals(washOrderId))).get();
    String tier = 'standard';
    final firstService = items.firstWhereOrNull((i) => i.itemType == 'SERVICE' && i.serviceId != null);
    if (firstService != null) {
      final service = await (_db.select(_db.localWashServices)..where((s) => s.id.equals(firstService.serviceId!))).getSingleOrNull();
      tier = service?.tier ?? 'standard';
    }

    final paymentId = _uuid.v4();
    // Each component's side effect runs sequentially, in submitted order,
    // *before* the payment/components/status rows are written — if any of
    // these throws, nothing below has happened yet, so there's nothing to
    // roll back.
    for (final c in components) {
      final method = c['method'] as String;
      final amount = (c['amount'] as num).toInt();
      switch (method) {
        case 'WALLET':
          await _prepaid.debitForWash(
            customerId: wash.customerId,
            amount: amount,
            washOrderId: washOrderId,
            clientEntryId: 'finish:$washOrderId:wallet',
            actorId: actorId,
          );
        case 'PACKAGE':
          final purchase = await _prepaid.findApplicablePurchase(wash.customerId, wash.vehicleId, tier);
          if (purchase == null) throw NoApplicablePackageException();
          await _prepaid.useForWash(
            purchaseId: purchase.id,
            washOrderId: washOrderId,
            vehicleId: wash.vehicleId,
            clientEntryId: 'finish:$washOrderId:package',
            actorId: actorId,
          );
        case 'LOYALTY_FREE_WASH':
          final reward = await _loyalty.findAvailableReward(wash.vehicleId, DateTime.now());
          if (reward == null) throw NoAvailableRewardException();
          await _loyalty.redeemReward(rewardId: reward.id, washOrderId: washOrderId, actorId: actorId);
      }
    }

    await _db.transaction(() async {
      await _db.into(_db.localPayments).insert(
            LocalPaymentsCompanion.insert(id: paymentId, washOrderId: washOrderId, totalAmount: wash.totalAmount, completedAt: DateTime.now()),
          );
      await _db.batch((batch) => batch.insertAll(
            _db.localPaymentComponents,
            components.map(
              (c) => LocalPaymentComponentsCompanion.insert(
                id: _uuid.v4(),
                paymentId: paymentId,
                method: c['method'] as String,
                amount: (c['amount'] as num).toInt(),
                externalReference: Value(c['externalReference'] as String?),
              ),
            ),
          ));
      await (_db.update(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).write(
        LocalWashOrdersCompanion(status: const Value('COMPLETED'), completedAt: Value(DateTime.now())),
      );
      await _appendHistory(washOrderId: washOrderId, from: wash.status, to: 'COMPLETED', actorId: actorId);
    });

    // A wash paid entirely by redeeming the loyalty reward can't itself
    // earn another one; a $0 order never qualifies either. A wash split
    // between a real payment and the reward still qualifies on the
    // non-loyalty leg.
    final isFreeWashOnly = components.length == 1 && components.single['method'] == 'LOYALTY_FREE_WASH';
    final qualifies = wash.totalAmount > 0 &&
        !isFreeWashOnly &&
        components.any((c) => _qualifyingMethods.contains(c['method']) && (c['amount'] as num).toInt() > 0);
    if (qualifies) {
      await _loyalty.creditQualifyingWash(vehicleId: wash.vehicleId, washOrderId: washOrderId, at: DateTime.now(), actorId: actorId);
    }

    final updated = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).getSingle();
    return _toWashOrder(updated);
  }

  /// PIN-gated at the UI layer, same as [cancel]. A voided wash ends up
  /// CANCELLED — there's no separate "refunded" status. Cash/card/mobile
  /// money/bank-transfer components have no automatic reversal here beyond
  /// this bookkeeping — handing the customer their money back physically
  /// isn't tracked by this system.
  Future<void> voidPayment(String washOrderId, String reason, {required String actorId, required String approvedByUserId}) async {
    final wash = await (_db.select(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).getSingleOrNull();
    if (wash == null) throw WashNotFoundException();
    final payment = await (_db.select(_db.localPayments)..where((p) => p.washOrderId.equals(washOrderId))).getSingleOrNull();
    if (payment == null || payment.voided) throw NoActivePaymentException();
    final components = await (_db.select(_db.localPaymentComponents)..where((c) => c.paymentId.equals(payment.id))).get();

    await _db.transaction(() async {
      final now = DateTime.now();
      await (_db.update(_db.localPayments)..where((p) => p.id.equals(payment.id))).write(
        LocalPaymentsCompanion(voided: const Value(true), voidedAt: Value(now)),
      );
      await (_db.update(_db.localWashOrders)..where((w) => w.id.equals(washOrderId))).write(
        LocalWashOrdersCompanion(status: const Value('CANCELLED'), cancelledAt: Value(now), cancelReason: Value(reason)),
      );
      await _appendHistory(washOrderId: washOrderId, from: wash.status, to: 'CANCELLED', actorId: actorId);
    });

    // Always attempted, even if the wash never actually credited loyalty
    // (a safe no-op in that case).
    await _loyalty.reverseWash(washOrderId: washOrderId, actorId: actorId);

    for (final c in components) {
      if (c.method == 'WALLET') {
        await _prepaid.refundToWallet(
          customerId: wash.customerId,
          amount: c.amount,
          reference: 'Void refund: wash $washOrderId',
          clientEntryId: 'void:$washOrderId:wallet',
          actorId: actorId,
        );
      } else if (c.method == 'PACKAGE') {
        final usage = await (_db.select(_db.localPrepaidPackageUsage)..where((u) => u.clientEntryId.equals('finish:$washOrderId:package')))
            .getSingleOrNull();
        if (usage != null) await _prepaid.refundPackageUsage(usage.purchaseId);
      }
    }
  }
}

extension _FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

final washOrdersRepositoryProvider = Provider<WashOrdersRepository>(
  (ref) => WashOrdersRepository(ref.watch(appDatabaseProvider), ref.watch(prepaidRepositoryProvider), ref.watch(loyaltyRepositoryProvider)),
);
