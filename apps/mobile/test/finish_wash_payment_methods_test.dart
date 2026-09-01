import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/features/wash_queue/finish_wash_sheet.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localWashOrders).insert(
          LocalWashOrdersCompanion.insert(
            id: 'w1',
            branchId: 'b',
            vehicleId: 'v',
            customerId: 'c',
            status: 'READY',
            totalAmount: 60,
            createdAt: DateTime.now(),
          ),
        );
  });

  tearDown(() => db.close());

  Future<void> openSheet(WidgetTester tester, {List<Override> extraOverrides = const []}) async {
    final order = WashOrder(
      id: 'w1',
      status: 'READY',
      totalAmount: 60,
      createdAt: DateTime.now(),
      vehicle: Vehicle(id: 'v1', customerId: 'c1', regNumberDisplay: 'ABC 123'),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db), ...extraOverrides],
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

  testWidgets('only Cash, Ecocash, M-Pesa, Card and Free wash (when earned) are offered', (tester) async {
    await db.into(db.localLoyaltySummaries).insert(
          LocalLoyaltySummariesCompanion.insert(vehicleId: 'v1', qualifyingCount: 5, hasAvailableReward: true, asOf: DateTime.now()),
        );
    await openSheet(tester);

    for (final label in ['Cash', 'Ecocash', 'M-Pesa', 'Card', 'Free wash']) {
      expect(find.text(label), findsOneWidget);
    }
    for (final removed in ['Mobile money', 'Bank transfer', 'Prepaid balance', 'Wash package']) {
      expect(find.text(removed), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Free wash is hidden when the vehicle has no reward available', (tester) async {
    // No loyalty summary seeded — vehicle hasn't earned a free wash yet.
    await openSheet(tester);

    for (final label in ['Cash', 'Ecocash', 'M-Pesa', 'Card']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Free wash'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting Ecocash requires a reference and records it as MOBILE_MONEY', (tester) async {
    await openSheet(tester, extraOverrides: [connectivityProvider.overrideWith(_AlwaysOffline.new)]);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Ecocash'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Reference number'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Reference number'), 'ECO123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'FINISH WASH & SEND SMS'));
    await tester.pumpAndSettle();

    final components = await db.select(db.localPaymentComponents).get();
    expect(components, hasLength(1));
    expect(components.single.method, 'MOBILE_MONEY');
    expect(components.single.externalReference, 'ECO123');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Free wash is hidden offline but Ecocash/M-Pesa remain available', (tester) async {
    await openSheet(tester, extraOverrides: [connectivityProvider.overrideWith(_AlwaysOffline.new)]);

    expect(find.text('Free wash'), findsNothing);
    expect(find.text('Ecocash'), findsOneWidget);
    expect(find.text('M-Pesa'), findsOneWidget);
    expect(find.textContaining('free washes are unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
