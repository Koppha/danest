import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/sync_service.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late AppDatabase db;
  late _RecordingAdapter adapter;
  late SyncService sync;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
    sync = SyncService(db, dio);
  });

  tearDown(() => db.close());

  Future<void> enqueue({required String opType, required String entityId}) => db.into(db.pendingSyncOps).insert(
        PendingSyncOpsCompanion.insert(
          entityType: 'customer',
          entityId: entityId,
          opType: opType,
          payloadJson: jsonEncode({'id': entityId}),
          idempotencyKey: '$opType:$entityId',
        ),
      );

  test('replaying a queued customer create sends POST to /customers', () async {
    await enqueue(opType: 'create', entityId: 'c1');
    await sync.pushAll();
    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/customers');
  });

  test('replaying a queued customer update sends PATCH to /customers/:id, not the collection root', () async {
    await enqueue(opType: 'update', entityId: 'c1');
    await sync.pushAll();
    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.method, 'PATCH');
    expect(adapter.requests.single.path, '/customers/c1');
  });

  test('replaying a queued customer delete sends DELETE to /customers/:id, not a POST', () async {
    await enqueue(opType: 'delete', entityId: 'c1');
    await sync.pushAll();
    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/customers/c1');
  });
}
