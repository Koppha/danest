import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/models/models.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';
import '../dashboard/dashboard_screen.dart' show queueProvider;
import 'finish_wash_sheet.dart';

class WashQueueScreen extends ConsumerWidget {
  const WashQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(queueProvider),
      child: queue.when(
        data: (orders) {
          if (orders.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [DnEmptyState(icon: Icons.directions_car, title: 'No cars in the queue', hint: 'Start a new wash to see it here.')],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, i) => _QueueCard(order: orders[i], ref: ref),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load the queue: $e')),
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  final WashOrder order;
  final WidgetRef ref;
  const _QueueCard({required this.order, required this.ref});

  Future<void> _transition(BuildContext context, String toStatus) async {
    try {
      await ref.read(offlinePosRepositoryProvider).transitionWash(order.id, toStatus);
      ref.invalidate(queueProvider);
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DnCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.vehicle?.regNumberDisplay ?? '—',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 1),
                  const SizedBox(height: 2),
                  Text(order.customer?.fullName ?? '',
                      style: const TextStyle(color: DnColors.muted, fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 1),
                  const SizedBox(height: 6),
                  Text('M${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DnStatusPill(status: order.status),
                const SizedBox(height: 10),
                if (order.status == 'WAITING')
                  OutlinedButton(onPressed: () => _transition(context, 'WASHING'), child: const Text('Start washing')),
                if (order.status == 'WASHING')
                  OutlinedButton(onPressed: () => _transition(context, 'READY'), child: const Text('Mark ready')),
                if (order.status == 'READY')
                  ElevatedButton(
                    onPressed: () => showFinishWashSheet(context, ref, order),
                    child: const Text('Finish & send SMS'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
