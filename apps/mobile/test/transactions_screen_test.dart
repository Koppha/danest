import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/reports_repository.dart';
import 'package:de_nest/features/transactions/transactions_screen.dart';

void main() {
  testWidgets('Transactions screen renders local transaction summaries, including a VOIDED badge', (tester) async {
    final data = [
      TransactionSummary(id: 't1', vehicleRegNumber: 'ABC 123', totalAmount: 6000, methods: const ['CASH'], voided: false, completedAt: DateTime.now()),
      TransactionSummary(id: 't2', vehicleRegNumber: 'XYZ 999', totalAmount: 4500, methods: const ['WALLET'], voided: true, completedAt: DateTime.now()),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [transactionsProvider.overrideWith((ref) async => data)],
        child: const MaterialApp(home: Scaffold(body: TransactionsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ABC 123'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('M60.00'), findsOneWidget);
    expect(find.text('VOIDED'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Transactions screen shows an empty state with nothing in the window', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [transactionsProvider.overrideWith((ref) async => const <TransactionSummary>[])],
        child: const MaterialApp(home: Scaffold(body: TransactionsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No transactions in the last 30 days'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
