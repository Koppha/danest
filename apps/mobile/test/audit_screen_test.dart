import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/audit_screen.dart';

void main() {
  testWidgets('Audit screen shows local entries with a humanized action and the actor name; SMS tab is an honest empty state', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.into(db.localUsers).insert(
          LocalUsersCompanion.insert(id: 'u1', fullName: 'De Nest Owner', username: 'owner', passwordHash: 'x', role: 'OWNER'),
        );
    await db.into(db.localAuditLog).insert(
          LocalAuditLogCompanion.insert(id: 'a1', action: 'PAYMENT_VOIDED', actorId: const Value('u1'), entityType: const Value('WashOrder')),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: Scaffold(body: AuditScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Payment voided'), findsOneWidget);
    expect(find.textContaining('De Nest Owner'), findsOneWidget);

    await tester.tap(find.text('SMS log'));
    await tester.pumpAndSettle();
    expect(find.textContaining("isn't set up"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('An audit entry with no actor is attributed to System', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.into(db.localAuditLog).insert(LocalAuditLogCompanion.insert(id: 'a1', action: 'REWARD_EXPIRED'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: Scaffold(body: AuditScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('System'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
