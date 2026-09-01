import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// One AppDatabase instance for the app's lifetime.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
