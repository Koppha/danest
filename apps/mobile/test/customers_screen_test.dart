import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/data/remote/pos_repository.dart';
import 'package:de_nest/features/customers/customers_screen.dart';

class _FakePosRepository extends PosRepository {
  _FakePosRepository() : super(Dio());
  final List<Customer> created = [];

  @override
  Future<List<Customer>> searchCustomers(String query) async => List.of(created);

  @override
  Future<Customer> createCustomer({required String fullName, required String phone, required String branchId}) async {
    final customer = Customer(id: 'c${created.length + 1}', fullName: fullName, phone: phone);
    created.add(customer);
    return customer;
  }
}

void main() {
  testWidgets('Customers screen can create a new customer from the Add customer button', (tester) async {
    final fakeRepo = _FakePosRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [posRepositoryProvider.overrideWithValue(fakeRepo)],
        child: const MaterialApp(home: Scaffold(body: CustomersScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No customers found'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add customer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Palesa Nkosi');
    await tester.enterText(find.widgetWithText(TextField, 'Phone number'), '+26658999999');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(fakeRepo.created, hasLength(1));
    expect(fakeRepo.created.single.fullName, 'Palesa Nkosi');
    expect(find.text('Palesa Nkosi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
