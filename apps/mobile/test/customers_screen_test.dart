import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/customers/customers_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

class _OwnerSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'), loading: false);
}

class _AttendantSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(user: DnUser(id: 'u2', username: 'atten', fullName: 'An Attendant', role: 'ATTENDANT'), loading: false);
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Widget buildScreen({bool asOwner = false}) => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          sessionProvider.overrideWith(asOwner ? _OwnerSession.new : _AttendantSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: CustomersScreen())),
      );

  testWidgets('Customers screen can create a new customer from the Add customer button, offline', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('No customers found'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add customer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Palesa Nkosi');
    await tester.enterText(find.widgetWithText(TextField, 'Phone number'), '+26658999999');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.localCustomers).get();
    expect(rows, hasLength(1));
    expect(rows.single.fullName, 'Palesa Nkosi');
    expect(find.text('Palesa Nkosi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Typing a query filters results live, without pressing Search or Enter — works offline too', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'b1', fullName: 'Kopano', phone: '+26662227247'),
        );
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c2', branchId: 'b1', fullName: 'Thabo Mokoena', phone: '+26658123456'),
        );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Kopano'), findsOneWidget);
    expect(find.text('Thabo Mokoena'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'kopano');
    // Before the debounce fires, stale results must not linger unfiltered.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Kopano'), findsOneWidget);
    expect(find.text('Thabo Mokoena'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a non-owner sees no edit or delete controls on a customer card', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'b1', fullName: 'Kopano', phone: '62227247'),
        );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.edit_outlined), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('the owner can edit an existing customer\'s name and phone', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'b1', fullName: 'Kopano', phone: '62227247'),
        );

    await tester.pumpWidget(buildScreen(asOwner: true));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Edit customer'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Full name'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Kopano Ramaisela');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    final row = await (db.select(db.localCustomers)..where((c) => c.id.equals('c1'))).getSingle();
    expect(row.fullName, 'Kopano Ramaisela');
    expect(find.text('Kopano Ramaisela'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the owner can delete a customer, which removes them from the list', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'b1', fullName: 'Kopano', phone: '62227247'),
        );

    await tester.pumpWidget(buildScreen(asOwner: true));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete customer?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    final row = await (db.select(db.localCustomers)..where((c) => c.id.equals('c1'))).getSingle();
    expect(row.active, false);
    expect(find.text('Kopano'), findsNothing);
    expect(find.text('No customers found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
