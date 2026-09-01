import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/data/remote/pos_repository.dart';
import 'package:de_nest/features/prepaid/prepaid_screen.dart';

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER', branchId: 'branch-1'),
        accessToken: 'token',
        refreshToken: 'refresh',
        loading: false,
      );
}

class _FakePosRepository extends PosRepository {
  _FakePosRepository({List<Customer>? seed}) : customers = seed ?? [], super(Dio());
  final List<Customer> customers;
  final Map<String, double> balances = {};

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    if (query.isEmpty) return List.of(customers);
    final q = query.toLowerCase();
    return customers.where((c) => c.fullName.toLowerCase().contains(q)).toList();
  }

  @override
  Future<Customer> createCustomer({required String fullName, required String phone, required String branchId}) async {
    final customer = Customer(id: 'c${customers.length + 1}', fullName: fullName, phone: phone);
    customers.add(customer);
    return customer;
  }

  @override
  Future<Map<String, dynamic>> prepaidOverview(String customerId) async {
    return {'balance': balances[customerId] ?? 0.0, 'packages': <dynamic>[]};
  }
}

void main() {
  testWidgets('Prepaid screen lists existing customers on load without needing to search first', (tester) async {
    final fakeRepo = _FakePosRepository(seed: [
      Customer(id: 'c1', fullName: 'Kopano', phone: '+26662227247'),
      Customer(id: 'c2', fullName: 'Thabo Mokoena', phone: '+26658123456'),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [posRepositoryProvider.overrideWithValue(fakeRepo)],
        child: const MaterialApp(home: Scaffold(body: PrepaidScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kopano'), findsOneWidget);
    expect(find.text('Thabo Mokoena'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Prepaid screen can create a new customer and immediately shows their wallet', (tester) async {
    final fakeRepo = _FakePosRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_FakeSession.new),
          posRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(home: Scaffold(body: PrepaidScreen())),
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

    expect(fakeRepo.customers, hasLength(1));
    expect(find.text('Palesa Nkosi'), findsWidgets);
    expect(find.text('Prepaid balance'), findsOneWidget);
    expect(find.text('M0.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
