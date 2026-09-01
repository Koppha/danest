import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/customers/customers_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Widget buildScreen() => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
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
}
