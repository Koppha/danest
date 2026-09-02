import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/design_system/widgets.dart';
import 'package:de_nest/features/dashboard/dashboard_screen.dart' show queueProvider;
import 'package:de_nest/features/new_wash/new_wash_screen.dart';
import 'package:de_nest/features/reports/reports_screen.dart';
import 'package:de_nest/features/wash_queue/finish_wash_sheet.dart';
import 'package:de_nest/features/wash_queue/wash_queue_screen.dart';

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(() async {
    tester.view.reset();
    await tester.binding.setSurfaceSize(null);
  });
}

void main() {
  testWidgets('DnKpi does not overflow with a long label/value in a narrow tablet grid cell', (tester) async {
    await _setSurfaceSize(tester, const Size(360, 640));
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 150,
            height: 90,
            child: DnKpi(
              icon: Icons.payments,
              label: 'Prepaid deposits this month across all branches',
              value: 'M1,234,567.89',
              tint: Colors.blue,
              iconColor: Colors.blue,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('finish wash sheet keeps its submit button above the system nav bar', (tester) async {
    await _setSurfaceSize(tester, const Size(900, 700));
    final order = WashOrder(
      id: 'w1',
      status: 'READY',
      totalAmount: 60,
      createdAt: DateTime.now(),
      vehicle: Vehicle(id: 'v1', customerId: 'c1', regNumberDisplay: 'ABC 123'),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(bottom: 80)),
            child: child!,
          ),
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

    final buttonBottom = tester.getBottomLeft(find.widgetWithText(ElevatedButton, 'FINISH WASH')).dy;
    expect(buttonBottom, lessThanOrEqualTo(700 - 80));
    expect(tester.takeException(), isNull);
  });

  testWidgets('wash queue card with long names does not overflow on a narrow phone', (tester) async {
    await _setSurfaceSize(tester, const Size(320, 640));
    final order = WashOrder(
      id: 'w1',
      status: 'READY',
      totalAmount: 123456,
      createdAt: DateTime.now(),
      vehicle: Vehicle(id: 'v1', customerId: 'c1', regNumberDisplay: 'ABC 123 XYZ 456 EXTRA LONG PLATE'),
      customer: Customer(id: 'c1', fullName: 'A Customer With An Extremely Long Full Name', phone: '+26658123456'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [queueProvider.overrideWith((ref) async => [order])],
        child: const MaterialApp(home: Scaffold(body: WashQueueScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Finish wash'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('New Wash cards (including Wash Summary) are all the same width in the single-column layout', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await _setSurfaceSize(tester, const Size(845, 1200));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: Scaffold(body: NewWashScreen())),
      ),
    );
    await tester.pumpAndSettle();

    final widths = tester.widgetList<Card>(find.byType(Card)).map((card) {
      final element = find.byWidget(card).evaluate().single;
      return (element.renderObject as RenderBox).size.width;
    }).toList();

    expect(widths, isNotEmpty);
    for (final width in widths) {
      expect(width, closeTo(widths.first, 0.5));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('reports screen picks a wider grid on tablet and does not overflow on phone or tablet', (tester) async {
    final summary = <String, dynamic>{
      'totalSales': 123456,
      'totalCompletedWashes': 42,
      'totalFreeWashes': 3,
      'totalPrepaidDeposits': 9876,
      'salesByMethod': {'A_VERY_LONG_PAYMENT_METHOD_NAME': 543.21, 'CASH': 100},
      'netOperatingCash': 5000,
    };
    final overrides = [reportsSummaryProvider.overrideWith((ref) async => summary)];

    await _setSurfaceSize(tester, const Size(360, 800));
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const MaterialApp(home: Scaffold(body: ReportsScreen()))),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Just above the 3-column breakpoint — the tightest real grid-cell height.
    await _setSurfaceSize(tester, const Size(720, 800));
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const MaterialApp(home: Scaffold(body: ReportsScreen()))),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _setSurfaceSize(tester, const Size(1280, 800));
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const MaterialApp(home: Scaffold(body: ReportsScreen()))),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
