import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api_client.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final transactionsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final now = DateTime.now();
  final from = now.subtract(const Duration(days: 30));
  final resp = await dio.get('/reports/transactions', queryParameters: {'from': from.toIso8601String(), 'to': now.toIso8601String()});
  return resp.data as List<dynamic>;
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
              final t = list[i] as Map<String, dynamic>;
              final washOrder = t['washOrder'] as Map<String, dynamic>;
              final vehicle = washOrder['vehicle'] as Map<String, dynamic>;
              final components = (t['components'] as List).map((c) => (c['paymentMethod'] as Map)['code']).join(' + ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DnCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vehicle['regNumberDisplay'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(components, style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('M${(t['totalAmount'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (t['voided'] == true) const Text('VOIDED', style: TextStyle(color: DnColors.red, fontSize: 11)),
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
