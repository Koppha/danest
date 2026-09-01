import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/data/remote/pos_repository.dart';
import 'package:de_nest/features/customers/customers_screen.dart';

class _FakePosRepository extends PosRepository {
  _FakePosRepository() : super(Dio());

  @override
  Future<List<Customer>> searchCustomers(String query) async => [];
}

void main() {
  testWidgets('Add customer dialog stays usable (no overflow) when the on-screen keyboard opens', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [posRepositoryProvider.overrideWithValue(_FakePosRepository())],
        child: const MaterialApp(home: Scaffold(body: CustomersScreen())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add customer'));
    await tester.pumpAndSettle();
    expect(find.text('Add customer'), findsWidgets);

    // Simulate the on-screen keyboard covering the bottom ~40% of the
    // screen, as happens when the Phone number field gets focus.
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
