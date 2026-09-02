import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/features/admin/expenses_screen.dart';

// Prisma serializes Decimal fields (totalAmount, amount, etc.) as JSON
// strings, not numbers. That boundary is gone now that every screen reads
// through a local repository (see transactions_screen_test.dart for the
// transactions-screen coverage that used to live here) — this test only
// still applies to expenses_screen.dart's raw-map rendering.
void main() {
  // expenses_screen.dart reads through OfflinePosRepository.listExpenses(),
  // which normalizes both the online and offline paths to int cents before
  // the screen ever sees the data — so by the time it's here, it's already
  // an int, not a raw Decimal string.
  testWidgets('Expenses screen renders a cents amount correctly', (tester) async {
    final data = [
      {
        'id': 'e1',
        'description': 'Detergent',
        'amount': 15000,
        'paymentMethod': 'CASH',
        'category': {'name': 'Supplies'},
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expensesProvider.overrideWith((ref) async => data),
          expenseCategoriesProvider.overrideWith((ref) async => <dynamic>[]),
        ],
        child: const MaterialApp(home: Scaffold(body: ExpensesScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('M150.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
