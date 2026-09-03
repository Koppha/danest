import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../data/local/loyalty_repository.dart';
import '../../data/local/reports_repository.dart';
import '../../data/local/settings_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final reportsSummaryProvider = FutureProvider.autoDispose<ReportsSummary>((ref) {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, 1);
  return ref.watch(reportsRepositoryProvider).summary(from: from, to: now);
});

final loyaltyReportProvider = FutureProvider.autoDispose<List<LoyaltyReportRow>>((ref) async {
  final scope = await ref.watch(loyaltyScopeProvider.future);
  return ref.watch(loyaltyRepositoryProvider).report(scope: scope);
});

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Material(
            color: DnColors.bg,
            child: TabBar(
              labelColor: DnColors.blue,
              unselectedLabelColor: DnColors.muted,
              indicatorColor: DnColors.blue,
              tabs: [Tab(text: 'Summary'), Tab(text: 'Loyalty')],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [_SummaryTab(), _LoyaltyTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTab extends ConsumerWidget {
  const _SummaryTab();

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

class _LoyaltyTab extends ConsumerWidget {
  const _LoyaltyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(loyaltyScopeProvider);
    final report = ref.watch(loyaltyReportProvider);
    return report.when(
      data: (rows) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                const Text('Washes before a free wash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  scope.value == LoyaltyScope.customer ? 'Per customer' : 'Per vehicle',
                  style: const TextStyle(color: DnColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: rows.isEmpty
                ? const DnEmptyState(icon: Icons.card_giftcard, title: 'No loyalty history yet', hint: 'Progress appears here once washes are completed.')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final r = rows[i];
                      return DnCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  if (r.vehicleRegNumber != null)
                                    Text(r.vehicleRegNumber!, style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (r.hasAvailableReward)
                              const _Badge(text: 'Free wash ready', color: DnColors.green)
                            else
                              Text(
                                '${r.qualifyingCount} of $qualifyingWashThreshold',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load the loyalty report: $e')),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
