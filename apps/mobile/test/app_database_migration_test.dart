import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'package:de_nest/data/local/app_database.dart';

void main() {
  late Directory tempDir;
  late File dbFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('de_nest_migration_test');
    dbFile = File(p.join(tempDir.path, 'test.sqlite'));
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  test('opening a real fresh database succeeds and starts at the current schema version', () async {
    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    await db.select(db.localWashOrders).get(); // forces the connection open
    await db.close();

    final raw = sqlite3.sqlite3.open(dbFile.path);
    final version = raw.select('PRAGMA user_version').first['user_version'] as int;
    raw.close();
    expect(version, 12);
  });

  // Reproduces a real crash: if the app is killed between onCreate finishing
  // (which creates every table using today's Dart definitions, columns and
  // all) and Drift persisting the bumped user_version, the next launch
  // replays every onUpgrade step from scratch against a database that
  // already has these columns. Before the _addColumnIfMissing fix, this
  // permanently bricked the database with "duplicate column name" on every
  // subsequent launch — there was no way to recover short of clearing app
  // data.
  test('opening a database whose tables exist but whose stored version is stale does not crash', () async {
    final fresh = AppDatabase.forTesting(NativeDatabase(dbFile));
    await fresh.select(fresh.localWashOrders).get();
    await fresh.close();

    // Simulate the crash: tables are fully created (current schema), but
    // user_version was never bumped past an early release.
    final raw = sqlite3.sqlite3.open(dbFile.path);
    raw.execute('PRAGMA user_version = 1');
    raw.close();

    final reopened = AppDatabase.forTesting(NativeDatabase(dbFile));
    // Must not throw — this is exactly what "duplicate column name: voided"
    // used to do here.
    await reopened.select(reopened.localWashOrders).get();
    await reopened.close();

    final rawAfter = sqlite3.sqlite3.open(dbFile.path);
    final versionAfter = rawAfter.select('PRAGMA user_version').first['user_version'] as int;
    rawAfter.close();
    expect(versionAfter, 12); // successfully caught up despite the stale start
  });
}
