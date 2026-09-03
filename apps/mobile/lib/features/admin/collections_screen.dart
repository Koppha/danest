import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/local/collections_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final pendingCollectionProvider = FutureProvider.autoDispose<CollectionsExpected>(
  (ref) => ref.watch(collectionsRepositoryProvider).computeExpected(),
);

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

  Future<void> _confirm() async {
    final counted = parseMoneyInput(_countedController.text);
    if (counted == null) return;
    final actorId = ref.read(sessionProvider).user!.id;
    setState(() => _submitting = true);
    try {
      await ref
          .read(collectionsRepositoryProvider)
          .confirm(
            countedCash: counted,
            countedAt: DateTime.now(),
            varianceReason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
            witness: _witnessController.text.trim().isEmpty ? null : _witnessController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            actorId: actorId,
          );
      ref.invalidate(pendingCollectionProvider);
      _countedController.clear();
      _reasonController.clear();
      _witnessController.clear();
      _notesController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Collection confirmed')));
      }
    } on VarianceReasonRequiredException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('A reason is required — the counted cash does not match the expected amount')));
      }
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
      data: (expected) => SingleChildScrollView(
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
                  _row('Cash sales', expected.cashSales),
                  _row('Cash prepaid deposits', expected.cashDeposits),
                  _row('Cash refunds', expected.cashRefunds, negative: true),
                  _row('Cash expenses', expected.cashExpenses, negative: true),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Expected cash', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('M${formatMoney(expected.expected)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            if (_hasNonCash(expected)) ...[
              const SizedBox(height: 16),
              DnCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Non-cash payments (for reference)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    if (expected.cardTotal != 0) _row('Card', expected.cardTotal),
                    if (expected.mobileMoneyTotal != 0) _row('Mobile money', expected.mobileMoneyTotal),
                    if (expected.bankTransferTotal != 0) _row('Bank transfer', expected.bankTransferTotal),
                    if (expected.walletTotal != 0) _row('Wallet', expected.walletTotal),
                    if (expected.packageUsageTotal != 0) _row('Free Wash', expected.packageUsageTotal),
                    if (expected.loyaltyRedemptionsTotal != 0) _row('Loyalty free wash', expected.loyaltyRedemptionsTotal),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            _confirmCard(),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load collections: $e')),
    );
  }

  bool _hasNonCash(CollectionsExpected e) =>
      e.cardTotal != 0 ||
      e.mobileMoneyTotal != 0 ||
      e.bankTransferTotal != 0 ||
      e.walletTotal != 0 ||
      e.packageUsageTotal != 0 ||
      e.loyaltyRedemptionsTotal != 0;

  Widget _confirmCard() {
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
          ElevatedButton(onPressed: _submitting ? null : _confirm, child: const Text('Confirm collection')),
        ],
      ),
    );
  }

  Widget _row(String label, int cents, {bool negative = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: DnColors.muted), overflow: TextOverflow.ellipsis, maxLines: 1)),
          const SizedBox(width: 8),
          Text('${negative ? '-' : ''}M${formatMoney(cents)}'),
        ],
      ),
    );
  }
}
