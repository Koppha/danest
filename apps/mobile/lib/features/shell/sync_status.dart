import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/connectivity.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/local/sync_service.dart';
import '../../design_system/theme.dart';

final pendingSyncCountProvider = StreamProvider<int>((ref) => ref.watch(offlinePosRepositoryProvider).watchPendingCount());

/// Runs a sync sweep: refresh reference data, drain the outbox. Safe to
/// call repeatedly (e.g. on every reconnect) — a no-op when there's
/// nothing pending.
final syncNowProvider = FutureProvider.autoDispose<void>((ref) async {
  final offline = ref.read(offlinePosRepositoryProvider);
  final sync = ref.read(syncServiceProvider);
  await offline.refreshCatalog();
  await sync.pushAll();
});

/// Shown in the app bar: online/offline pill + pending-sync badge, tap to
/// force a sync attempt now.
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    final pending = ref.watch(pendingSyncCountProvider).valueOrNull ?? 0;
    // Below this width, drop the text label and show just the icon + a
    // small count badge — the app bar has too little room for the full
    // phrase alongside the title and logout button on small phones.
    final compact = MediaQuery.of(context).size.width < 380;

    // Auto-sync the moment we come back online.
    ref.listen(connectivityProvider, (previous, next) {
      if (previous == false && next == true) {
        ref.invalidate(syncNowProvider);
      }
    });

    final color = isOnline ? Colors.white70 : DnColors.amber;
    final label = isOnline ? (pending > 0 ? '$pending pending' : 'Online') : '$pending queued offline';

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => ref.invalidate(syncNowProvider),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isOnline ? const Color(0xFF12305C) : DnColors.amber.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isOnline ? Icons.cloud_done_outlined : Icons.cloud_off, size: 14, color: color),
            if (compact && !isOnline && pending > 0) ...[
              const SizedBox(width: 4),
              Text('$pending', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
            ] else if (!compact) ...[
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }
}
