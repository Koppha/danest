import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/settings_screen.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
    await db.into(db.localWashExtras).insert(
          LocalWashExtrasCompanion.insert(id: 'ext-1', name: 'Tyre Shine', price: 2000),
        );
  });

  tearDown(() => db.close());

  testWidgets('Editing a service price works offline and queues the change, but adding a new service is disabled', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('M60.00'), findsOneWidget);

    // Adding a new service/extra still needs a connection.
    final addServiceButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Add service'), matching: find.byType(TextButton)),
    );
    expect(addServiceButton.onPressed, isNull);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    final priceField = find.widgetWithText(TextField, 'Price (M)');
    await tester.enterText(priceField, '70');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('M70.00'), findsOneWidget);

    final service = await db.select(db.localWashServices).getSingle();
    expect(service.basePrice, 7000); // cents
    expect(service.tier, 'standard');

    final outbox = await db.select(db.pendingSyncOps).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.entityType, 'service');
    expect(outbox.single.opType, 'update');

    expect(tester.takeException(), isNull);
  });
}
