import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

const maxSmsAttempts = 5;

/// 2^attempt minutes, capped at an hour — the same backoff curve the
/// backend's cron used, now driven by a local Timer instead.
Duration smsBackoffFor(int attempt) {
  final ms = (1 << attempt) * 60000;
  return Duration(milliseconds: ms > 3600000 ? 3600000 : ms);
}

/// Renders the "your car is ready" body. Which of the three variants goes
/// out depends only on the vehicle's *current* loyalty standing — not on
/// this wash's own outcome, since payment (and so whether this wash itself
/// ends up qualifying) hasn't happened yet when the car goes READY.
String renderReadyMessage({required String customerName, required String vehicleReg, required LoyaltySummary loyalty}) {
  final base = 'Hi $customerName, your $vehicleReg is ready for collection at De Nest Car Wash.';
  if (loyalty.hasAvailableReward) {
    return '$base You have a FREE WASH reward available this month — just mention it when you collect!';
  }
  if (loyalty.remaining == 1) {
    return '$base Just 1 more wash this month earns you a free wash next month!';
  }
  return '$base Thank you for your business!';
}

abstract class SmsProvider {
  Future<void> send({required String phone, required String body});
}

/// The backend this was ported from never had a real provider wired up
/// either — this isn't a regression, just the same "log it, don't send
/// it" default until a real one is configured with actual credentials.
class LogOnlySmsProvider implements SmsProvider {
  @override
  Future<void> send({required String phone, required String body}) async {
    // ignore: avoid_print
    print('[SMS -> $phone] $body');
  }
}

/// enqueue/attemptSend/processDueRetries mirror the backend's exact state
/// machine (§14): MAX_ATTEMPTS=5, exponential backoff capped at an hour.
/// The one real difference is *what* drives retries — a Timer.periodic
/// while this app is open, instead of a server-side cron that runs
/// regardless. There's no guaranteed background delivery here: a message
/// stuck retrying when the app is closed just waits until it's reopened.
class SmsService {
  final AppDatabase _db;
  final SmsProvider _provider;
  SmsService(this._db, this._provider);

  Future<void> enqueue({String? id, required String washOrderId, required String phone, required String body}) async {
    final messageId = id ?? _uuid.v4();
    if (id != null) {
      final existing = await (_db.select(_db.localSmsMessages)..where((m) => m.id.equals(id))).getSingleOrNull();
      if (existing != null) return;
    }
    await _db.into(_db.localSmsMessages).insert(
          LocalSmsMessagesCompanion.insert(
            id: messageId,
            washOrderId: Value(washOrderId),
            phone: phone,
            renderedBody: body,
            nextAttemptAt: DateTime.now(),
          ),
        );
    await attemptSend(messageId);
  }

  Future<void> attemptSend(String id) async {
    final message = await (_db.select(_db.localSmsMessages)..where((m) => m.id.equals(id))).getSingleOrNull();
    if (message == null || message.status == 'SENT') return;
    try {
      await _provider.send(phone: message.phone, body: message.renderedBody);
      await (_db.update(_db.localSmsMessages)..where((m) => m.id.equals(id))).write(
        LocalSmsMessagesCompanion(status: const Value('SENT'), sentAt: Value(DateTime.now())),
      );
    } catch (e) {
      final attempt = message.attemptCount + 1;
      final exhausted = attempt >= maxSmsAttempts;
      await (_db.update(_db.localSmsMessages)..where((m) => m.id.equals(id))).write(
        LocalSmsMessagesCompanion(
          attemptCount: Value(attempt),
          status: Value(exhausted ? 'FAILED' : 'PENDING'),
          nextAttemptAt: Value(DateTime.now().add(smsBackoffFor(attempt))),
          lastError: Value(e.toString()),
        ),
      );
    }
  }

  /// Driven by the app-wide Timer.periodic (see smsRetryTimerProvider) —
  /// [now] is only a test hook for a fake clock.
  Future<void> processDueRetries({DateTime? now}) async {
    final cutoff = now ?? DateTime.now();
    final due = await (_db.select(_db.localSmsMessages)
          ..where((m) => m.status.equals('PENDING') & m.nextAttemptAt.isSmallerOrEqualValue(cutoff)))
        .get();
    for (final m in due) {
      await attemptSend(m.id);
    }
  }

  Future<List<LocalSmsMessage>> list() => (_db.select(_db.localSmsMessages)..orderBy([(m) => OrderingTerm.desc(m.createdAt)])).get();
}

final smsServiceProvider = Provider<SmsService>((ref) => SmsService(ref.watch(appDatabaseProvider), LogOnlySmsProvider()));
