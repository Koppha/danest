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

  /// Price edits apply to the cached row immediately (so the change is
  /// visible right away) and queue a PATCH — safe to do offline since it
  /// targets an existing row rather than creating a new one.
  Future<void> updateService({
    required String id,
    required String name,
    required double basePrice,
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
    required double price,
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
            amount: double.parse(map['amount'].toString()),
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
        return expenses.cast<Map<String, dynamic>>();
      } on DioException {
        // Fall through to cache.
      }
    }
    return _cachedExpensesAsMaps();
  }

  Future<Map<String, dynamic>> createExpense({
    required String categoryId,
    required String description,
    required double amount,
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

  // ---------------------------------------------------------- collections

  /// Always queued, never computed locally: computeExpected() on the server
  /// aggregates every device's transactions since the last cutoff, which a
  /// single offline device fundamentally cannot know. `countedAt` records
  /// when the attendant actually did the count — the server uses that as
  /// the period end once this syncs, not whenever the request happens to
  /// land, so a late sync doesn't pull in transactions the attendant never
  /// saw.
  Future<void> confirmCollection({
    required String branchId,
    required double countedCash,
    String? varianceReason,
    String? witness,
    String? notes,
    required DateTime countedAt,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.localCashCollections)
        .insert(
          LocalCashCollectionsCompanion.insert(
            id: id,
            branchId: branchId,
            countedCash: countedCash,
            varianceReason: Value(varianceReason),
            witness: Value(witness),
            notes: Value(notes),
            countedAt: countedAt,
          ),
        );
    await _enqueueOrPush(
      entityType: 'collection',
      entityId: id,
      opType: 'create',
      path: '/collections',
      payload: {
        'id': id,
        'countedCash': countedCash,
        'varianceReason': ?varianceReason,
        'witness': ?witness,
        'notes': ?notes,
        'countedAt': countedAt.toIso8601String(),
      },
    );
  }

  // ------------------------------------------------------------- prepaid

  Future<void> _cachePrepaidOverview(String customerId, Map<String, dynamic> overview) async {
    await _db
        .into(_db.localPrepaidWallets)
        .insertOnConflictUpdate(
          LocalPrepaidWalletsCompanion.insert(
            customerId: customerId,
            balance: double.parse(overview['balance'].toString()),
            asOf: DateTime.now(),
          ),
        );
    final packages = overview['packages'] as List<dynamic>;
    await _db.batch((batch) {
      for (final p in packages) {
        final map = p as Map<String, dynamic>;
        final pkg = map['package'] as Map<String, dynamic>;
        batch.insert(
          _db.localPrepaidPackages,
          LocalPrepaidPackagesCompanion.insert(
            id: pkg['id'] as String,
            name: pkg['name'] as String,
            eligibleTiers: (pkg['eligibleTiers'] as List<dynamic>).join(','),
            washCount: pkg['washCount'] as int,
            price: double.parse(pkg['price'].toString()),
            validityDays: pkg['validityDays'] as int,
            applicableScope: pkg['applicableScope'] as String,
          ),
          mode: InsertMode.insertOrReplace,
        );
        batch.insert(
          _db.localPrepaidPackagePurchases,
          LocalPrepaidPackagePurchasesCompanion.insert(
            id: map['id'] as String,
            packageId: pkg['id'] as String,
            customerId: map['customerId'] as String,
            vehicleId: Value(map['vehicleId'] as String?),
            expiresAt: DateTime.parse(map['expiresAt'] as String),
            remainingCount: map['remainingCount'] as int,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<Map<String, dynamic>> _cachedPrepaidOverview(String customerId) async {
    final wallet = await (_db.select(
      _db.localPrepaidWallets,
    )..where((w) => w.customerId.equals(customerId))).getSingleOrNull();
    final purchases = await (_db.select(
      _db.localPrepaidPackagePurchases,
    )..where((p) => p.customerId.equals(customerId) & p.expiresAt.isBiggerThanValue(DateTime.now()))).get();
    final packageRows = await _db.select(_db.localPrepaidPackages).get();
    final packagesById = {for (final pk in packageRows) pk.id: pk};
    return {
      'balance': wallet?.balance ?? 0,
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

  /// Online: fetch live + refresh the wallet/package cache used for offline
  /// spend eligibility checks. Offline: serve from that cache.
  Future<Map<String, dynamic>> prepaidOverview(String customerId) async {
    if (_isOnline) {
      try {
        final resp = await _dio.get('/prepaid/customers/$customerId/overview');
        final overview = resp.data as Map<String, dynamic>;
        await _cachePrepaidOverview(customerId, overview);
        return overview;
      } on DioException {
        // Fall through to cache.
      }
    }
    return _cachedPrepaidOverview(customerId);
  }

  /// Deposits are purely additive (never a double-spend risk), so this is
  /// always allowed offline: bump the cached balance immediately and queue
  /// the real deposit — already idempotent server-side on clientEntryId.
  Future<void> depositToWallet({
    required String customerId,
    required double amount,
    required String method,
  }) async {
    final clientEntryId = _uuid.v4();
    final wallet = await (_db.select(
      _db.localPrepaidWallets,
    )..where((w) => w.customerId.equals(customerId))).getSingleOrNull();
    final newBalance = (wallet?.balance ?? 0) + amount;
    await _db
        .into(_db.localPrepaidWallets)
        .insertOnConflictUpdate(
          LocalPrepaidWalletsCompanion.insert(customerId: customerId, balance: newBalance, asOf: DateTime.now()),
        );
    await _enqueueOrPush(
      entityType: 'prepaid_deposit',
      entityId: clientEntryId,
      opType: 'create',
      path: '/prepaid/deposits',
      payload: {'customerId': customerId, 'amount': amount, 'method': method, 'clientEntryId': clientEntryId},
      idempotencyKey: 'deposit:$clientEntryId',
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
    final wash = await (_db.select(
      _db.localWashOrders,
    )..where((w) => w.id.equals(washOrderId))).getSingle();

    if (!_isOnline) {
      // WALLET/PACKAGE/LOYALTY_FREE_WASH are provisionally allowed offline
      // against the cached balance/count/flag — the server remains
      // authoritative and can still reject at sync time (e.g. a different
      // device already spent it first); that rejection surfaces in Sync
      // Issues rather than failing silently. This local check only catches
      // the obvious case (this device's own cache already shows nothing
      // left) and stops the same device from redeeming/spending twice.
      for (final c in components) {
        final method = c['method'] as String;
        if (offlineSafePaymentMethods.contains(method)) continue;
        final amount = (c['amount'] as num).toDouble();
        switch (method) {
          case 'WALLET':
            final wallet = await (_db.select(
              _db.localPrepaidWallets,
            )..where((w) => w.customerId.equals(wash.customerId))).getSingleOrNull();
            if (wallet == null || wallet.balance < amount) {
              throw OfflineInsufficientCachedBalanceException(method, 'cached prepaid balance is insufficient');
            }
          case 'PACKAGE':
            final purchase = await (_db.select(_db.localPrepaidPackagePurchases)..where(
                  (p) =>
                      p.customerId.equals(wash.customerId) &
                      p.remainingCount.isBiggerThanValue(0) &
                      p.expiresAt.isBiggerThanValue(DateTime.now()),
                )).getSingleOrNull();
            if (purchase == null) {
              throw OfflineInsufficientCachedBalanceException(method, 'no cached package with washes remaining');
            }
          case 'LOYALTY_FREE_WASH':
            final loyalty = await (_db.select(
              _db.localLoyaltySummaries,
            )..where((s) => s.vehicleId.equals(wash.vehicleId))).getSingleOrNull();
            if (loyalty == null || !loyalty.hasAvailableReward) {
              throw OfflineInsufficientCachedBalanceException(method, 'no free wash cached as available');
            }
          default:
            throw OfflinePaymentNotAllowedException(method);
        }
      }
    }

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

    if (!_isOnline) {
      // Optimistically apply the same spend to the cache that was just
      // provisionally checked, so this device can't redeem/spend the same
      // resource twice before reconnecting. The server is still the source
      // of truth once this syncs.
      for (final c in components) {
        final method = c['method'] as String;
        final amount = (c['amount'] as num).toDouble();
        if (method == 'WALLET') {
          final wallet = await (_db.select(
            _db.localPrepaidWallets,
          )..where((w) => w.customerId.equals(wash.customerId))).getSingleOrNull();
          if (wallet != null) {
            await (_db.update(
              _db.localPrepaidWallets,
            )..where((w) => w.customerId.equals(wash.customerId))).write(
              LocalPrepaidWalletsCompanion(balance: Value(wallet.balance - amount)),
            );
          }
        } else if (method == 'PACKAGE') {
          final purchase = await (_db.select(_db.localPrepaidPackagePurchases)..where(
                (p) =>
                    p.customerId.equals(wash.customerId) &
                    p.remainingCount.isBiggerThanValue(0) &
                    p.expiresAt.isBiggerThanValue(DateTime.now()),
              )).getSingleOrNull();
          if (purchase != null) {
            await (_db.update(
              _db.localPrepaidPackagePurchases,
            )..where((p) => p.id.equals(purchase.id))).write(
              LocalPrepaidPackagePurchasesCompanion(remainingCount: Value(purchase.remainingCount - 1)),
            );
          }
        } else if (method == 'LOYALTY_FREE_WASH') {
          await (_db.update(
            _db.localLoyaltySummaries,
          )..where((s) => s.vehicleId.equals(wash.vehicleId))).write(
            const LocalLoyaltySummariesCompanion(hasAvailableReward: Value(false)),
          );
        }
      }
    }

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
}

class OfflinePaymentNotAllowedException implements Exception {
  final String method;
  OfflinePaymentNotAllowedException(this.method);
  @override
  String toString() =>
      'Cannot accept $method offline — it needs a live balance check. Use cash, card, mobile money, or bank transfer, or reconnect first.';
}

/// Thrown when a WALLET/PACKAGE/LOYALTY_FREE_WASH spend is attempted offline
/// but this device's own cache already shows nothing left to spend. Distinct
/// from [OfflinePaymentNotAllowedException] (categorically blocked) — this
/// one is a provisional local check; the server can still reject it (a
/// different device may have spent it first) or allow it (this device's
/// cache may be stale), and that only gets resolved once this syncs.
class OfflineInsufficientCachedBalanceException implements Exception {
  final String method;
  final String detail;
  OfflineInsufficientCachedBalanceException(this.method, this.detail);
  @override
  String toString() => 'Cannot accept $method offline — $detail. Reconnect to verify, or use cash, card, mobile money, or bank transfer.';
}

final offlinePosRepositoryProvider = Provider<OfflinePosRepository>(
  (ref) => OfflinePosRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
    ref,
  ),
);
