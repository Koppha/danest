import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/role_hierarchy.dart';
import '../../core/session.dart';
import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();

/// Deliberately the same message whether the username doesn't exist or the
/// password is wrong — no username enumeration, matching the backend's rule.
class InvalidCredentialsException implements Exception {
  @override
  String toString() => 'Invalid username or password';
}

/// Thrown by [AuthRepository.verifyPinOverride] — covers "no such user",
/// "not active", "below SUPERVISOR", "no PIN set", and "wrong PIN" with one
/// generic message, same anti-enumeration reasoning as login.
class InvalidPinOverrideException implements Exception {
  @override
  String toString() => 'Invalid PIN, or that person is not a supervisor';
}

/// There's no server left to hash passwords — this is now the only place
/// credentials are ever verified. No JWT/refresh tokens: a "session" is
/// just "which local user is currently active."
class AuthRepository {
  final AppDatabase _db;
  final Ref _ref;
  AuthRepository(this._db, this._ref);

  Future<bool> hasAnyUsers() async {
    final rows = await _db.select(_db.localUsers).get();
    return rows.isNotEmpty;
  }

  /// First-run bootstrap: creates the initial account and signs them in.
  /// Only meaningful while [hasAnyUsers] is false — the app's own router
  /// gates the setup screen on that, this method doesn't re-check it.
  Future<void> createFirstOwner({required String fullName, required String username, required String password}) async {
    final id = _uuid.v4();
    await _db.into(_db.localUsers).insert(
          LocalUsersCompanion.insert(
            id: id,
            fullName: fullName,
            username: username,
            passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
            role: 'OWNER',
          ),
        );
    _ref.read(sessionProvider.notifier).signedIn(DnUser(id: id, username: username, fullName: fullName, role: 'OWNER'));
  }

  Future<void> login(String username, String password) async {
    final row = await (_db.select(_db.localUsers)..where((u) => u.username.equals(username))).getSingleOrNull();
    if (row == null || !row.active || !BCrypt.checkpw(password, row.passwordHash)) {
      throw InvalidCredentialsException();
    }
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(row.id))).write(LocalUsersCompanion(lastLoginAt: Value(DateTime.now())));
    _ref.read(sessionProvider.notifier).signedIn(DnUser(id: row.id, username: row.username, fullName: row.fullName, role: row.role));
  }

  void logout() {
    _ref.read(sessionProvider.notifier).signOut();
  }

  /// Mirrors the backend's PinOverrideGuard: resolves the approving user (by
  /// [overrideUsername] if given, else [currentUserId]), requires them to be
  /// active, SUPERVISOR-or-above, with a PIN hash matching [pin]. Returns
  /// the approving user's id for the audit trail.
  Future<String> verifyPinOverride({
    required String pin,
    String? overrideUsername,
    required String currentUserId,
  }) async {
    final row = overrideUsername != null && overrideUsername.trim().isNotEmpty
        ? await (_db.select(_db.localUsers)..where((u) => u.username.equals(overrideUsername.trim()))).getSingleOrNull()
        : await (_db.select(_db.localUsers)..where((u) => u.id.equals(currentUserId))).getSingleOrNull();
    final pinHash = row?.pinHash;
    if (row == null || !row.active || !roleAtLeast(row.role, 'SUPERVISOR') || pinHash == null || !BCrypt.checkpw(pin, pinHash)) {
      throw InvalidPinOverrideException();
    }
    return row.id;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref.watch(appDatabaseProvider), ref));
