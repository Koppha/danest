import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:de_nest/core/session.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/local/loyalty_repository.dart';
import 'package:de_nest/data/local/settings_repository.dart';
import 'package:de_nest/features/admin/settings_screen.dart';

class _FakeOwnerSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'),
        loading: false,
      );
}

class _FakeAttendantSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u2', username: 'attendant', fullName: 'Att Endant', role: 'ATTENDANT'),
        loading: false,
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 2000),
        );
  });

  tearDown(() => db.close());

  Widget wrap({SessionNotifier Function()? session}) => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          if (session != null) sessionProvider.overrideWith(session),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );

  testWidgets('Editing a service price updates it immediately, with no server round-trip to queue', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('M60.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Price (M)'), '70');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('M70.00'), findsOneWidget);
    final service = await db.select(db.localWashServices).getSingle();
    expect(service.basePrice, 7000); // cents
    expect(service.tier, 'standard'); // untouched field must survive the update

    expect(await db.select(db.pendingSyncOps).get(), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Adding a new service is not disabled, and creates a real, immediately-usable service', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final addServiceButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Add service'), matching: find.byType(TextButton)),
    );
    expect(addServiceButton.onPressed, isNotNull);

    await tester.tap(find.text('Add service'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Premium Wash');
    await tester.enterText(find.widgetWithText(TextField, 'Price (M)'), '90');
    await tester.enterText(find.widgetWithText(TextField, 'Duration (minutes)'), '25');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Premium Wash'), findsOneWidget);
    expect(find.text('M90.00'), findsOneWidget);
    final services = await db.select(db.localWashServices).get();
    expect(services, hasLength(2));
    expect(services.any((s) => s.name == 'Premium Wash' && s.basePrice == 9000 && s.durationMinutes == 25), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Adding a new extra is not disabled, and creates a real, immediately-usable extra', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final addExtraButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Add extra'), matching: find.byType(TextButton)),
    );
    expect(addExtraButton.onPressed, isNotNull);

    await tester.tap(find.text('Add extra'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Air Freshener');
    await tester.enterText(find.widgetWithText(TextField, 'Price (M)'), '15');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Air Freshener'), findsOneWidget);
    final extras = await db.select(db.localWashExtras).get();
    expect(extras, hasLength(2));
    expect(extras.any((e) => e.name == 'Air Freshener' && e.price == 1500), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the loyalty scope toggle is only visible to the owner', (tester) async {
    await tester.pumpWidget(wrap(session: _FakeAttendantSession.new));
    await tester.pumpAndSettle();
    expect(find.text('Loyalty program'), findsNothing);
  });

  testWidgets('the owner can switch loyalty tracking to per-customer, and it persists', (tester) async {
    await tester.pumpWidget(wrap(session: _FakeOwnerSession.new));
    await tester.pumpAndSettle();

    expect(find.text('Loyalty program'), findsOneWidget);
    expect(find.textContaining('twice as fast'), findsOneWidget); // default: per-vehicle

    await tester.tap(find.text('Per customer'));
    await tester.pumpAndSettle();

    expect(find.textContaining('one shared free wash'), findsOneWidget);
    final settings = SettingsRepository();
    expect(await settings.loyaltyScope(), LoyaltyScope.customer);
    expect(tester.takeException(), isNull);
  });
}
