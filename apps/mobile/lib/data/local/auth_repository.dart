import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/role_hierarchy.dart';
import '../../core/session.dart';
import 'app_database.dart';
import 'audit_log.dart';
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

class UsernameTakenException implements Exception {
  @override
  String toString() => 'That username is already taken';
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
    await recordAudit(_db, action: AuditAction.userCreated, actorId: id, entityType: 'User', entityId: id, metadata: {'role': 'OWNER', 'bootstrap': true});
    _ref.read(sessionProvider.notifier).signedIn(DnUser(id: id, username: username, fullName: fullName, role: 'OWNER'));
  }

  Future<void> login(String username, String password) async {
    final row = await (_db.select(_db.localUsers)..where((u) => u.username.equals(username))).getSingleOrNull();
    if (row == null || !row.active || !BCrypt.checkpw(password, row.passwordHash)) {
      throw InvalidCredentialsException();
    }
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(row.id))).write(LocalUsersCompanion(lastLoginAt: Value(DateTime.now())));
    await recordAudit(_db, action: AuditAction.userLoggedIn, actorId: row.id, entityType: 'User', entityId: row.id);
    _ref.read(sessionProvider.notifier).signedIn(DnUser(id: row.id, username: row.username, fullName: row.fullName, role: row.role));
  }

  void logout() {
    _ref.read(sessionProvider.notifier).signOut();
  }

  // ---------------------------------------------------------------- users

  /// The device's own local user directory — no server, so this is the
  /// permanent list, not a cache of a synced one.
  Future<List<LocalUser>> listUsers() => _db.select(_db.localUsers).get();

  /// Creation is instant and final now — no server round-trip to wait on,
  /// so there's nothing left to be "pending sync."
  Future<DnUser> createUser({
    required String fullName,
    required String username,
    required String password,
    required String role,
    String? pin,
    required String actorId,
  }) async {
    final existing = await (_db.select(_db.localUsers)..where((u) => u.username.equals(username))).getSingleOrNull();
    if (existing != null) throw UsernameTakenException();

    final id = _uuid.v4();
    await _db.into(_db.localUsers).insert(
          LocalUsersCompanion.insert(
            id: id,
            fullName: fullName,
            username: username,
            passwordHash: BCrypt.hashpw(password, BCrypt.gensalt()),
            role: role,
            pinHash: Value(pin == null ? null : BCrypt.hashpw(pin, BCrypt.gensalt())),
          ),
        );
    await recordAudit(_db, action: AuditAction.userCreated, actorId: actorId, entityType: 'User', entityId: id, metadata: {'role': role});
    return DnUser(id: id, username: username, fullName: fullName, role: role);
  }

  Future<void> updateUser({required String userId, required String fullName, required String role, required String actorId}) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(userId))).write(
      LocalUsersCompanion(fullName: Value(fullName), role: Value(role)),
    );
    await recordAudit(_db, action: AuditAction.userUpdated, actorId: actorId, entityType: 'User', entityId: userId, metadata: {'fullName': fullName, 'role': role});
  }

  Future<void> setActive({required String userId, required bool active, required String actorId}) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(userId))).write(LocalUsersCompanion(active: Value(active)));
    await recordAudit(_db, action: active ? AuditAction.userActivated : AuditAction.userDeactivated, actorId: actorId, entityType: 'User', entityId: userId);
  }

  Future<void> setPassword({required String userId, required String newPassword, required String actorId}) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(userId))).write(
      LocalUsersCompanion(passwordHash: Value(BCrypt.hashpw(newPassword, BCrypt.gensalt()))),
    );
    await recordAudit(_db, action: AuditAction.userPasswordReset, actorId: actorId, entityType: 'User', entityId: userId);
  }

  Future<void> setPin({required String userId, required String? newPin, required String actorId}) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(userId))).write(
      LocalUsersCompanion(pinHash: Value(newPin == null ? null : BCrypt.hashpw(newPin, BCrypt.gensalt()))),
    );
    await recordAudit(_db, action: AuditAction.userPinReset, actorId: actorId, entityType: 'User', entityId: userId);
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
