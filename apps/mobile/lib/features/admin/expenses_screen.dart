import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

extension on Map<String, dynamic> {
  bool get isReversal => this['reversalOfExpenseId'] != null;
  bool get isReversed => this['reversedByExpenseId'] != null;
}

final expensesProvider = FutureProvider.autoDispose<List<dynamic>>(
  (ref) => ref.watch(offlinePosRepositoryProvider).listExpenses(),
);

final expenseCategoriesProvider = FutureProvider.autoDispose<List<dynamic>>(
  (ref) => ref.watch(offlinePosRepositoryProvider).listExpenseCategories(),
);

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpense(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Record expense'),
      ),
      body: expenses.when(
        data: (list) {
          if (list.isEmpty) {
            return const DnEmptyState(icon: Icons.description_outlined, title: 'No expenses recorded yet', hint: 'Use "Record expense" to add one.');
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final e = list[i] as Map<String, dynamic>;
              final category = e['category'] as Map<String, dynamic>;
              final amount = (e['amount'] as num).toInt();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DnCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e['description'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('${category['name']} · ${e['paymentMethod']}', style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        '${amount < 0 ? '-' : ''}M${formatMoney(amount.abs())}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: amount < 0 ? DnColors.red : null),
                      ),
                      if (e.isReversed) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: DnColors.redSoft, borderRadius: BorderRadius.circular(6)),
                          child: const Text('Reversed', style: TextStyle(fontSize: 11, color: DnColors.red, fontWeight: FontWeight.w600)),
                        ),
                      ] else if (!e.isReversal)
                        IconButton(
                          icon: const Icon(Icons.undo, size: 20),
                          tooltip: 'Reverse',
                          onPressed: () => _showReverseDialog(context, ref, e['id'] as String),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load expenses: $e')),
      ),
    );
  }

  void _showAddExpense(BuildContext context, WidgetRef ref) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String method = 'CASH';
    String? categoryId;
    showDialog(
      context: context,
      builder: (ctx) => Consumer(builder: (ctx, dialogRef, _) {
        final categories = dialogRef.watch(expenseCategoriesProvider);
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            scrollable: true,
            title: const Text('Record expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                categories.when(
                  data: (cats) => DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Category'),
                    value: categoryId,
                    items: cats.map((c) => DropdownMenuItem(value: c['id'] as String, child: Text(c['name'] as String))).toList(),
                    onChanged: (v) => setDialogState(() => categoryId = v),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, _) => const Text('Could not load categories'),
                ),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
                DropdownButton<String>(
                  value: method,
                  items: const [
                    DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                    DropdownMenuItem(value: 'CARD', child: Text('Card')),
                    DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Bank transfer')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                  ],
                  onChanged: (v) => setDialogState(() => method = v ?? 'CASH'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final amount = parseMoneyInput(amountController.text) ?? 0;
                  if (categoryId == null || amount <= 0) return;
                  final branchId = ref.read(sessionProvider).user?.branchId ?? '';
                  await ref.read(offlinePosRepositoryProvider).createExpense(
                        categoryId: categoryId!,
                        description: descController.text.trim(),
                        amount: amount,
                        paymentMethod: method,
                        branchId: branchId,
                      );
                  ref.invalidate(expensesProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showReverseDialog(BuildContext context, WidgetRef ref, String expenseId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reverse expense'),
        content: TextField(
          controller: reasonController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Reason'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) return;
              final actorId = ref.read(sessionProvider).user!.id;
              await ref.read(offlinePosRepositoryProvider).reverseExpense(expenseId, reason: reasonController.text.trim(), actorId: actorId);
              ref.invalidate(expensesProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Reverse'),
          ),
        ],
      ),
    );
  }
}
