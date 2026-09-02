import 'package:bcrypt/bcrypt.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/auth/first_run_setup_screen.dart';
import 'package:de_nest/features/auth/login_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Widget wrap(Widget child) => ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: child),
      );

  testWidgets('First-run setup creates the owner account and signs them in', (tester) async {
    final container = ProviderContainer(overrides: [appDatabaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MaterialApp(home: FirstRunSetupScreen())),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'De Nest Owner');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'owner');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'supersecret1');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'supersecret1');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.pumpAndSettle();

    expect(find.text('Could not create the account'), findsNothing);
    final session = container.read(sessionProvider);
    expect(session.user?.username, 'owner');
    expect(session.user?.role, 'OWNER');
  });

  testWidgets('First-run setup rejects a short password without creating a user', (tester) async {
    await tester.pumpWidget(wrap(const FirstRunSetupScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'De Nest Owner');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'owner');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'short');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'short');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.pumpAndSettle();

    expect(find.textContaining('at least 8 characters'), findsOneWidget);
    expect(await db.select(db.localUsers).get(), isEmpty);
  });

  testWidgets('Login succeeds with the correct password and fails with the wrong one', (tester) async {
    await db.into(db.localUsers).insert(
          LocalUsersCompanion.insert(
            id: 'u1',
            fullName: 'De Nest Owner',
            username: 'owner',
            passwordHash: BCrypt.hashpw('supersecret1', BCrypt.gensalt()),
            role: 'OWNER',
          ),
        );
    final container = ProviderContainer(overrides: [appDatabaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MaterialApp(home: LoginScreen())));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'owner');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'wrongpassword');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password'), findsOneWidget);
    expect(container.read(sessionProvider).isAuthenticated, isFalse);

    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'supersecret1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(container.read(sessionProvider).user?.username, 'owner');
  });
}
