import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/collections_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'),
        loading: false,
      );
}

void main() {
  testWidgets('Recording a cash count works fully offline, with no expected/variance shown', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          sessionProvider.overrideWith(_FakeSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: CollectionsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    // No live expected/variance breakdown while offline.
    expect(find.text('Expected cash'), findsNothing);
    expect(find.textContaining("can't be calculated without a connection"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Queue collection count'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Actual cash counted'), '850');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Queue collection count'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.localCashCollections).get();
    expect(rows, hasLength(1));
    expect(rows.single.countedCash, 850);
    expect(rows.single.branchId, 'main');

    final pending = await db.select(db.pendingSyncOps).get();
    expect(pending, hasLength(1));
    expect(pending.single.entityType, 'collection');

    expect(find.text('Collection queued — will be confirmed once reconnected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
