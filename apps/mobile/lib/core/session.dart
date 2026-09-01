import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DnUser {
  final String id;
  final String username;
  final String fullName;
  final String role; // ATTENDANT | SUPERVISOR | ADMINISTRATOR | OWNER
  final String branchId;

  const DnUser({required this.id, required this.username, required this.fullName, required this.role, required this.branchId});

  bool get isSupervisorOrAbove => const ['SUPERVISOR', 'ADMINISTRATOR', 'OWNER'].contains(role);
  bool get isAdminOrAbove => const ['ADMINISTRATOR', 'OWNER'].contains(role);
  bool get isOwner => role == 'OWNER';

  factory DnUser.fromJson(Map<String, dynamic> json) => DnUser(
        id: json['id'] as String,
        username: json['username'] as String,
        fullName: json['fullName'] as String,
        role: json['role'] as String,
        branchId: json['branchId'] as String,
      );
}

class SessionState {
  final DnUser? user;
  final String? accessToken;
  final String? refreshToken;
  final bool loading;

  const SessionState({this.user, this.accessToken, this.refreshToken, this.loading = true});

  bool get isAuthenticated => user != null && accessToken != null;

  SessionState copyWith({DnUser? user, String? accessToken, String? refreshToken, bool? loading}) => SessionState(
        user: user ?? this.user,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        loading: loading ?? this.loading,
      );

  static const empty = SessionState(loading: false);
}

const _secureStorage = FlutterSecureStorage();

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    _restore();
    return const SessionState(loading: true);
  }

  Future<void> _restore() async {
    try {
      final access = await _secureStorage.read(key: 'access_token');
      final refresh = await _secureStorage.read(key: 'refresh_token');
      if (access == null || refresh == null) {
        state = SessionState.empty;
        return;
      }
      // The user profile itself isn't persisted separately; a refreshed
      // session re-derives it from the next successful API call, but for a
      // warm start we at least restore token presence so the app can
      // attempt an authenticated request immediately.
      state = SessionState(accessToken: access, refreshToken: refresh, loading: false);
    } catch (_) {
      // Secure storage unavailable (e.g. first run, platform quirk, test
      // harness with no method channel) — treat as signed out rather than
      // leaving the app stuck on a permanent loading state.
      state = SessionState.empty;
    }
  }

  Future<void> signedIn({required DnUser user, required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    state = SessionState(user: user, accessToken: accessToken, refreshToken: refreshToken, loading: false);
  }

  Future<void> tokensRefreshed({required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    state = state.copyWith(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    state = SessionState.empty;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
