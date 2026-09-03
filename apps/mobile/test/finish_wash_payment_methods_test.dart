import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({}); // finish_wash_sheet reads loyaltyScopeProvider, which is backed by this
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
      customer: Customer(id: 'c1', fullName: 'Thabo Mokoena', phone: '62227247'),
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

  testWidgets('every method that needs no precondition is offered; Wallet and Loyalty reward are not', (tester) async {
    await openSheet(tester);

    for (final label in ['Cash', 'Ecocash', 'M-Pesa', 'Card', 'Bank transfer', 'Free Wash']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Wallet'), findsNothing); // no wallet balance for this customer
    expect(find.text('Loyalty reward'), findsNothing); // nothing earned yet
    expect(tester.takeException(), isNull);
  });

  testWidgets('Loyalty reward is offered once the vehicle has an available reward, and redeeming it marks the reward spent', (tester) async {
    // Earn the reward last month so it's valid (redeemable) this month —
    // findAvailableReward only matches the current calendar month.
    final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
    final loyalty = LoyaltyRepository(db);
    for (var i = 1; i <= 5; i++) {
      await loyalty.creditQualifyingWash(
        vehicleId: 'v1',
        customerId: 'c1',
        scope: LoyaltyScope.vehicle,
        washOrderId: 'seed-$i',
        at: lastMonth,
        actorId: 'u1',
      );
    }

    await openSheet(tester);
    expect(find.text('Loyalty reward'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Loyalty reward'));
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

  testWidgets('Wallet is not offered when the balance cannot cover the total', (tester) async {
    await db.into(db.localPrepaidWallets).insert(
          LocalPrepaidWalletsCompanion.insert(customerId: 'c1', balance: 5999, asOf: DateTime.now()), // 1 cent short
        );

    await openSheet(tester);

    expect(find.text('Wallet'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Wallet is offered once the balance covers the total exactly, and paying with it debits the wallet', (tester) async {
    // Exactly equal to the total — >=, not strictly >, since a balance that
    // covers the total to the cent is still a valid way to pay it.
    await db.into(db.localPrepaidWallets).insert(
          LocalPrepaidWalletsCompanion.insert(customerId: 'c1', balance: 6000, asOf: DateTime.now()),
        );

    await openSheet(tester);
    expect(find.text('Wallet'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Wallet'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH'));
    await tester.pumpAndSettle();

    final components = await db.select(db.localPaymentComponents).get();
    expect(components, hasLength(1));
    expect(components.single.method, 'WALLET');

    final wallet = await (db.select(db.localPrepaidWallets)..where((w) => w.customerId.equals('c1'))).getSingle();
    expect(wallet.balance, 0);
    expect(tester.takeException(), isNull);
  });
}
