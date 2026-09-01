import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../remote/api_client.dart';
import 'app_database.dart';
import 'database_provider.dart';

/// Drains PendingSyncOps against the backend. The backend's create
/// endpoints are idempotent on the client-generated id (see
/// WashOrdersService/CustomersService/VehiclesService), and finish-wash is
/// additionally gated by the Idempotency-Key header, so a queued op that
/// actually succeeded before (e.g. the response was lost) is always safe
/// to retry.
class SyncService {
  final AppDatabase _db;
  final Dio _dio;

  SyncService(this._db, this._dio);

  /// Returns (pushed, failed) counts.
  Future<(int, int)> pushAll() async {
    final ops = await _db.select(_db.pendingSyncOps).get();
    int pushed = 0, failed = 0;

    for (final op in ops) {
      final payload = jsonDecode(op.payloadJson) as Map<String, dynamic>;
      final path = _pathFor(op);
      final method = op.opType.startsWith('transition') ? 'PATCH' : 'POST';

      try {
        final options = Options(
          method: method,
          headers: op.opType == 'finish' ? {'Idempotency-Key': op.idempotencyKey} : null,
        );
        await _dio.request(path, data: payload, options: options);
        await (_db.delete(_db.pendingSyncOps)..where((o) => o.rowId.equals(op.rowId))).go();
        pushed++;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (status != null && status >= 400 && status < 500 && status != 409 && status != 425) {
          // A genuine business-rule rejection (not "already in progress"/"conflict",
          // which can mean it actually already applied) — surface for review rather
          // than retrying forever.
          await (_db.update(_db.pendingSyncOps)..where((o) => o.rowId.equals(op.rowId))).write(
            PendingSyncOpsCompanion(
              status: const Value('FAILED'),
              lastError: Value(e.response?.data?.toString() ?? e.message),
              attemptCount: Value(op.attemptCount + 1),
            ),
          );
          failed++;
        }
        // Network-ish errors (including 409/425/5xx): leave PENDING for the next sweep.
      }
    }

    return (pushed, failed);
  }

  String _pathFor(PendingSyncOp op) {
    switch (op.entityType) {
      case 'customer':
        return '/customers';
      case 'vehicle':
        return '/vehicles';
      case 'wash_order':
        if (op.opType == 'create') return '/wash-orders';
        if (op.opType.startsWith('transition')) return '/wash-orders/${op.entityId}/status';
        if (op.opType == 'finish') return '/wash-orders/${op.entityId}/finish';
      case 'expense':
        return '/expenses';
      case 'prepaid_deposit':
        return '/prepaid/deposits';
    }
    throw StateError('Unknown sync op: ${op.entityType}/${op.opType}');
  }
}

final syncServiceProvider = Provider<SyncService>(
  (ref) => SyncService(ref.watch(appDatabaseProvider), ref.watch(apiClientProvider)),
);
