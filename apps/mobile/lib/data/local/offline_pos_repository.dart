import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/connectivity.dart';
import '../models/models.dart';
import '../remote/api_client.dart';
import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

/// Payment methods safe to accept offline — each needs no live server
/// check to accept (unlike WALLET/PACKAGE, which need a live balance
/// check, and LOYALTY_FREE_WASH, which needs a live reward-validity
/// check). Matches the backend's QUALIFYING_METHODS minus those three.
const offlineSafePaymentMethods = [
  'CASH',
  'CARD',
  'MOBILE_MONEY',
  'BANK_TRANSFER',
];

/// Offline-first repository for the sales-floor flows (customers, vehicles,
/// wash queue, cash-family payments). Reads hit the local cache first;
/// writes always land locally + in the outbox immediately, and are pushed
/// to the server right away when online (falling back to the outbox alone
/// when offline, for SyncService to drain later).
class OfflinePosRepository {
  final AppDatabase _db;
  final Dio _dio;
  final Ref _ref;

  OfflinePosRepository(this._db, this._dio, this._ref);

  bool get _isOnline => _ref.read(connectivityProvider);

  // ---------------------------------------------------------------- pull

  /// Refreshes the local reference-data cache (services/extras). Call when
  /// online, e.g. on app start and pull-to-refresh — cheap, small tables.
  Future<void> refreshCatalog() async {
    if (!_isOnline) return;
    try {
      final servicesResp = await _dio.get('/wash-services');
      final extrasResp = await _dio.get('/wash-extras');
      await _db.batch((batch) {
        batch.deleteAll(_db.localWashServices);
        batch.insertAll(
          _db.localWashServices,
          (servicesResp.data as List).map(
            (s) => LocalWashServicesCompanion.insert(
              id: s['id'],
              name: s['name'],
              tier: s['tier'] ?? 'standard',
              basePrice: double.parse(s['basePrice'].toString()),
              durationMinutes: s['durationMinutes'],
            ),
          ),
        );
        batch.deleteAll(_db.localWashExtras);
        batch.insertAll(
          _db.localWashExtras,
          (extrasResp.data as List).map(
            (e) => LocalWashExtrasCompanion.insert(
              id: e['id'],
              name: e['name'],
              price: double.parse(e['price'].toString()),
            ),
          ),
        );
      });
    } on DioException {
      // Best-effort refresh; stale cache is fine, offline creation still works off it.
    }
  }

  Future<List<LocalWashService>> cachedServices() =>
      _db.select(_db.localWashServices).get();
  Future<List<LocalWashExtra>> cachedExtras() =>
      _db.select(_db.localWashExtras).get();

  /// Online: fetch live + refresh cache. Offline: serve from cache.
  Future<List<WashService>> listServices() async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/wash-services');
        await refreshCatalog();
        return (resp.data as List).map((e) => WashService.fromJson(e)).toList();
      } on DioException {
        // Fall through to cache.
      }
    }
    final rows = await cachedServices();
    return rows
        .map(
          (r) => WashService(
            id: r.id,
            name: r.name,
            tier: r.tier,
            basePrice: r.basePrice,
            durationMinutes: r.durationMinutes,
          ),
        )
        .toList();
  }

  Future<List<WashExtra>> listExtras() async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/wash-extras');
        return (resp.data as List).map((e) => WashExtra.fromJson(e)).toList();
      } on DioException {
        // Fall through to cache.
      }
    }
    final rows = await cachedExtras();
    return rows
        .map((r) => WashExtra(id: r.id, name: r.name, price: r.price))
        .toList();
  }

  /// Cached, read-only — loyalty redemption itself still requires connectivity.
  Future<LoyaltySummary?> loyaltySummary(String vehicleId) async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/loyalty/vehicles/$vehicleId/summary');
        final summary = LoyaltySummary.fromJson(resp.data);
        await _db
            .into(_db.localLoyaltySummaries)
            .insertOnConflictUpdate(
              LocalLoyaltySummariesCompanion.insert(
                vehicleId: vehicleId,
                qualifyingCount: summary.qualifyingCount,
                hasAvailableReward: summary.hasAvailableReward,
                asOf: DateTime.now(),
              ),
            );
        return summary;
      } on DioException {
        // Fall through to cache.
      }
    }
    final cached = await (_db.select(
      _db.localLoyaltySummaries,
    )..where((s) => s.vehicleId.equals(vehicleId))).getSingleOrNull();
    if (cached == null) return null;
    return LoyaltySummary(
      qualifyingCount: cached.qualifyingCount,
      remaining: (5 - cached.qualifyingCount).clamp(0, 5),
      hasAvailableReward: cached.hasAvailableReward,
    );
  }

  // ----------------------------------------------------------- customers

  Future<List<Customer>> searchCustomers(String query) async {
    if (_isOnline) {
      try {
        final resp = await _dio.get(
          '/customers',
          queryParameters: {if (query.isNotEmpty) 'q': query},
        );
        final customers = (resp.data as List)
            .map((e) => Customer.fromJson(e))
            .toList();
        await _cacheCustomers(customers);
        return customers;
      } on DioException {
        // Fall through to local cache.
      }
    }
    return _searchLocalCustomers(query);
  }

  Future<List<Customer>> _searchLocalCustomers(String query) async {
    final q = _db.select(_db.localCustomers);
    if (query.isNotEmpty) {
      final like = '%$query%';
      q.where((c) => c.fullName.like(like) | c.phone.like(like));
    } else {
      q.limit(20);
    }
    final rows = await q.get();
    final out = <Customer>[];
    for (final c in rows) {
      final vehicles = await (_db.select(
        _db.localVehicles,
      )..where((v) => v.customerId.equals(c.id))).get();
      out.add(
        Customer(
          id: c.id,
          fullName: c.fullName,
          phone: c.phone,
          vehicles: vehicles
              .map(
                (v) => Vehicle(
                  id: v.id,
                  customerId: v.customerId,
                  regNumberDisplay: v.regNumberDisplay,
                  make: v.make,
                  model: v.model,
                  colour: v.colour,
                ),
              )
              .toList(),
        ),
      );
    }
    return out;
  }

  Future<void> _cacheCustomers(List<Customer> customers) async {
    await _db.batch((batch) {
      for (final c in customers) {
        batch.insert(
          _db.localCustomers,
          LocalCustomersCompanion.insert(
            id: c.id,
            branchId: '',
            fullName: c.fullName,
            phone: c.phone,
          ),
          mode: InsertMode.insertOrReplace,
        );
        for (final v in c.vehicles) {
          batch.insert(
            _db.localVehicles,
            LocalVehiclesCompanion.insert(
              id: v.id,
              customerId: v.customerId,
              regNumberNormalized: v.regNumberDisplay.toUpperCase().replaceAll(
                RegExp(r'[^A-Z0-9]'),
                '',
              ),
              regNumberDisplay: v.regNumberDisplay,
              make: Value(v.make),
              model: Value(v.model),
              colour: Value(v.colour),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }

  Future<Customer> createCustomer({
    required String fullName,
    required String phone,
    required String branchId,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.localCustomers)
        .insert(
          LocalCustomersCompanion.insert(
            id: id,
            branchId: branchId,
            fullName: fullName,
            phone: phone,
            dirty: const Value(true),
          ),
        );
    final payload = {
      'id': id,
      'branchId': branchId,
      'fullName': fullName,
      'phone': phone,
    };
    await _enqueueOrPush(
      entityType: 'customer',
      entityId: id,
      opType: 'create',
      path: '/customers',
      payload: payload,
    );
    return Customer(id: id, fullName: fullName, phone: phone);
  }

  Future<Vehicle> createVehicle({
    required String customerId,
    required String regNumber,
    String? make,
    String? model,
    String? colour,
  }) async {
    final id = _uuid.v4();
    final normalized = regNumber.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    await _db
        .into(_db.localVehicles)
        .insert(
          LocalVehiclesCompanion.insert(
            id: id,
            customerId: customerId,
            regNumberNormalized: normalized,
            regNumberDisplay: regNumber.toUpperCase(),
            make: Value(make),
            model: Value(model),
            colour: Value(colour),
            dirty: const Value(true),
          ),
        );
    final payload = {
      'id': id,
      'customerId': customerId,
      'regNumber': regNumber,
      'make': ?make,
      'model': ?model,
      'colour': ?colour,
    };
    await _enqueueOrPush(
      entityType: 'vehicle',
      entityId: id,
      opType: 'create',
      path: '/vehicles',
      payload: payload,
    );
    return Vehicle(
      id: id,
      customerId: customerId,
      regNumberDisplay: regNumber.toUpperCase(),
      make: make,
      model: model,
      colour: colour,
    );
  }

  // ----------------------------------------------------------- wash queue

  Future<WashOrder> startWash({
    required String branchId,
    required String vehicleId,
    required String customerId,
    required List<Map<String, dynamic>> items,
  }) async {
    final id = _uuid.v4();
    final services = await cachedServices();
    final extras = await cachedExtras();
    double total = 0;
    final itemRows = <LocalWashOrderItemsCompanion>[];
    for (final item in items) {
      if (item['itemType'] == 'SERVICE') {
        final svc = services.firstWhere((s) => s.id == item['serviceId']);
        total += svc.basePrice;
        itemRows.add(
          LocalWashOrderItemsCompanion.insert(
            id: _uuid.v4(),
            washOrderId: id,
            itemType: 'SERVICE',
            serviceId: Value(svc.id),
            nameSnapshot: svc.name,
            priceSnapshot: svc.basePrice,
          ),
        );
      } else {
        final extra = extras.firstWhere((e) => e.id == item['extraId']);
        total += extra.price;
        itemRows.add(
          LocalWashOrderItemsCompanion.insert(
            id: _uuid.v4(),
            washOrderId: id,
            itemType: 'EXTRA',
            extraId: Value(extra.id),
            nameSnapshot: extra.name,
            priceSnapshot: extra.price,
          ),
        );
      }
    }

    await _db.batch((batch) {
      batch.insert(
        _db.localWashOrders,
        LocalWashOrdersCompanion.insert(
          id: id,
          branchId: branchId,
          vehicleId: vehicleId,
          customerId: customerId,
          status: 'WAITING',
          totalAmount: total,
          createdAt: DateTime.now(),
        ),
      );
      batch.insertAll(_db.localWashOrderItems, itemRows);
    });

    await _enqueueOrPush(
      entityType: 'wash_order',
      entityId: id,
      opType: 'create',
      path: '/wash-orders',
      payload: {'id': id, 'vehicleId': vehicleId, 'items': items},
    );

    return WashOrder(
      id: id,
      status: 'WAITING',
      totalAmount: total,
      createdAt: DateTime.now(),
    );
  }

  Future<List<WashOrder>> queue() async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/wash-orders/queue');
        final orders = (resp.data as List)
            .map((e) => WashOrder.fromJson(e))
            .toList();
        return orders;
      } on DioException {
        // Fall through to local.
      }
    }
    final rows =
        await (_db.select(_db.localWashOrders)
              ..where((w) => w.status.isIn(['WAITING', 'WASHING', 'READY']))
              ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
            .get();
    final out = <WashOrder>[];
    for (final w in rows) {
      final vehicle = await (_db.select(
        _db.localVehicles,
      )..where((v) => v.id.equals(w.vehicleId))).getSingleOrNull();
      final customer = await (_db.select(
        _db.localCustomers,
      )..where((c) => c.id.equals(w.customerId))).getSingleOrNull();
      out.add(
        WashOrder(
          id: w.id,
          status: w.status,
          totalAmount: w.totalAmount,
          createdAt: w.createdAt,
          vehicle: vehicle == null
              ? null
              : Vehicle(
                  id: vehicle.id,
                  customerId: vehicle.customerId,
                  regNumberDisplay: vehicle.regNumberDisplay,
                ),
          customer: customer == null
              ? null
              : Customer(
                  id: customer.id,
                  fullName: customer.fullName,
                  phone: customer.phone,
                ),
        ),
      );
    }
    return out;
  }

  Future<void> transitionWash(String washOrderId, String toStatus) async {
    await (_db.update(_db.localWashOrders)
          ..where((w) => w.id.equals(washOrderId)))
        .write(LocalWashOrdersCompanion(status: Value(toStatus)));
    await _enqueueOrPush(
      entityType: 'wash_order',
      entityId: washOrderId,
      opType: 'transition:$toStatus',
      path: '/wash-orders/$washOrderId/status',
      method: 'PATCH',
      payload: {'toStatus': toStatus},
    );
  }

  /// Throws [OfflinePaymentNotAllowedException] if a non-cash-family method
  /// is used while offline — those need a live balance/validity check.
  Future<void> finishWash(
    String washOrderId,
    List<Map<String, dynamic>> components,
  ) async {
    if (!_isOnline) {
      for (final c in components) {
        if (!offlineSafePaymentMethods.contains(c['method'])) {
          throw OfflinePaymentNotAllowedException(c['method'] as String);
        }
      }
    }

    final wash = await (_db.select(
      _db.localWashOrders,
    )..where((w) => w.id.equals(washOrderId))).getSingle();
    final paymentId = _uuid.v4();
    await _db.batch((batch) {
      batch.insert(
        _db.localPayments,
        LocalPaymentsCompanion.insert(
          id: paymentId,
          washOrderId: washOrderId,
          totalAmount: wash.totalAmount,
          completedAt: DateTime.now(),
        ),
      );
      batch.insertAll(
        _db.localPaymentComponents,
        components.map(
          (c) => LocalPaymentComponentsCompanion.insert(
            id: _uuid.v4(),
            paymentId: paymentId,
            method: c['method'],
            amount: (c['amount'] as num).toDouble(),
            externalReference: Value(c['externalReference'] as String?),
          ),
        ),
      );
      batch.update(
        _db.localWashOrders,
        LocalWashOrdersCompanion(
          status: const Value('COMPLETED'),
          completedAt: Value(DateTime.now()),
        ),
        where: (w) => w.id.equals(washOrderId),
      );
    });

    await _enqueueOrPush(
      entityType: 'wash_order',
      entityId: washOrderId,
      opType: 'finish',
      path: '/wash-orders/$washOrderId/finish',
      payload: {'components': components},
      idempotencyKey: 'finish:$washOrderId',
    );
  }

  // ------------------------------------------------------------- outbox

  /// Writes the outbox row, then — if online — pushes immediately so the
  /// UI reflects server-confirmed state (loyalty credit, SMS, etc.) right
  /// away rather than waiting for the next sync sweep. If the immediate
  /// push fails (including "went offline mid-request"), the row stays
  /// queued for SyncService to retry.
  Future<void> _enqueueOrPush({
    required String entityType,
    required String entityId,
    required String opType,
    required String path,
    required Map<String, dynamic> payload,
    String method = 'POST',
    String? idempotencyKey,
  }) async {
    final key = idempotencyKey ?? '$opType:$entityType:$entityId:${_uuid.v4()}';
    await _db
        .into(_db.pendingSyncOps)
        .insertOnConflictUpdate(
          PendingSyncOpsCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            opType: opType,
            payloadJson: jsonEncode(payload),
            idempotencyKey: key,
          ),
        );

    if (_isOnline) {
      await _pushOne(
        entityType: entityType,
        opType: opType,
        path: path,
        method: method,
        payload: payload,
        idempotencyKey: key,
      );
    }
  }

  Future<void> _pushOne({
    required String entityType,
    required String opType,
    required String path,
    required String method,
    required Map<String, dynamic> payload,
    required String idempotencyKey,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: opType == 'finish'
            ? {'Idempotency-Key': idempotencyKey}
            : null,
      );
      await _dio.request(path, data: payload, options: options);
      await (_db.delete(
        _db.pendingSyncOps,
      )..where((o) => o.idempotencyKey.equals(idempotencyKey))).go();
    } on DioException {
      // Leave queued; SyncService will retry on the next sweep.
    }
  }

  Future<int> pendingCount() async {
    final rows = await _db.select(_db.pendingSyncOps).get();
    return rows.length;
  }

  /// Live count of unsynced operations, for a badge in the app shell.
  Stream<int> watchPendingCount() =>
      _db.select(_db.pendingSyncOps).watch().map((rows) => rows.length);
}

class OfflinePaymentNotAllowedException implements Exception {
  final String method;
  OfflinePaymentNotAllowedException(this.method);
  @override
  String toString() =>
      'Cannot accept $method offline — it needs a live balance check. Use cash, card, mobile money, or bank transfer, or reconnect first.';
}

final offlinePosRepositoryProvider = Provider<OfflinePosRepository>(
  (ref) => OfflinePosRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
    ref,
  ),
);
