import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final failedSyncOpsProvider = StreamProvider.autoDispose<List<PendingSyncOp>>(
  (ref) => ref.watch(offlinePosRepositoryProvider).watchFailedSyncOps(),
);

class SyncIssuesScreen extends ConsumerWidget {
  const SyncIssuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issues = ref.watch(failedSyncOpsProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sync Issues', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            "Offline actions the server rejected once this device reconnected — usually because someone else already spent the balance, or the value was taken elsewhere first. Resolve it manually (e.g. adjust a balance or pick a new username), then dismiss.",
            style: TextStyle(color: DnColors.muted),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: issues.when(
              data: (list) {
                if (list.isEmpty) {
                  return const DnEmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'No sync issues',
                    hint: 'Everything queued from this device has synced cleanly.',
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final op = list[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DnCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline, color: DnColors.amber, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_entityLabel(op.entityType)} ${_opLabel(op.opType)}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    op.lastError?.trim().isNotEmpty == true ? op.lastError! : 'Rejected by the server.',
                                    style: const TextStyle(color: DnColors.muted, fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Queued ${op.createdAt.toLocal()}', style: const TextStyle(color: DnColors.muted, fontSize: 11)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => ref.read(offlinePosRepositoryProvider).dismissSyncIssue(op.rowId),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load sync issues: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

String _entityLabel(String entityType) {
  switch (entityType) {
    case 'customer':
      return 'Customer';
    case 'vehicle':
      return 'Vehicle';
    case 'wash_order':
      return 'Wash order';
    case 'expense':
      return 'Expense';
    case 'prepaid_deposit':
      return 'Prepaid deposit';
    case 'collection':
      return 'Cash collection';
    case 'service':
      return 'Service price';
    case 'extra':
      return 'Extra price';
    case 'user':
      return 'User account';
    default:
      return entityType;
  }
}

String _opLabel(String opType) {
  if (opType.startsWith('transition')) return 'status change';
  switch (opType) {
    case 'create':
      return 'creation';
    case 'update':
      return 'update';
    case 'finish':
      return 'payment';
    default:
      return opType;
  }
}
