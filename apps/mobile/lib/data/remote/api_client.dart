import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_config.dart';
import '../../core/connectivity.dart';

/// Flips connectivityProvider based on whether requests are actually
/// reaching the backend — see connectivity.dart for why this beats
/// OS-level connectivity state for our purposes.
///
/// TODO(no-backend-migration): this whole client is talking to a backend
/// that's being phased out (see the plan at binary-squishing-quill.md,
/// Phase 10) — every remaining caller (transactions/audit/settings-create/
/// users-toggle/collections-pending) is slated to move to a local
/// repository. Delete this file once none of them do anymore.
class _ConnectivityInterceptor extends Interceptor {
  final Ref ref;
  _ConnectivityInterceptor(this.ref);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ref.read(connectivityProvider.notifier).markOnline();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    const offlineTypes = {
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    };
    if (offlineTypes.contains(err.type)) {
      ref.read(connectivityProvider.notifier).markOffline();
    } else {
      // Got a real HTTP response (even an error one) — the backend is reachable.
      ref.read(connectivityProvider.notifier).markOnline();
    }
    handler.next(err);
  }
}

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.add(_ConnectivityInterceptor(ref));
  return dio;
});
