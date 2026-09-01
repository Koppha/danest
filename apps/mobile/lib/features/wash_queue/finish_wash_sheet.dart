import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/connectivity.dart';
import '../../data/models/models.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../design_system/theme.dart';
import '../dashboard/dashboard_screen.dart' show queueProvider;

// UI-level payment choices. Ecocash and M-Pesa are both recorded on the
// backend as the generic MOBILE_MONEY method (see _backendMethod below) —
// the reference number captures which provider was actually used.
const _methods = [
  ('CASH', 'Cash', Icons.payments_outlined),
  ('ECOCASH', 'Ecocash', Icons.smartphone),
  ('MPESA', 'M-Pesa', Icons.smartphone),
  ('CARD', 'Card', Icons.credit_card),
  ('LOYALTY_FREE_WASH', 'Free wash', Icons.card_giftcard),
];

String _backendMethod(String uiMethod) => switch (uiMethod) {
  'ECOCASH' || 'MPESA' => 'MOBILE_MONEY',
  _ => uiMethod,
};

Future<void> showFinishWashSheet(BuildContext context, WidgetRef ref, WashOrder order) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FinishWashSheet(order: order, ref: ref),
  );
}

class _FinishWashSheet extends StatefulWidget {
  final WashOrder order;
  final WidgetRef ref;
  const _FinishWashSheet({required this.order, required this.ref});

  @override
  State<_FinishWashSheet> createState() => _FinishWashSheetState();
}

class _FinishWashSheetState extends State<_FinishWashSheet> {
  String _method = 'CASH';
  final _referenceController = TextEditingController();
  bool _submitting = false;
  String? _error;
  LoyaltySummary? _loyalty;

  @override
  void initState() {
    super.initState();
    final vehicleId = widget.order.vehicle?.id;
    if (vehicleId != null) {
      widget.ref.read(offlinePosRepositoryProvider).loyaltySummary(vehicleId).then((summary) {
        if (mounted) setState(() => _loyalty = summary);
      });
    }
  }

  bool get _referenceRequired => _method == 'ECOCASH' || _method == 'MPESA';

  Future<void> _submit() async {
    if (_referenceRequired && _referenceController.text.trim().isEmpty) {
      setState(() => _error = 'A reference is required for this payment method');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.ref.read(offlinePosRepositoryProvider).finishWash(widget.order.id, [
        {
          'method': _backendMethod(_method),
          'amount': widget.order.totalAmount,
          if (_referenceController.text.trim().isNotEmpty) 'externalReference': _referenceController.text.trim(),
        },
      ]);
      widget.ref.invalidate(queueProvider);
      if (mounted) Navigator.of(context).pop();
    } on OfflinePaymentNotAllowedException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = 'Could not complete the payment: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.ref.watch(connectivityProvider);
    final hasFreeWash = _loyalty?.hasAvailableReward ?? false;
    final eligibleMethods = _methods.where((m) => m.$1 != 'LOYALTY_FREE_WASH' || hasFreeWash);
    final availableMethods = isOnline
        ? eligibleMethods.toList()
        : eligibleMethods.where((m) => offlineSafePaymentMethods.contains(_backendMethod(m.$1))).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Finish wash — ${widget.order.vehicle?.regNumberDisplay ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text('Total due: M${widget.order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: DnColors.muted)),
              if (!isOnline) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: DnColors.amberSoft, borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.cloud_off, size: 14, color: DnColors.amber),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text('Offline — free washes are unavailable until reconnected', style: TextStyle(fontSize: 12, color: DnColors.amber)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableMethods.map((m) {
                  final selected = _method == m.$1;
                  return ChoiceChip(
                    label: Text(m.$2),
                    avatar: Icon(m.$3, size: 16, color: selected ? Colors.white : DnColors.muted),
                    selected: selected,
                    onSelected: (_) => setState(() => _method = m.$1),
                    selectedColor: DnColors.blue,
                    labelStyle: TextStyle(color: selected ? Colors.white : DnColors.ink),
                  );
                }).toList(),
              ),
              if (_referenceRequired) ...[
                const SizedBox(height: 12),
                TextField(controller: _referenceController, decoration: const InputDecoration(labelText: 'Reference number')),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: DnColors.red, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('FINISH WASH'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
