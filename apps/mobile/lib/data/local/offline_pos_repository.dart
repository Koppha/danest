import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/connectivity.dart';
import '../../core/money.dart';
import '../models/models.dart';
import '../remote/api_client.dart';
import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

/// Local-first repository for customers, vehicles, the reference catalog,
/// expenses, users, and cash collections. Wash orders/payments live in
/// [WashOrdersRepository], loyalty in [LoyaltyRepository], and prepaid
/// wallet/packages in [PrepaidRepository] — those needed the real
/// authoritative business logic (not a provisional offline guess), so they
/// were split out rather than grown here.
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
              basePrice: currencyUnitsToCents(s['basePrice']),
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
              price: currencyUnitsToCents(e['price']),
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

  /// Price edits apply to the cached row immediately (so the change is
  /// visible right away) and queue a PATCH — safe to do offline since it
  /// targets an existing row rather than creating a new one.
  Future<void> updateService({
    required String id,
    required String name,
    required int basePrice, // cents
    required int durationMinutes,
  }) async {
    final existing = await (_db.select(_db.localWashServices)..where((s) => s.id.equals(id))).getSingleOrNull();
    await _db
        .into(_db.localWashServices)
        .insertOnConflictUpdate(
          LocalWashServicesCompanion.insert(
            id: id,
            name: name,
            tier: existing?.tier ?? 'standard',
            basePrice: basePrice,
            durationMinutes: durationMinutes,
          ),
        );
    await _enqueueOrPush(
      entityType: 'service',
      entityId: id,
      opType: 'update',
      path: '/wash-services/$id',
      method: 'PATCH',
      payload: {'name': name, 'basePrice': basePrice, 'durationMinutes': durationMinutes},
    );
  }

  Future<void> updateExtra({
    required String id,
    required String name,
    required int price, // cents
  }) async {
    await _db
        .into(_db.localWashExtras)
        .insertOnConflictUpdate(LocalWashExtrasCompanion.insert(id: id, name: name, price: price));
    await _enqueueOrPush(
      entityType: 'extra',
      entityId: id,
      opType: 'update',
      path: '/wash-extras/$id',
      method: 'PATCH',
      payload: {'name': name, 'price': price},
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

  // ------------------------------------------------------------- expenses

  Future<void> _cacheExpenseCategories(List<dynamic> categories) async {
    await _db.batch((batch) {
      for (final c in categories) {
        final map = c as Map<String, dynamic>;
        batch.insert(
          _db.localExpenseCategories,
          LocalExpenseCategoriesCompanion.insert(id: map['id'] as String, name: map['name'] as String),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> listExpenseCategories() async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/expenses/categories');
        final categories = resp.data as List<dynamic>;
        await _cacheExpenseCategories(categories);
        return categories.cast<Map<String, dynamic>>();
      } on DioException {
        // Fall through to cache.
      }
    }
    final rows = await _db.select(_db.localExpenseCategories).get();
    return rows.map((r) => {'id': r.id, 'name': r.name}).toList();
  }

  Future<void> _cacheExpenses(List<dynamic> expenses) async {
    await _db.batch((batch) {
      for (final e in expenses) {
        final map = e as Map<String, dynamic>;
        final category = map['category'] as Map<String, dynamic>;
        batch.insert(
          _db.localExpenseCategories,
          LocalExpenseCategoriesCompanion.insert(id: category['id'] as String, name: category['name'] as String),
          mode: InsertMode.insertOrReplace,
        );
        batch.insert(
          _db.localExpenses,
          LocalExpensesCompanion.insert(
            id: map['id'] as String,
            branchId: (map['branchId'] as String?) ?? '',
            categoryId: category['id'] as String,
            description: map['description'] as String,
            amount: currencyUnitsToCents(map['amount']),
            paymentMethod: map['paymentMethod'] as String,
            createdAt: DateTime.parse(map['createdAt'] as String),
            dirty: const Value(false),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> _cachedExpensesAsMaps() async {
    final rows = await (_db.select(
      _db.localExpenses,
    )..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).get();
    final categoryRows = await _db.select(_db.localExpenseCategories).get();
    final categoryNames = {for (final c in categoryRows) c.id: c.name};
    return rows
        .map(
          (r) => {
            'id': r.id,
            'description': r.description,
            'amount': r.amount,
            'paymentMethod': r.paymentMethod,
            'category': {'id': r.categoryId, 'name': categoryNames[r.categoryId] ?? 'Unknown'},
          },
        )
        .toList();
  }

  /// Online: fetch live + refresh cache. Offline: serve from cache (includes
  /// anything created offline on this device, dirty or already synced).
  Future<List<Map<String, dynamic>>> listExpenses() async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/expenses');
        final expenses = resp.data as List<dynamic>;
        await _cacheExpenses(expenses);
        // Normalize to the same cents-based shape the offline cache
        // returns, so callers don't care which path served the data.
        return expenses
            .cast<Map<String, dynamic>>()
            .map((e) => {...e, 'amount': currencyUnitsToCents(e['amount'])})
            .toList();
      } on DioException {
        // Fall through to cache.
      }
    }
    return _cachedExpensesAsMaps();
  }

  Future<Map<String, dynamic>> createExpense({
    required String categoryId,
    required String description,
    required int amount, // cents
    required String paymentMethod,
    required String branchId,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.localExpenses)
        .insert(
          LocalExpensesCompanion.insert(
            id: id,
            branchId: branchId,
            categoryId: categoryId,
            description: description,
            amount: amount,
            paymentMethod: paymentMethod,
            createdAt: now,
            dirty: const Value(true),
          ),
        );
    await _enqueueOrPush(
      entityType: 'expense',
      entityId: id,
      opType: 'create',
      path: '/expenses',
      payload: {
        'id': id,
        'categoryId': categoryId,
        'description': description,
        'amount': amount,
        'paymentMethod': paymentMethod,
      },
    );
    final categoryRows = await _db.select(_db.localExpenseCategories).get();
    var categoryName = 'Unknown';
    for (final c in categoryRows) {
      if (c.id == categoryId) {
        categoryName = c.name;
        break;
      }
    }
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'category': {'id': categoryId, 'name': categoryName},
    };
  }

  // --------------------------------------------------------------- users

  /// Online rows come straight from the server; any not-yet-synced
  /// [LocalPendingUsers] rows are appended and marked `pending: true` (the
  /// row is deleted once its create op actually reaches the server — see
  /// the cleanup in [_pushOne] and [SyncService.pushAll]), so a
  /// just-created account is visible immediately even before syncing.
  Future<List<Map<String, dynamic>>> listUsers() async {
    List<Map<String, dynamic>> synced = [];
    if (_isOnline) {
      try {
        final resp = await _dio.get('/users');
        synced = (resp.data as List).cast<Map<String, dynamic>>();
      } on DioException {
        // Fall through to whatever's pending locally.
      }
    }
    final pendingRows = await _db.select(_db.localPendingUsers).get();
    final pending = pendingRows
        .map(
          (u) => {
            'id': u.id,
            'fullName': u.fullName,
            'username': u.username,
            'active': true,
            'role': {'name': u.role},
            'pending': true,
          },
        )
        .toList();
    return [...synced, ...pending];
  }

  /// Password hashing (argon2) is server-only, so the account can't log in
  /// anywhere until this create op actually reaches the server — the
  /// plaintext password sits in the outbox/[LocalPendingUsers] only until
  /// then, same trust model as every other offline payload in local SQLite.
  Future<void> createUser({
    required String branchId,
    required String fullName,
    required String username,
    required String password,
    required String role,
    String? pin,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.localPendingUsers)
        .insert(
          LocalPendingUsersCompanion.insert(
            id: id,
            branchId: branchId,
            fullName: fullName,
            username: username,
            password: password,
            role: role,
            pin: Value(pin),
            createdAt: DateTime.now(),
          ),
        );
    await _enqueueOrPush(
      entityType: 'user',
      entityId: id,
      opType: 'create',
      path: '/users',
      payload: {
        'id': id,
        'branchId': branchId,
        'fullName': fullName,
        'username': username,
        'password': password,
        'role': role,
        if (pin != null) 'pin': pin,
      },
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
      if (entityType == 'user' && opType == 'create') {
        final userId = payload['id'] as String?;
        if (userId != null) {
          await (_db.delete(_db.localPendingUsers)..where((u) => u.id.equals(userId))).go();
        }
      }
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

  // ---------------------------------------------------------- sync issues

  /// Ops the server genuinely rejected once this device reconnected (not
  /// "still offline"/"still retrying") — e.g. a wallet/package/reward spent
  /// by another device first, or a username someone else already took. See
  /// SyncService.pushAll for how a row lands here.
  Stream<List<PendingSyncOp>> watchFailedSyncOps() {
    final query = _db.select(_db.pendingSyncOps)..where((o) => o.status.equals('FAILED'));
    return query.watch();
  }

  Stream<int> watchFailedSyncCount() => watchFailedSyncOps().map((rows) => rows.length);

  /// The admin has resolved this manually (e.g. refunded the customer,
  /// picked a new username) — remove it from the outbox for good.
  Future<void> dismissSyncIssue(int rowId) async {
    await (_db.delete(_db.pendingSyncOps)..where((o) => o.rowId.equals(rowId))).go();
  }
}

final offlinePosRepositoryProvider = Provider<OfflinePosRepository>(
  (ref) => OfflinePosRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
    ref,
  ),
);
