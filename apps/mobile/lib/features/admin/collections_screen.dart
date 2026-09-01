import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _submitting = false;

  Future<void> _confirm(double expected) async {
    final counted = double.tryParse(_countedController.text);
    if (counted == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(apiClientProvider).post('/collections', data: {
        'countedCash': counted,
        if (counted != expected) 'varianceReason': _reasonController.text.trim(),
      });
      ref.invalidate(pendingCollectionProvider);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection confirmed')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not confirm: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              DnCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Confirm physical count', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(controller: _countedController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Actual cash counted')),
                    const SizedBox(height: 8),
                    TextField(controller: _reasonController, decoration: const InputDecoration(labelText: 'Reason (required if not matched)')),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitting ? null : () => _confirm(expected),
                      child: const Text('Confirm collection'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load collections: $e')),
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
