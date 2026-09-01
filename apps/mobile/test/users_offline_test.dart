import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/users_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER', branchId: 'branch-1'),
        accessToken: 'token',
        refreshToken: 'refresh',
        loading: false,
      );
}

void main() {
  testWidgets('Creating a user offline queues it and shows it as pending sync, not toggleable', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          sessionProvider.overrideWith(_FakeSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: UsersScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining("won't be able to log in until"), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'New Attendant');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'newattendant');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'supersecret1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('New Attendant'), findsOneWidget);
    expect(find.text('Pending sync'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);

    final pendingUsers = await db.select(db.localPendingUsers).get();
    expect(pendingUsers, hasLength(1));
    expect(pendingUsers.single.username, 'newattendant');

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'user');

    expect(tester.takeException(), isNull);
  });
}
