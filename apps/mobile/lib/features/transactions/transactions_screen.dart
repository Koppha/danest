import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../data/local/reports_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final transactionsProvider = FutureProvider.autoDispose<List<TransactionSummary>>((ref) {
  final now = DateTime.now();
  final from = now.subtract(const Duration(days: 30));
  return ref.watch(reportsRepositoryProvider).transactions(from: from, to: now);
});

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(transactionsProvider),
      child: transactions.when(
        data: (list) {
          if (list.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [DnEmptyState(icon: Icons.receipt_long_outlined, title: 'No transactions in the last 30 days', hint: '')],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final t = list[i];
              final methodsLabel = t.methods.map((m) => paymentMethodLabels[m] ?? m).join(' + ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DnCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.vehicleRegNumber ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(methodsLabel, style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('M${formatMoney(t.totalAmount)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (t.voided) const Text('VOIDED', style: TextStyle(color: DnColors.red, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load transactions: $e')),
      ),
    );
  }
}
