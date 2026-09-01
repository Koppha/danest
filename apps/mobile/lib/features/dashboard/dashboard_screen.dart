import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/remote/pos_repository.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/models/models.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';
import '../shell/sync_status.dart';

final queueProvider = FutureProvider.autoDispose<List<WashOrder>>((ref) => ref.watch(offlinePosRepositoryProvider).queue());

final dashboardSummaryProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  return ref.watch(posRepositoryProvider).dashboardSummary(from: startOfDay, to: now.add(const Duration(days: 1)));
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncNowProvider); // best-effort catalog refresh + outbox drain on first dashboard load
    final queue = ref.watch(queueProvider);
    final summary = ref.watch(dashboardSummaryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(queueProvider);
        ref.invalidate(dashboardSummaryProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => context.go('/new-wash'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New wash'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth > 700 ? 3 : (constraints.maxWidth > 420 ? 2 : 1);
              final carsOnSite = queue.valueOrNull?.length ?? 0;
              final takenToday = summary.valueOrNull?['totalSales'];
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
                children: [
                  DnKpi(icon: Icons.directions_car, label: 'Cars on site', value: '$carsOnSite', tint: DnColors.blueSoft, iconColor: DnColors.blue),
                  DnKpi(
                    icon: Icons.payments_outlined,
                    label: 'Taken today',
                    value: takenToday != null ? 'M${(takenToday as num).toStringAsFixed(0)}' : '—',
                    tint: DnColors.greenSoft,
                    iconColor: DnColors.green,
                  ),
                  DnKpi(
                    icon: Icons.card_giftcard,
                    label: 'Free washes today',
                    value: '${summary.valueOrNull?['totalFreeWashes'] ?? '—'}',
                    tint: DnColors.purpleSoft,
                    iconColor: const Color(0xFF7C4DEB),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            const Text('On the floor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DnCard(
              padding: EdgeInsets.zero,
              child: queue.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return const DnEmptyState(icon: Icons.directions_car, title: 'The bay is clear', hint: 'Start a wash to put a car in the queue.');
                  }
                  return Column(
                    children: orders
                        .map((w) => ListTile(
                              leading: const Icon(Icons.directions_car, color: DnColors.muted),
                              title: Text(w.vehicle?.regNumberDisplay ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text('M${w.totalAmount.toStringAsFixed(2)}'),
                              trailing: DnStatusPill(status: w.status),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Padding(padding: const EdgeInsets.all(20), child: Text('Could not load the queue: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
