import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/backup_repository.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/features/admin/backups_screen.dart';

/// The real repository does PBKDF2/AES-GCM on a background isolate — real
/// asynchronous work that testWidgets' fake-async zone cannot drive, and
/// which is already covered end-to-end by backup_repository_test.dart
/// (plain test(), real event loop). This screen test is about the UI
/// wiring — dialog validation, the repository being called, the history
/// refreshing — so it gets an instant fake instead.
class _InstantBackupRepository extends BackupRepository {
  final AppDatabase db;
  final calls = <String>[];
  _InstantBackupRepository(this.db) : super(db);

  @override
  Future<LocalBackupRun> backupNow({required String password}) async {
    calls.add(password);
    await db.into(db.localBackupRuns).insert(
          LocalBackupRunsCompanion.insert(id: 'run-${calls.length}', filePath: '/fake/backup.denc', sizeBytes: 1234, status: 'SUCCESS'),
        );
    return (db.select(db.localBackupRuns)..where((r) => r.id.equals('run-${calls.length}'))).getSingle();
  }
}

void main() {
  late AppDatabase db;
  late _InstantBackupRepository backups;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backups = _InstantBackupRepository(db);
  });

  tearDown(() => db.close());

  Widget wrap() => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          backupRepositoryProvider.overrideWithValue(backups),
        ],
        child: const MaterialApp(home: Scaffold(body: BackupsScreen())),
      );

  testWidgets('Backing up prompts for a password and adds a SUCCESS entry to the history', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('No backups yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Back up now'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'correct horse battery staple');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'correct horse battery staple');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Back up'));
    await tester.pumpAndSettle();

    expect(backups.calls, ['correct horse battery staple']);
    expect(find.text('No backups yet'), findsNothing);
    expect(find.text('Verify'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mismatched passwords are rejected before a backup is attempted', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Back up now'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'correct horse battery staple');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'does not match');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Back up'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(backups.calls, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('A too-short password is rejected before a backup is attempted', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Back up now'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'short');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'short');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Back up'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(backups.calls, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
