import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/features/admin/expenses_screen.dart';
import 'package:de_nest/features/transactions/transactions_screen.dart';

// Prisma serializes Decimal fields (totalAmount, amount, etc.) as JSON
// strings, not numbers.
void main() {
  // transactions_screen.dart still reads raw API responses directly (no
  // typed model, no repository normalization) — this screen is still
  // online-only pending Phase 7 of the standalone-app rewrite.
  testWidgets('Transactions screen renders amounts that arrive as Decimal strings', (tester) async {
    final data = [
      {
        'id': 't1',
        'totalAmount': '60.00',
        'voided': false,
        'washOrder': {
          'vehicle': {'regNumberDisplay': 'ABC 123'},
        },
        'components': [
          {
            'paymentMethod': {'code': 'CASH'},
          },
        ],
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [transactionsProvider.overrideWith((ref) async => data)],
        child: const MaterialApp(home: Scaffold(body: TransactionsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('M60.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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
