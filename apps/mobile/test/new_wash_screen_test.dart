import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/new_wash/new_wash_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'), loading: false);
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'main', fullName: 'Kopano', phone: '62227247'),
        );
    await db.into(db.localVehicles).insert(
          LocalVehiclesCompanion.insert(id: 'v1', customerId: 'c1', regNumberNormalized: 'K2075', regNumberDisplay: 'K 2075'),
        );
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 5000, durationMinutes: 15),
        );
  });

  tearDown(() => db.close());

  Widget wrap() => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          sessionProvider.overrideWith(_FakeSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: NewWashScreen())),
      );

  testWidgets('selecting a customer and vehicle updates the Wash Summary', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Phone number or registration'), 'Kopano');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle();

    // The customer/vehicle tiles are the tappable InkWells; find.text()
    // alone is ambiguous once the search box contains the same string.
    await tester.tap(find.widgetWithText(InkWell, 'Kopano'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(InkWell, 'K 2075'));
    await tester.pumpAndSettle();

    expect(find.text('Not selected'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a debounced re-search that resolves after a selection does not clear it', (tester) async {
    // This is the exact regression: the search box's listener arms a
    // 350ms debounce timer on every keystroke. Explicitly tapping "Search"
    // resolves first, but that timer is still pending — when it later
    // fires and calls _search() again, it used to unconditionally null
    // out whatever the user had since picked, with no error or warning.
    //
    // Using bare pump() (no duration) rather than pumpAndSettle() for the
    // steps in between is deliberate: pumpAndSettle keeps pumping in
    // growing steps until nothing is left scheduled, which is enough real
    // time to let the 350ms timer fire on its own — masking the bug by
    // having it go off harmlessly before anything was ever selected.
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Phone number or registration'), 'Kopano');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.widgetWithText(InkWell, 'Kopano'));
    await tester.pump();
    await tester.tap(find.widgetWithText(InkWell, 'K 2075'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Not selected'), findsNothing);

    // Only now let the still-pending debounce timer actually fire.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Not selected'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
