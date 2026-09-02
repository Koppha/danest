import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../data/local/reports_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final reportsSummaryProvider = FutureProvider.autoDispose<ReportsSummary>((ref) {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, 1);
  return ref.watch(reportsRepositoryProvider).summary(from: from, to: now);
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
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth > 700 ? 3 : (constraints.maxWidth > 420 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
                children: [
                  DnKpi(icon: Icons.payments, label: 'Total sales', value: 'M${formatMoney(s.totalSales)}', tint: DnColors.greenSoft, iconColor: DnColors.green),
                  DnKpi(icon: Icons.local_car_wash, label: 'Completed washes', value: '${s.totalCompletedWashes}', tint: DnColors.blueSoft, iconColor: DnColors.blue),
                  DnKpi(icon: Icons.card_giftcard, label: 'Free washes', value: '${s.totalFreeWashes}', tint: DnColors.purpleSoft, iconColor: const Color(0xFF7C4DEB)),
                  DnKpi(
                    icon: Icons.account_balance_wallet,
                    label: 'Prepaid deposits',
                    value: 'M${formatMoney(s.totalPrepaidDeposits)}',
                    tint: DnColors.amberSoft,
                    iconColor: DnColors.amber,
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sales by payment method', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (s.salesByMethod.isEmpty)
                    const Text('No sales yet this month', style: TextStyle(color: DnColors.muted))
                  else
                    ...s.salesByMethod.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(e.key, overflow: TextOverflow.ellipsis, maxLines: 1)),
                            const SizedBox(width: 8),
                            Text('M${formatMoney(e.value)}'),
                          ],
                        ),
                      ),
                    ),
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
                  Text('M${formatMoney(s.netOperatingCash)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DnColors.green)),
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
