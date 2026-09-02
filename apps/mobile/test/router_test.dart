import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/app/router.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';

void main() {
  testWidgets('completing first-run setup actually navigates to the dashboard, not just signs in', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: Consumer(builder: (context, ref, _) => MaterialApp.router(routerConfig: ref.watch(routerProvider))),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to De Nest Car Wash'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'De Nest Owner');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'owner');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'supersecret1');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'supersecret1');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create owner account'));
    await tester.pumpAndSettle();

    // Before the router fix, this stayed on the setup screen forever —
    // the account really was created (a second submission would hit a
    // UNIQUE constraint on the username), but nothing ever navigated away.
    expect(find.text('Welcome to De Nest Car Wash'), findsNothing);
    expect(find.text('Dashboard'), findsOneWidget);

    // The dashboard holds Drift .watch() stream subscriptions (e.g. the
    // sync-issue badge); their teardown schedules a zero-duration timer
    // that only fires once the widget tree is actually disposed. Normally
    // that disposal happens automatically after this callback returns —
    // too late for this test to pump for it — so tear the tree down here,
    // while still in control, and pump once more to flush that timer.
    // Otherwise flutter_test's own post-test check trips over it, which
    // has nothing to do with the routing behavior this test covers.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
