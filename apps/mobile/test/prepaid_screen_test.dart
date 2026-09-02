import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/prepaid/prepaid_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'),
        loading: false,
      );
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
          sessionProvider.overrideWith(_FakeSession.new),
        ],
        child: const MaterialApp(home: Scaffold(body: PrepaidScreen())),
      );

  testWidgets('Prepaid screen lists existing customers on load without needing to search first', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'branch-1', fullName: 'Kopano', phone: '+26662227247'),
        );
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c2', branchId: 'branch-1', fullName: 'Thabo Mokoena', phone: '+26658123456'),
        );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Kopano'), findsOneWidget);
    expect(find.text('Thabo Mokoena'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Prepaid screen can create a new customer offline and immediately shows their (empty) wallet', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('No customers found'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add customer'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Palesa Nkosi');
    await tester.enterText(find.widgetWithText(TextField, 'Phone number'), '+26658999999');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    final customers = await db.select(db.localCustomers).get();
    expect(customers, hasLength(1));
    expect(find.text('Palesa Nkosi'), findsWidgets);
    expect(find.text('Prepaid balance'), findsOneWidget);
    expect(find.text('M0.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Depositing to a wallet works fully offline and updates the balance immediately', (tester) async {
    await db.into(db.localCustomers).insert(
          LocalCustomersCompanion.insert(id: 'c1', branchId: 'branch-1', fullName: 'Kopano', phone: '+26662227247'),
        );

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kopano'));
    await tester.pumpAndSettle();
    expect(find.text('M0.00'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Top up wallet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '250');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Deposit'));
    await tester.pumpAndSettle();

    expect(find.text('M250.00'), findsOneWidget);

    final wallets = await db.select(db.localPrepaidWallets).get();
    expect(wallets, hasLength(1));
    expect(wallets.single.balance, 25000); // cents
    final pending = await db.select(db.pendingSyncOps).get();
    expect(pending, hasLength(1));
    expect(pending.single.entityType, 'prepaid_deposit');
    expect(tester.takeException(), isNull);
  });
}
