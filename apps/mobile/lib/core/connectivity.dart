import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True until the first real network failure; flipped by the Dio
/// interceptor on every request based on actual reachability of the
/// backend, rather than generic OS-level connectivity (a device can report
/// "on WiFi" while the backend itself is unreachable, and vice versa a
/// captive portal can look "connected" while nothing actually works).
class ConnectivityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void markOnline() {
    if (!state) state = true;
  }

  void markOffline() {
    if (state) state = false;
  }
}

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(ConnectivityNotifier.new);
