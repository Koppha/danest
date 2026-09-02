import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sms_service.dart';

/// Stands in for the NestJS cron the backend used to drive SMS retries —
/// there's no server left to run one, so this sweeps for due retries once
/// a minute for as long as the app stays open. Watching this provider
/// once from the app root starts it; there is deliberately no path that
/// stops it early other than the app itself closing.
final smsRetryTimerProvider = Provider<void>((ref) {
  final sms = ref.watch(smsServiceProvider);
  final timer = Timer.periodic(const Duration(minutes: 1), (_) => sms.processDueRetries());
  ref.onDispose(timer.cancel);
});
