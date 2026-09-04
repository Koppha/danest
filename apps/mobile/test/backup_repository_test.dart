import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/backup_repository.dart';

class _FakePathProvider extends PathProviderPlatform with MockPlatformInterfaceMixin {
  final String tempDirPath;
  _FakePathProvider(this.tempDirPath);

  @override
  Future<String?> getTemporaryPath() async => tempDirPath;
  @override
  Future<String?> getApplicationDocumentsPath() async => tempDirPath;
  @override
  Future<String?> getExternalStoragePath() async => tempDirPath;
}

void main() {
  late Directory tempDir;
  late AppDatabase db;
  late BackupRepository backups;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('de_nest_backup_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir.path);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backups = BackupRepository(db);
    await db.into(db.localWashServices).insert(
          LocalWashServicesCompanion.insert(id: 'svc-1', name: 'Standard Wash', tier: 'standard', basePrice: 6000, durationMinutes: 15),
        );
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  test('backupNow writes an encrypted file and records a SUCCESS run', () async {
    final run = await backups.backupNow(password: 'correct horse battery staple');

    expect(run.status, 'SUCCESS');
    expect(run.sizeBytes, greaterThan(0));
    expect(File(run.filePath).existsSync(), isTrue);

    final history = await backups.history();
    expect(history, hasLength(1));
    expect(history.single.id, run.id);
  });

  test('the exported file is not readable as plain sqlite — it is actually encrypted', () async {
    final run = await backups.backupNow(password: 'correct horse battery staple');
    final rawBytes = await File(run.filePath).readAsBytes();
    // A real (unencrypted) sqlite file starts with this exact 16-byte header.
    const sqliteHeader = 'SQLite format 3\x00';
    expect(String.fromCharCodes(rawBytes.take(sqliteHeader.length)), isNot(sqliteHeader));
  });

  test('decrypting with the correct password recovers a real, queryable sqlite database', () async {
    final run = await backups.backupNow(password: 'correct horse battery staple');

    final clearBytes = await backups.decryptBackup(File(run.filePath), password: 'correct horse battery staple');
    const sqliteHeader = 'SQLite format 3\x00';
    expect(String.fromCharCodes(clearBytes.take(sqliteHeader.length)), sqliteHeader);

    final restoredPath = p.join(tempDir.path, 'restored.sqlite');
    await File(restoredPath).writeAsBytes(clearBytes);
    final restoredDb = AppDatabase.forTesting(NativeDatabase(File(restoredPath)));
    final services = await restoredDb.select(restoredDb.localWashServices).get();
    expect(services, hasLength(1));
    expect(services.single.name, 'Standard Wash');
    await restoredDb.close();
  });

  test('decrypting with the wrong password fails instead of silently returning garbage', () async {
    final run = await backups.backupNow(password: 'correct horse battery staple');

    await expectLater(
      backups.decryptBackup(File(run.filePath), password: 'wrong password'),
      throwsA(isA<WrongBackupPasswordException>()),
    );
  });

  test('decrypting a file that is not a De Nest backup at all is rejected cleanly', () async {
    final notABackup = File(p.join(tempDir.path, 'not_a_backup.txt'));
    await notABackup.writeAsBytes([1, 2, 3, 4, 5]);

    await expectLater(
      backups.decryptBackup(notABackup, password: 'anything'),
      throwsA(isA<InvalidBackupFileException>()),
    );
  });

  group('availableBackupFiles', () {
    test('finds a .denc file sitting in the backups folder even with no matching history row', () async {
      // Simulates a backup made on a different device (or before a
      // reinstall wiped this one's LocalBackupRuns) and copied in by hand
      // — availableBackupFiles must not depend on the history table.
      final backupsDir = Directory(p.join(tempDir.path, 'backups'));
      await backupsDir.create(recursive: true);
      await File(p.join(backupsDir.path, 'from_another_device.denc')).writeAsBytes([1, 2, 3]);

      final files = await backups.availableBackupFiles();
      expect(files.map((f) => p.basename(f.path)), contains('from_another_device.denc'));

      final history = await backups.history();
      expect(history, isEmpty); // confirms it really isn't in the history table
    });

    test('ignores non-.denc files in the same folder', () async {
      final backupsDir = Directory(p.join(tempDir.path, 'backups'));
      await backupsDir.create(recursive: true);
      await File(p.join(backupsDir.path, 'notes.txt')).writeAsBytes([1]);

      final files = await backups.availableBackupFiles();
      expect(files, isEmpty);
    });
  });

  group('restoreFrom', () {
    test('overwrites the live database file with the decrypted backup contents', () async {
      final run = await backups.backupNow(password: 'correct horse battery staple');

      final liveDbFile = await localDatabaseFile();
      await liveDbFile.parent.create(recursive: true);
      await liveDbFile.writeAsBytes([9, 9, 9]); // stand-in for "whatever is live right now"

      await backups.restoreFrom(File(run.filePath), password: 'correct horse battery staple');

      final restoredBytes = await liveDbFile.readAsBytes();
      const sqliteHeader = 'SQLite format 3\x00';
      expect(String.fromCharCodes(restoredBytes.take(sqliteHeader.length)), sqliteHeader);

      final restoredDb = AppDatabase.forTesting(NativeDatabase(liveDbFile));
      final services = await restoredDb.select(restoredDb.localWashServices).get();
      expect(services.single.name, 'Standard Wash');
      await restoredDb.close();
    });

    test('closes the live connection so nothing can write through it after the file has been swapped', () async {
      final run = await backups.backupNow(password: 'correct horse battery staple');

      await backups.restoreFrom(File(run.filePath), password: 'correct horse battery staple');

      await expectLater(db.select(db.localWashServices).get(), throwsA(anything));
    });

    test('snapshots the current database as a safety net, encrypted with the same password, before overwriting it', () async {
      final run = await backups.backupNow(password: 'correct horse battery staple');

      final liveDbFile = await localDatabaseFile();
      await liveDbFile.parent.create(recursive: true);
      const sqliteHeader = 'SQLite format 3\x00';
      await liveDbFile.writeAsBytes(sqliteHeader.codeUnits); // stands in for "the current live file"

      final beforeCount = (await backups.availableBackupFiles()).length;
      await backups.restoreFrom(File(run.filePath), password: 'correct horse battery staple');
      final filesAfter = await backups.availableBackupFiles();

      expect(filesAfter.length, beforeCount + 1);
      final safetyFile = filesAfter.firstWhere((f) => p.basename(f.path).contains('pre_restore'));
      final decryptedSafety = await backups.decryptBackup(safetyFile, password: 'correct horse battery staple');
      expect(String.fromCharCodes(decryptedSafety.take(sqliteHeader.length)), sqliteHeader);
    });

    test('a wrong password is rejected before anything is overwritten', () async {
      final run = await backups.backupNow(password: 'correct horse battery staple');

      final liveDbFile = await localDatabaseFile();
      await liveDbFile.parent.create(recursive: true);
      await liveDbFile.writeAsBytes([1, 2, 3]);

      await expectLater(
        backups.restoreFrom(File(run.filePath), password: 'wrong password'),
        throwsA(isA<WrongBackupPasswordException>()),
      );

      // Nothing touched — still the pre-restore placeholder bytes, and the
      // live connection is still open.
      expect(await liveDbFile.readAsBytes(), [1, 2, 3]);
      await db.select(db.localWashServices).get(); // must not throw
    });
  });
}
