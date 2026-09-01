import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/connectivity.dart';
import '../../core/session.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/remote/api_client.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final pendingCollectionProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/collections/pending');
  return resp.data as Map<String, dynamic>;
});

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  final _countedController = TextEditingController();
  final _reasonController = TextEditingController();
  final _witnessController = TextEditingController();
  final _notesController = TextEditingController();
  bool _submitting = false;

  /// [expected] is only known when online — computeExpected() aggregates
  /// every device's transactions since the last cutoff, which a single
  /// offline device can't know. Offline, this just queues what the
  /// attendant counted; the server works out the expected/variance once it
  /// syncs, using countedAt (recorded here) as the period end.
  Future<void> _confirm({double? expected}) async {
    final counted = double.tryParse(_countedController.text);
    if (counted == null) return;
    final branchId = ref.read(sessionProvider).user?.branchId ?? '';
    setState(() => _submitting = true);
    try {
      await ref
          .read(offlinePosRepositoryProvider)
          .confirmCollection(
            branchId: branchId,
            countedCash: counted,
            varianceReason: (expected == null || counted != expected) && _reasonController.text.trim().isNotEmpty
                ? _reasonController.text.trim()
                : null,
            witness: _witnessController.text.trim().isEmpty ? null : _witnessController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            countedAt: DateTime.now(),
          );
      ref.invalidate(pendingCollectionProvider);
      _countedController.clear();
      _reasonController.clear();
      _witnessController.clear();
      _notesController.clear();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(expected != null ? 'Collection confirmed' : 'Collection queued — will be confirmed once reconnected')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not confirm: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityProvider);

    if (!isOnline) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cash Collection', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: DnColors.amberSoft, borderRadius: BorderRadius.circular(8)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cloud_off, size: 14, color: DnColors.amber),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Offline — expected cash can't be calculated without a connection. Record what you counted now; the expected amount and variance will be worked out once this syncs.",
                      style: TextStyle(fontSize: 12, color: DnColors.amber),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _confirmCard(expected: null),
          ],
        ),
      );
    }

    final pending = ref.watch(pendingCollectionProvider);
    return pending.when(
      data: (b) {
        final expected = (b['expected'] as num).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cash Collection', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DnCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Cash sales', b['cashSales']),
                    _row('Cash prepaid deposits', b['cashDeposits']),
                    _row('Cash refunds', b['cashRefunds'], negative: true),
                    _row('Cash expenses', b['cashExpenses'], negative: true),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Expected cash', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('M${expected.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _confirmCard(expected: expected),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load collections: $e')),
    );
  }

  Widget _confirmCard({required double? expected}) {
    return DnCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Confirm physical count', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: _countedController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Actual cash counted')),
          const SizedBox(height: 8),
          TextField(controller: _reasonController, decoration: const InputDecoration(labelText: 'Reason (required if not matched)')),
          const SizedBox(height: 8),
          TextField(controller: _witnessController, decoration: const InputDecoration(labelText: 'Witness (optional)')),
          const SizedBox(height: 8),
          TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes (optional)')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitting ? null : () => _confirm(expected: expected),
            child: Text(expected != null ? 'Confirm collection' : 'Queue collection count'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value, {bool negative = false}) {
    final v = (value as num).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: DnColors.muted), overflow: TextOverflow.ellipsis, maxLines: 1)),
          const SizedBox(width: 8),
          Text('${negative ? '-' : ''}M${v.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
