import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_config.dart';
import '../../core/connectivity.dart';
import '../../core/session.dart';

/// Flips connectivityProvider based on whether requests are actually
/// reaching the backend — see connectivity.dart for why this beats
/// OS-level connectivity state for our purposes.
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

/// Attaches the bearer token to every request and transparently refreshes
/// once on a 401 before retrying — if the refresh itself fails, the caller
/// sees the original 401 and the app routes back to login.
class _AuthInterceptor extends Interceptor {
  final Ref ref;
  final Dio _refreshDio;
  bool _refreshing = false;

  _AuthInterceptor(this.ref) : _refreshDio = Dio(BaseOptions(baseUrl: apiBaseUrl));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(sessionProvider).accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAuthEndpoint = err.requestOptions.path.contains('/auth/');
    if (err.response?.statusCode != 401 || isAuthEndpoint || _refreshing) {
      return handler.next(err);
    }

    final session = ref.read(sessionProvider);
    if (session.refreshToken == null) return handler.next(err);

    _refreshing = true;
    try {
      final resp = await _refreshDio.post('/auth/refresh', data: {'refreshToken': session.refreshToken});
      final newAccess = resp.data['accessToken'] as String;
      final newRefresh = resp.data['refreshToken'] as String;
      await ref.read(sessionProvider.notifier).tokensRefreshed(accessToken: newAccess, refreshToken: newRefresh);

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccess';
      final retryResp = await _refreshDio.fetch(retryOptions);
      return handler.resolve(retryResp);
    } catch (_) {
      await ref.read(sessionProvider.notifier).signOut();
      return handler.next(err);
    } finally {
      _refreshing = false;
    }
  }
}

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.add(_AuthInterceptor(ref));
  dio.interceptors.add(_ConnectivityInterceptor(ref));
  return dio;
});
