import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/local/prepaid_repository.dart';
import 'package:de_nest/data/local/wash_orders_repository.dart';
import 'package:de_nest/features/admin/collections_screen.dart';

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'), loading: false);
}

void main() {
  testWidgets('Cash Collection shows the computed expected total and confirming persists it, fully standalone', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final prepaid = PrepaidRepository(db);
    final washOrders = WashOrdersRepository(db, prepaid, LoyaltyRepository(db));

    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
    final order = await washOrders.startWash(vehicleId: 'v1', customerId: 'c1', items: [
      {'itemType': 'SERVICE', 'serviceId': 'svc-1'},
    ], actorId: 'u1');
    await washOrders.finishWash(order.id, [
      {'method': 'CASH', 'amount': 6000},
    ], actorId: 'u1');
    await db.into(db.localExpenses).insert(
          LocalExpensesCompanion.insert(
            id: 'e1',
            branchId: 'main',
            categoryId: 'cat-1',
            description: 'Detergent',
            amount: 500,
            paymentMethod: 'CASH',
            createdAt: DateTime.now(),
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db), sessionProvider.overrideWith(_FakeSession.new)],
        child: const MaterialApp(home: Scaffold(body: CollectionsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    // No online/offline distinction any more — the expected breakdown is
    // always computable locally: M60.00 in cash sales minus a M5.00 expense.
    expect(find.text('Expected cash'), findsOneWidget);
    expect(find.text('M60.00'), findsOneWidget);
    expect(find.text('M55.00'), findsOneWidget);

    // A mismatch with no reason is rejected outright, not queued for later.
    await tester.enterText(find.widgetWithText(TextField, 'Actual cash counted'), '50');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Confirm collection'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm collection'));
    await tester.pumpAndSettle();
    expect(find.textContaining('A reason is required'), findsOneWidget);
    expect(await db.select(db.localCashCollections).get(), isEmpty);
    // Let the first SnackBar's auto-dismiss timer clear it — otherwise it
    // still covers the button and swallows the next tap.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Matching the expected count succeeds immediately.
    await tester.enterText(find.widgetWithText(TextField, 'Actual cash counted'), '55');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Confirm collection'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm collection'));
    await tester.pumpAndSettle();

    expect(find.text('Collection confirmed'), findsOneWidget);
    final rows = await db.select(db.localCashCollections).get();
    expect(rows, hasLength(1));
    expect(rows.single.countedCash, 5500);

    expect(tester.takeException(), isNull);
  });
}
