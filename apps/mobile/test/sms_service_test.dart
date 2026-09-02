import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/sms_service.dart';
import 'package:de_nest/data/models/models.dart';

class _SucceedingProvider implements SmsProvider {
  int calls = 0;
  @override
  Future<void> send({required String phone, required String body}) async {
    calls++;
  }
}

class _FailingProvider implements SmsProvider {
  int calls = 0;
  @override
  Future<void> send({required String phone, required String body}) async {
    calls++;
    throw Exception('network down');
  }
}

class _ConditionalProvider implements SmsProvider {
  final bool Function() shouldFail;
  _ConditionalProvider(this.shouldFail);
  @override
  Future<void> send({required String phone, required String body}) async {
    if (shouldFail()) throw Exception('still down');
  }
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('renderReadyMessage', () {
    test('the default variant has no loyalty mention', () {
      final loyalty = LoyaltySummary(qualifyingCount: 1, remaining: 4, hasAvailableReward: false);
      final body = renderReadyMessage(customerName: 'Thabo', vehicleReg: 'ABC 123', loyalty: loyalty);
      expect(body, contains('ABC 123'));
      expect(body, isNot(contains('FREE WASH')));
      expect(body, isNot(contains('1 more wash')));
    });

    test('the "one wash away" variant mentions next month\'s reward', () {
      final loyalty = LoyaltySummary(qualifyingCount: 4, remaining: 1, hasAvailableReward: false);
      final body = renderReadyMessage(customerName: 'Thabo', vehicleReg: 'ABC 123', loyalty: loyalty);
      expect(body, contains('1 more wash'));
    });

    test('the "reward available" variant takes priority and says to redeem it now', () {
      final loyalty = LoyaltySummary(qualifyingCount: 0, remaining: 5, hasAvailableReward: true);
      final body = renderReadyMessage(customerName: 'Thabo', vehicleReg: 'ABC 123', loyalty: loyalty);
      expect(body, contains('FREE WASH'));
    });
  });

  group('enqueue', () {
    test('writes a row and attempts to send it immediately', () async {
      final provider = _SucceedingProvider();
      final sms = SmsService(db, provider);

      await sms.enqueue(washOrderId: 'w1', phone: '+26658123456', body: 'test');

      expect(provider.calls, 1);
      final rows = await db.select(db.localSmsMessages).get();
      expect(rows, hasLength(1));
      expect(rows.single.status, 'SENT');
      expect(rows.single.sentAt, isNotNull);
    });

    test('is idempotent on id', () async {
      final provider = _SucceedingProvider();
      final sms = SmsService(db, provider);

      await sms.enqueue(id: 'fixed', washOrderId: 'w1', phone: '+26658123456', body: 'test');
      await sms.enqueue(id: 'fixed', washOrderId: 'w1', phone: '+26658123456', body: 'test');

      expect(provider.calls, 1);
      expect(await db.select(db.localSmsMessages).get(), hasLength(1));
    });
  });

  group('retry/backoff', () {
    test('a failed send increments attemptCount and schedules the next attempt on the backoff curve', () async {
      final provider = _FailingProvider();
      final sms = SmsService(db, provider);
      final before = DateTime.now();

      await sms.enqueue(washOrderId: 'w1', phone: '+26658123456', body: 'test');

      final row = await db.select(db.localSmsMessages).getSingle();
      expect(row.status, 'PENDING');
      expect(row.attemptCount, 1);
      expect(row.lastError, contains('network down'));
      // 2^1 * 60_000ms = 120s backoff.
      expect(row.nextAttemptAt.difference(before).inSeconds, closeTo(120, 2));
    });

    test('exhausting MAX_ATTEMPTS marks the message FAILED for good', () async {
      final provider = _FailingProvider();
      final sms = SmsService(db, provider);
      await sms.enqueue(id: 'm1', washOrderId: 'w1', phone: '+26658123456', body: 'test');

      for (var i = 0; i < maxSmsAttempts - 1; i++) {
        await sms.attemptSend('m1');
      }

      final row = await db.select(db.localSmsMessages).getSingle();
      expect(row.attemptCount, maxSmsAttempts);
      expect(row.status, 'FAILED');
      expect(provider.calls, maxSmsAttempts);
    });

    test('processDueRetries only retries PENDING messages whose nextAttemptAt has passed', () async {
      final provider = _FailingProvider();
      final sms = SmsService(db, provider);
      await sms.enqueue(id: 'm1', washOrderId: 'w1', phone: '+26658123456', body: 'test'); // 1 failed attempt already, ~2min backoff

      await sms.processDueRetries(now: DateTime.now());
      expect(provider.calls, 1); // not due yet — only the initial attempt from enqueue

      await sms.processDueRetries(now: DateTime.now().add(const Duration(minutes: 5)));
      expect(provider.calls, 2);
    });

    test('a message that eventually succeeds on retry ends up SENT', () async {
      var shouldFail = true;
      final sms = SmsService(db, _ConditionalProvider(() => shouldFail));
      await sms.enqueue(id: 'm1', washOrderId: 'w1', phone: '+26658123456', body: 'test');
      shouldFail = false;

      await sms.processDueRetries(now: DateTime.now().add(const Duration(hours: 1)));

      final row = await db.select(db.localSmsMessages).getSingle();
      expect(row.status, 'SENT');
    });
  });
}
