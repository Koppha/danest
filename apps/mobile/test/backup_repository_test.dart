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
}
