import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/auth_repository.dart';
import 'package:de_nest/data/local/database_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late AuthRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(overrides: [appDatabaseProvider.overrideWithValue(db)]);
    repo = container.read(authRepositoryProvider);
  });

  tearDown(() async {
    await db.close();
    container.dispose();
  });

  test('a fresh database has no users', () async {
    expect(await repo.hasAnyUsers(), isFalse);
  });

  test('creating the first owner signs them in and makes hasAnyUsers true', () async {
    await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');

    expect(await repo.hasAnyUsers(), isTrue);
    final session = container.read(sessionProvider);
    expect(session.user?.username, 'owner');
    expect(session.user?.role, 'OWNER');

    final rows = await db.select(db.localUsers).get();
    expect(rows, hasLength(1));
    expect(rows.single.passwordHash, isNot('supersecret1')); // never stored in plaintext
    expect(BCrypt.checkpw('supersecret1', rows.single.passwordHash), isTrue);
  });

  test('logging in with the correct password succeeds and records lastLoginAt', () async {
    await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
    container.read(sessionProvider.notifier).signOut();

    await repo.login('owner', 'supersecret1');

    expect(container.read(sessionProvider).user?.username, 'owner');
    final row = await db.select(db.localUsers).getSingle();
    expect(row.lastLoginAt, isNotNull);
  });

  test('logging in with the wrong password throws the generic invalid-credentials error', () async {
    await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
    container.read(sessionProvider.notifier).signOut();

    await expectLater(repo.login('owner', 'wrongpassword'), throwsA(isA<InvalidCredentialsException>()));
  });

  test('logging in as a username that does not exist throws the same generic error (no enumeration)', () async {
    await expectLater(repo.login('nobody', 'whatever'), throwsA(isA<InvalidCredentialsException>()));
  });

  test('an inactive user cannot log in even with the correct password', () async {
    await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
    await (db.update(db.localUsers)..where((u) => u.username.equals('owner'))).write(const LocalUsersCompanion(active: Value(false)));
    container.read(sessionProvider.notifier).signOut();

    await expectLater(repo.login('owner', 'supersecret1'), throwsA(isA<InvalidCredentialsException>()));
  });

  group('verifyPinOverride', () {
    Future<String> seedUser({required String role, String? pin}) async {
      final id = '$role-id';
      await db.into(db.localUsers).insert(
            LocalUsersCompanion.insert(
              id: id,
              fullName: role,
              username: role.toLowerCase(),
              passwordHash: BCrypt.hashpw('irrelevant', BCrypt.gensalt()),
              role: role,
              pinHash: Value(pin == null ? null : BCrypt.hashpw(pin, BCrypt.gensalt())),
            ),
          );
      return id;
    }

    test('accepts a supervisor PIN approving their own action', () async {
      final id = await seedUser(role: 'SUPERVISOR', pin: '1234');
      final approvedBy = await repo.verifyPinOverride(pin: '1234', currentUserId: id);
      expect(approvedBy, id);
    });

    test('accepts an owner-by-username override even when the current user is an attendant', () async {
      final attendantId = await seedUser(role: 'ATTENDANT', pin: '0000');
      final ownerId = await seedUser(role: 'OWNER', pin: '9999');
      final approvedBy = await repo.verifyPinOverride(pin: '9999', overrideUsername: 'owner', currentUserId: attendantId);
      expect(approvedBy, ownerId);
    });

    test('rejects a wrong PIN', () async {
      final id = await seedUser(role: 'SUPERVISOR', pin: '1234');
      await expectLater(repo.verifyPinOverride(pin: '0000', currentUserId: id), throwsA(isA<InvalidPinOverrideException>()));
    });

    test('rejects an attendant approving their own action (below SUPERVISOR)', () async {
      final id = await seedUser(role: 'ATTENDANT', pin: '1234');
      await expectLater(repo.verifyPinOverride(pin: '1234', currentUserId: id), throwsA(isA<InvalidPinOverrideException>()));
    });

    test('rejects a supervisor with no PIN set at all', () async {
      final id = await seedUser(role: 'SUPERVISOR');
      await expectLater(repo.verifyPinOverride(pin: '1234', currentUserId: id), throwsA(isA<InvalidPinOverrideException>()));
    });
  });

  group('user management', () {
    test('createUser makes a real, immediately-usable account — no pending/sync state involved', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;

      final created = await repo.createUser(fullName: 'New Attendant', username: 'newattendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);
      expect(created.role, 'ATTENDANT');

      container.read(sessionProvider.notifier).signOut();
      await repo.login('newattendant', 'supersecret1'); // works right away, no sync step needed
      expect(container.read(sessionProvider).user?.username, 'newattendant');

      final row = await (db.select(db.localUsers)..where((u) => u.username.equals('newattendant'))).getSingle();
      expect(row.passwordHash, isNot('supersecret1'));
    });

    test('createUser rejects a username that is already taken', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;

      await expectLater(
        repo.createUser(fullName: 'Someone Else', username: 'owner', password: 'supersecret1', role: 'ATTENDANT', actorId: owner),
        throwsA(isA<UsernameTakenException>()),
      );
    });

    test('setActive(false) deactivates a user, who then cannot log in even with the right password', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      final attendant = await repo.createUser(fullName: 'Attendant', username: 'attendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);

      await repo.setActive(userId: attendant.id, active: false, actorId: owner);
      container.read(sessionProvider.notifier).signOut();

      await expectLater(repo.login('attendant', 'supersecret1'), throwsA(isA<InvalidCredentialsException>()));
    });

    test('setPassword replaces the password — the old one stops working, the new one works', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      final attendant = await repo.createUser(fullName: 'Attendant', username: 'attendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);

      await repo.setPassword(userId: attendant.id, newPassword: 'brandnewpassword', actorId: owner);
      container.read(sessionProvider.notifier).signOut();

      await expectLater(repo.login('attendant', 'supersecret1'), throwsA(isA<InvalidCredentialsException>()));
      await repo.login('attendant', 'brandnewpassword');
      expect(container.read(sessionProvider).user?.username, 'attendant');
    });

    test('setPin replaces the PIN used for override verification', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      final supervisor = await repo.createUser(fullName: 'Supervisor', username: 'supervisor', password: 'supersecret1', role: 'SUPERVISOR', pin: '1111', actorId: owner);

      await repo.setPin(userId: supervisor.id, newPin: '2222', actorId: owner);

      await expectLater(repo.verifyPinOverride(pin: '1111', currentUserId: supervisor.id), throwsA(isA<InvalidPinOverrideException>()));
      final approvedBy = await repo.verifyPinOverride(pin: '2222', currentUserId: supervisor.id);
      expect(approvedBy, supervisor.id);
    });

    test('updateUser changes fullName and role', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      final attendant = await repo.createUser(fullName: 'Attendant', username: 'attendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);

      await repo.updateUser(userId: attendant.id, fullName: 'Senior Attendant', role: 'SUPERVISOR', actorId: owner);

      final row = await (db.select(db.localUsers)..where((u) => u.id.equals(attendant.id))).getSingle();
      expect(row.fullName, 'Senior Attendant');
      expect(row.role, 'SUPERVISOR');
    });

    test('listUsers returns every local account', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      await repo.createUser(fullName: 'Attendant', username: 'attendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);

      final users = await repo.listUsers();
      expect(users.map((u) => u.username), containsAll(['owner', 'attendant']));
    });
  });

  group('audit trail', () {
    test('creating the first owner records a USER_CREATED entry', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final entries = await db.select(db.localAuditLog).get();
      expect(entries.map((e) => e.action), contains('USER_CREATED'));
    });

    test('createUser records a USER_CREATED entry attributed to whoever created the account', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      final owner = container.read(sessionProvider).user!.id;
      final attendant = await repo.createUser(fullName: 'Attendant', username: 'attendant', password: 'supersecret1', role: 'ATTENDANT', actorId: owner);

      final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(attendant.id))).get();
      expect(entries, hasLength(1));
      expect(entries.single.action, 'USER_CREATED');
      expect(entries.single.actorId, owner);
    });

    test('logging in records a USER_LOGGED_IN entry', () async {
      await repo.createFirstOwner(fullName: 'De Nest Owner', username: 'owner', password: 'supersecret1');
      container.read(sessionProvider.notifier).signOut();

      await repo.login('owner', 'supersecret1');

      final entries = await db.select(db.localAuditLog).get();
      expect(entries.map((e) => e.action), contains('USER_LOGGED_IN'));
    });
  });
}
