import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database_provider.dart';
import 'role_hierarchy.dart';

/// Single-device app — there's only ever one branch, so this is a fixed
/// constant rather than a real column, kept only because a handful of
/// repository methods still take a branchId parameter.
const localBranchId = 'main';

class DnUser {
  final String id;
  final String username;
  final String fullName;
  final String role; // ATTENDANT | SUPERVISOR | ADMINISTRATOR | OWNER
  final String branchId = localBranchId;

  const DnUser({required this.id, required this.username, required this.fullName, required this.role});

  bool get isSupervisorOrAbove => roleAtLeast(role, 'SUPERVISOR');
  bool get isAdminOrAbove => roleAtLeast(role, 'ADMINISTRATOR');
  bool get isOwner => role == 'OWNER';
}

class SessionState {
  final DnUser? user;
  final bool loading;
  final bool needsFirstRunSetup;

  const SessionState({this.user, this.loading = true, this.needsFirstRunSetup = false});

  bool get isAuthenticated => user != null;

  static const empty = SessionState(loading: false);
}

/// No server means no refresh-token session to restore — a session is
/// purely in-memory, live only as long as the app process does. Restarting
/// the app (or the device) always lands back on the login screen, which is
/// a deliberate choice for a shared counter tablet: it's an accountability
/// checkpoint, not a lost-convenience bug.
class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    _checkFirstRun();
    return const SessionState(loading: true);
  }

  Future<void> _checkFirstRun() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final anyUsers = await db.select(db.localUsers).get();
      // A real sign-in (createFirstOwner, or a login the caller didn't wait
      // on this for) may have already resolved the session while this
      // query was in flight — don't clobber it with a stale result.
      if (!state.loading) return;
      state = SessionState(loading: false, needsFirstRunSetup: anyUsers.isEmpty);
    } catch (_) {
      if (state.loading) state = SessionState.empty;
    }
  }

  void signedIn(DnUser user) => state = SessionState(user: user, loading: false);

  void signOut() => state = const SessionState(loading: false);
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
