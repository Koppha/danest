import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

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
                      Text('M${formatMoney((e['amount'] as num).toInt())}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
}
