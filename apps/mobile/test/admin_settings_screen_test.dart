import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/models/models.dart';
import 'package:de_nest/features/admin/settings_screen.dart';

void main() {
  final service = WashService(id: 's1', name: 'Standard Wash', tier: 'standard', basePrice: 60, durationMinutes: 15);
  final extra = WashExtra(id: 'e1', name: 'Tyre Shine', price: 20);

  testWidgets('Editing a service opens a form pre-filled with its current name and price', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          servicesSettingsProvider.overrideWith((ref) async => [service]),
          extrasSettingsProvider.overrideWith((ref) async => [extra]),
        ],
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithIcon(IconButton, Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Edit service'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    final nameField = tester.widget<TextField>(find.widgetWithText(TextField, 'Name'));
    expect(nameField.controller!.text, 'Standard Wash');
    expect(tester.takeException(), isNull);
  });
}
