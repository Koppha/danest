import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/features/wash_queue/finish_wash_sheet.dart';

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'),
        loading: false,
      );
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(
            id: 'w1',
            branchId: 'b',
            vehicleId: 'v1',
            customerId: 'c1',
            status: 'READY',
            totalAmount: 6000,
            createdAt: DateTime.now(),
          ),
        );
  });

  tearDown(() => db.close());

  Future<void> openSheet(WidgetTester tester) async {
    final order = WashOrder(
      id: 'w1',
      status: 'READY',
      totalAmount: 6000,
      createdAt: DateTime.now(),
      vehicle: Vehicle(id: 'v1', customerId: 'c1', regNumberDisplay: 'ABC 123'),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db), sessionProvider.overrideWith(_FakeSession.new)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showFinishWashSheet(context, ref, order),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('every real payment method is offered; Free wash only when a reward is actually available', (tester) async {
    await openSheet(tester);

    for (final label in ['Cash', 'Ecocash', 'M-Pesa', 'Card', 'Bank transfer', 'Wallet', 'Package']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Free wash'), findsNothing); // nothing earned yet
    expect(tester.takeException(), isNull);
  });

  testWidgets('Free wash is offered once the vehicle has an available reward, and redeeming it marks the reward spent', (tester) async {
    // Earn the reward last month so it's valid (redeemable) this month —
    // findAvailableReward only matches the current calendar month.
    final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
    final loyalty = LoyaltyRepository(db);
    for (var i = 1; i <= 5; i++) {
      await loyalty.creditQualifyingWash(vehicleId: 'v1', washOrderId: 'seed-$i', at: lastMonth, actorId: 'u1');
    }

    await openSheet(tester);
    expect(find.text('Free wash'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Free wash'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    final components = await db.select(db.localPaymentComponents).get();
    expect(components, hasLength(1));
    expect(components.single.method, 'LOYALTY_FREE_WASH');

    final reward = await db.select(db.localLoyaltyRewards).getSingle();
    expect(reward.status, 'REDEEMED'); // spent, so this device can't redeem it twice
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting Ecocash requires a reference and records it as MOBILE_MONEY', (tester) async {
    await openSheet(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Ecocash'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Reference number'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Reference number'), 'ECO123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    final components = await db.select(db.localPaymentComponents).get();
    expect(components, hasLength(1));
    expect(components.single.method, 'MOBILE_MONEY');
    expect(components.single.externalReference, 'ECO123');
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting Bank transfer requires a reference too', (tester) async {
    await openSheet(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Bank transfer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    expect(find.textContaining('reference is required'), findsOneWidget);
    expect(await db.select(db.localPayments).get(), isEmpty);
  });

  testWidgets('Cash needs no reference and completes the wash immediately', (tester) async {
    await openSheet(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals('w1'))).getSingle();
    expect(order.status, 'COMPLETED');
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting Wallet with an insufficient balance shows a clear error and completes nothing', (tester) async {
    await openSheet(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Wallet'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Insufficient prepaid balance'), findsOneWidget);
    final order = await (db.select(db.localWashOrders)..where((w) => w.id.equals('w1'))).getSingle();
    expect(order.status, 'READY'); // untouched
  });
}
