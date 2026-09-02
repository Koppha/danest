import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';
import 'database_provider.dart';

const _uuid = Uuid();
final _random = Random.secure();

class InvalidBackupFileException implements Exception {
  @override
  String toString() => "This doesn't look like a De Nest backup file";
}

class WrongBackupPasswordException implements Exception {
  @override
  String toString() => 'Wrong password, or the file is corrupted';
}

Uint8List _randomBytes(int length) => Uint8List.fromList(List.generate(length, (_) => _random.nextInt(256)));

/// Local encrypted backups — no service-account key baked into the app to
/// leak, no OAuth setup required to get a working backup at all. The user
/// picks a password at backup time and must remember it to restore: the
/// key is derived from it (PBKDF2, random per-backup salt), never stored
/// anywhere. A Drive-upload path can sit on top of this later without
/// changing the format, once someone actually has an OAuth client ready.
///
/// Files land in this device's own external app-storage folder rather
/// than a user-picked folder via Android's Storage Access Framework — the
/// SAF file-picker plugins are native Android code needing a Gradle
/// dependency this dev sandbox can't fetch (see the connectivity_plus
/// note in pubspec.yaml for the exact same problem). The file is still
/// reachable from a file manager or over USB; swapping in a real folder
/// picker later is a one-method change ([_backupDirectory]).
class BackupRepository {
  final AppDatabase _db;
  BackupRepository(this._db);

  static const _magic = [0x44, 0x4E, 0x42, 0x01]; // "DNB" + format version 1
  static const _saltLength = 16;
  static final _kdf = Pbkdf2.hmacSha256(iterations: 200000, bits: 256);
  static final _cipher = AesGcm.with256bits();

  Future<Directory> _backupDirectory() async {
    final base = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'backups'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  // The key derivation is deliberately expensive (that's its entire point),
  // and this package's pure-Dart PBKDF2 runs it on whatever isolate calls
  // it — so both directions run on a background isolate, keeping the UI
  // fully responsive during the seconds of CPU work instead of relying on
  // the library's cooperative 1ms-pause-every-2000-iterations yielding.
  Future<Uint8List> _encrypt(Uint8List clearBytes, String password) {
    final salt = _randomBytes(_saltLength);
    return Isolate.run(() async {
      final secretKey = await _kdf.deriveKeyFromPassword(password: password, nonce: salt);
      final secretBox = await _cipher.encrypt(clearBytes, secretKey: secretKey);
      return Uint8List.fromList([..._magic, ...salt, ...secretBox.concatenation()]);
    });
  }

  Future<Uint8List> _decrypt(Uint8List payload, String password) {
    if (payload.length < _magic.length + _saltLength || !_startsWithMagic(payload)) {
      throw InvalidBackupFileException();
    }
    final salt = payload.sublist(_magic.length, _magic.length + _saltLength);
    final rest = payload.sublist(_magic.length + _saltLength);
    return Isolate.run(() async {
      final secretBox = SecretBox.fromConcatenation(rest, nonceLength: _cipher.nonceLength, macLength: _cipher.macAlgorithm.macLength);
      final secretKey = await _kdf.deriveKeyFromPassword(password: password, nonce: salt);
      try {
        return Uint8List.fromList(await _cipher.decrypt(secretBox, secretKey: secretKey));
      } on SecretBoxAuthenticationError {
        // Mapped inside the isolate so what crosses back is our own
        // exception type, not the library's.
        throw WrongBackupPasswordException();
      }
    });
  }

  bool _startsWithMagic(Uint8List payload) {
    for (var i = 0; i < _magic.length; i++) {
      if (payload[i] != _magic[i]) return false;
    }
    return true;
  }

  /// A clean, checkpoint-safe snapshot of the live database — VACUUM INTO
  /// is SQLite's own mechanism for this, so there's no manual WAL-file
  /// juggling to get right (or wrong) here.
  Future<Uint8List> _snapshotDatabase() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = p.join(tempDir.path, 'de_nest_snapshot_${_uuid.v4()}.sqlite');
    await _db.customStatement('VACUUM INTO ?', [tempPath]);
    final tempFile = File(tempPath);
    try {
      return await tempFile.readAsBytes();
    } finally {
      if (await tempFile.exists()) await tempFile.delete();
    }
  }

  Future<LocalBackupRun> backupNow({required String password}) async {
    final id = _uuid.v4();
    try {
      final clearBytes = await _snapshotDatabase();
      final payload = await _encrypt(clearBytes, password);

      final dir = await _backupDirectory();
      final fileName = 'de_nest_backup_${DateTime.now().millisecondsSinceEpoch}.denc';
      final outFile = File(p.join(dir.path, fileName));
      await outFile.writeAsBytes(payload);

      await _db.into(_db.localBackupRuns).insert(
            LocalBackupRunsCompanion.insert(id: id, filePath: outFile.path, sizeBytes: payload.length, status: 'SUCCESS'),
          );
    } catch (e) {
      await _db.into(_db.localBackupRuns).insert(
            LocalBackupRunsCompanion.insert(id: id, filePath: '', sizeBytes: 0, status: 'FAILED', errorMessage: Value(e.toString())),
          );
      rethrow;
    }
    return (await (_db.select(_db.localBackupRuns)..where((r) => r.id.equals(id))).getSingle());
  }

  /// Decrypts a backup file, returning the raw sqlite bytes inside it.
  /// Used both to actually restore, and (with the bytes just thrown away)
  /// to let a manager verify a backup is readable without touching this
  /// device's live database at all.
  Future<Uint8List> decryptBackup(File file, {required String password}) async {
    final payload = await file.readAsBytes();
    return _decrypt(payload, password);
  }

  Future<List<LocalBackupRun>> history() => (_db.select(_db.localBackupRuns)..orderBy([(r) => OrderingTerm.desc(r.createdAt)])).get();
}

final backupRepositoryProvider = Provider<BackupRepository>((ref) => BackupRepository(ref.watch(appDatabaseProvider)));
