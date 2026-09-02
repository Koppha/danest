import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/users_screen.dart';

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'), loading: false);
}

void main() {
  testWidgets('Adding a user creates it instantly (no pending/sync state), and the active switch works locally', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db), sessionProvider.overrideWith(_FakeSession.new)],
        child: const MaterialApp(home: Scaffold(body: UsersScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pending sync'), findsNothing);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'New Attendant');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'newattendant');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'supersecret1');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('New Attendant'), findsOneWidget);
    expect(find.textContaining('Pending sync'), findsNothing);
    // Created for real, immediately — a plaintext password never touches storage.
    final row = await (db.select(db.localUsers)..where((u) => u.username.equals('newattendant'))).getSingle();
    expect(row.passwordHash, isNot('supersecret1'));
    expect(row.active, isTrue);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final updated = await (db.select(db.localUsers)..where((u) => u.username.equals('newattendant'))).getSingle();
    expect(updated.active, isFalse);

    expect(tester.takeException(), isNull);
  });
}
