import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/core/session.dart';
import 'package:de_nest/features/admin/users_screen.dart';

class _FakeSession extends SessionNotifier {
  @override
  SessionState build() => const SessionState(
        user: DnUser(id: 'u1', username: 'owner', fullName: 'De Nest Owner', role: 'OWNER'),
        loading: false,
      );
}

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

void main() {
  testWidgets('Add user is reachable and opens a form with the expected fields when online', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_FakeSession.new),
          usersProvider.overrideWith((ref) async => <dynamic>[
                {
                  'id': 'u1',
                  'fullName': 'De Nest Owner',
                  'username': 'owner',
                  'active': true,
                  'role': {'name': 'OWNER'},
                },
              ]),
        ],
        child: const MaterialApp(home: UsersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('De Nest Owner'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add user'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Full name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add user stays reachable offline (queues for sync), with an offline notice shown', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith(_FakeSession.new),
          connectivityProvider.overrideWith(_AlwaysOffline.new),
          usersProvider.overrideWith((ref) async => <dynamic>[]),
        ],
        child: const MaterialApp(home: UsersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Offline —'), findsOneWidget);
    final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    expect(fab.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });
}
