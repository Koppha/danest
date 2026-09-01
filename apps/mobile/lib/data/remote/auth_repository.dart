import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/session.dart';
import 'api_client.dart';

class AuthRepository {
  final Dio _dio;
  final Ref _ref;
  AuthRepository(this._dio, this._ref);

  Future<void> login(String username, String password) async {
    final resp = await _dio.post('/auth/login', data: {'username': username, 'password': password});
    final data = resp.data as Map<String, dynamic>;
    final user = DnUser.fromJson(data['user'] as Map<String, dynamic>);
    await _ref.read(sessionProvider.notifier).signedIn(
          user: user,
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
  }

  Future<void> logout() async {
    final refreshToken = _ref.read(sessionProvider).refreshToken;
    if (refreshToken != null) {
      try {
        await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
      } catch (_) {
        // Best-effort server-side revoke; local sign-out proceeds regardless.
      }
    }
    await _ref.read(sessionProvider.notifier).signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref.watch(apiClientProvider), ref));
