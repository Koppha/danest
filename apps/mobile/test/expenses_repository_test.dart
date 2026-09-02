import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:de_nest/core/connectivity.dart';
import 'package:de_nest/data/local/app_database.dart';
import 'package:de_nest/data/local/database_provider.dart';
import 'package:de_nest/data/local/offline_pos_repository.dart';

class _AlwaysOffline extends ConnectivityNotifier {
  @override
  bool build() => false;
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late OfflinePosRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(overrides: [
      connectivityProvider.overrideWith(_AlwaysOffline.new),
      appDatabaseProvider.overrideWithValue(db),
    ]);
    repo = container.read(offlinePosRepositoryProvider);
    await db.into(db.localExpenseCategories).insert(LocalExpenseCategoriesCompanion.insert(id: 'cat-1', name: 'Supplies'));
  });

  tearDown(() async {
    await db.close();
    container.dispose();
  });

  test('reverseExpense inserts a negative-amount compensating row and links the two atomically', () async {
    final created = await repo.createExpense(categoryId: 'cat-1', description: 'Detergent', amount: 1500, paymentMethod: 'CASH', branchId: 'main');
    final expenseId = created['id'] as String;

    await repo.reverseExpense(expenseId, reason: 'Wrong category', actorId: 'u1');

    final rows = await (db.select(db.localExpenses)..orderBy([(e) => OrderingTerm.asc(e.createdAt)])).get();
    expect(rows, hasLength(2));
    final original = rows.firstWhere((r) => r.id == expenseId);
    final reversal = rows.firstWhere((r) => r.id != expenseId);
    expect(original.reversedByExpenseId, reversal.id);
    expect(reversal.reversalOfExpenseId, expenseId);
    expect(reversal.amount, -1500);
    expect(reversal.description, contains('Wrong category'));
  });

  test('reverseExpense records an EXPENSE_REVERSED audit entry', () async {
    final created = await repo.createExpense(categoryId: 'cat-1', description: 'Detergent', amount: 1500, paymentMethod: 'CASH', branchId: 'main');
    final expenseId = created['id'] as String;

    await repo.reverseExpense(expenseId, reason: 'Wrong category', actorId: 'u1');

    final entries = await (db.select(db.localAuditLog)..where((e) => e.entityId.equals(expenseId))).get();
    expect(entries, hasLength(1));
    expect(entries.single.action, 'EXPENSE_REVERSED');
    expect(entries.single.actorId, 'u1');
  });

  test('reversing an already-reversed expense throws instead of double-compensating', () async {
    final created = await repo.createExpense(categoryId: 'cat-1', description: 'Detergent', amount: 1500, paymentMethod: 'CASH', branchId: 'main');
    final expenseId = created['id'] as String;
    await repo.reverseExpense(expenseId, reason: 'First reversal', actorId: 'u1');

    await expectLater(repo.reverseExpense(expenseId, reason: 'Second attempt', actorId: 'u1'), throwsA(isA<ExpenseAlreadyReversedException>()));
  });

  test('reversing a non-existent expense throws', () async {
    await expectLater(repo.reverseExpense('does-not-exist', reason: 'n/a', actorId: 'u1'), throwsA(isA<ExpenseNotFoundException>()));
  });
}
