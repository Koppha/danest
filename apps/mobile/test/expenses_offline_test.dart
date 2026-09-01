import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/expenses_screen.dart';

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
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localExpenseCategories).insert(
          LocalExpenseCategoriesCompanion.insert(id: 'cat-1', name: 'Supplies'),
        );
  });

  tearDown(() => db.close());

  testWidgets('Recording an expense works fully offline and appears in the list', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          sessionProvider.overrideWith(_FakeSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: ExpensesScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No expenses recorded yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Record expense'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supplies').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Car shampoo');
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '150');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Car shampoo'), findsOneWidget);
    expect(find.text('Supplies · CASH'), findsOneWidget);
    expect(find.text('M150.00'), findsOneWidget);

    final rows = await db.select(db.localExpenses).get();
    expect(rows, hasLength(1));
    expect(rows.single.dirty, isTrue);
    final pending = await db.select(db.pendingSyncOps).get();
    expect(pending, hasLength(1));
    expect(pending.single.entityType, 'expense');

    expect(tester.takeException(), isNull);
  });
}
