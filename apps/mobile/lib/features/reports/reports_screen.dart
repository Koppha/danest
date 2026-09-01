import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final reportsSummaryProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, 1);
  return ref.watch(posRepositoryProvider).dashboardSummary(from: from, to: now.add(const Duration(days: 1)));
});

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(reportsSummaryProvider);
    return summary.when(
      data: (s) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This month', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                DnKpi(icon: Icons.payments, label: 'Total sales', value: 'M${(s['totalSales'] as num).toStringAsFixed(0)}', tint: DnColors.greenSoft, iconColor: DnColors.green),
                DnKpi(icon: Icons.local_car_wash, label: 'Completed washes', value: '${s['totalCompletedWashes']}', tint: DnColors.blueSoft, iconColor: DnColors.blue),
                DnKpi(icon: Icons.card_giftcard, label: 'Free washes', value: '${s['totalFreeWashes']}', tint: DnColors.purpleSoft, iconColor: const Color(0xFF7C4DEB)),
                DnKpi(icon: Icons.account_balance_wallet, label: 'Prepaid deposits', value: 'M${(s['totalPrepaidDeposits'] as num).toStringAsFixed(0)}', tint: DnColors.amberSoft, iconColor: DnColors.amber),
              ],
            ),
            const SizedBox(height: 20),
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sales by payment method', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...((s['salesByMethod'] as Map).entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(e.key as String), Text('M${(e.value as num).toStringAsFixed(2)}')],
                        ),
                      ))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Net operating cash', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('M${(s['netOperatingCash'] as num).toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DnColors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load reports: $e')),
    );
  }
}
