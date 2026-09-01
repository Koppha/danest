import 'dart:io' show Platform;

/// Base URL for the De Nest backend API.
///
/// Android emulators reach the host machine's localhost via 10.0.2.2, not
/// 127.0.0.1; Windows desktop builds talk to localhost directly. Override
/// with `--dart-define=API_BASE_URL=...` for a real device or a deployed
/// backend.
String get apiBaseUrl {
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) return override;
  if (Platform.isAndroid) return 'http://10.0.2.2:3000/api/v1';
  return 'http://localhost:3000/api/v1';
}
