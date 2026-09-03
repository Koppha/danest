import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/models/models.dart';
import '../../data/local/loyalty_repository.dart';
import '../../data/local/prepaid_repository.dart';
import '../../data/local/settings_repository.dart';
import '../../data/local/wash_orders_repository.dart';
import '../../design_system/theme.dart';
import '../dashboard/dashboard_screen.dart' show queueProvider;

// UI-level payment choices. Ecocash and M-Pesa are both recorded as the
// generic MOBILE_MONEY method (see _backendMethod below) — the reference
// number captures which provider was actually used.
const _methods = [
  ('CASH', 'Cash', Icons.payments_outlined),
  ('ECOCASH', 'Ecocash', Icons.smartphone),
  ('MPESA', 'M-Pesa', Icons.smartphone),
  ('CARD', 'Card', Icons.credit_card),
  ('BANK_TRANSFER', 'Bank transfer', Icons.account_balance),
  ('WALLET', 'Wallet', Icons.account_balance_wallet_outlined),
  ('PACKAGE', 'Free Wash', Icons.card_membership_outlined),
  ('LOYALTY_FREE_WASH', 'Loyalty reward', Icons.card_giftcard),
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
  int? _walletBalance;

  @override
  void initState() {
    super.initState();
    final vehicleId = widget.order.vehicle?.id;
    final customerId = widget.order.customer?.id;
    if (vehicleId != null && customerId != null) {
      widget.ref.read(loyaltyScopeProvider.future).then((scope) {
        return widget.ref.read(loyaltyRepositoryProvider).summaryForVehicle(vehicleId: vehicleId, customerId: customerId, scope: scope);
      }).then((summary) {
        if (mounted) setState(() => _loyalty = summary);
      });
    }
    if (customerId != null) {
      widget.ref.read(prepaidRepositoryProvider).walletBalance(customerId).then((balance) {
        if (mounted) setState(() => _walletBalance = balance);
      });
    }
  }

  bool get _referenceRequired => _method == 'ECOCASH' || _method == 'MPESA' || _method == 'BANK_TRANSFER';

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
      final actorId = widget.ref.read(sessionProvider).user!.id;
      await widget.ref.read(washOrdersRepositoryProvider).finishWash(
        widget.order.id,
        [
          {
            'method': _backendMethod(_method),
            'amount': widget.order.totalAmount,
            if (_referenceController.text.trim().isNotEmpty) 'externalReference': _referenceController.text.trim(),
          },
        ],
        actorId: actorId,
      );
      widget.ref.invalidate(queueProvider);
      if (mounted) Navigator.of(context).pop();
    } on InsufficientWalletBalanceException catch (e) {
      setState(() => _error = 'Insufficient prepaid balance: available M${formatMoney(e.available)}, requested M${formatMoney(e.requested)}');
    } catch (e) {
      setState(() => _error = 'Could not complete the payment: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFreeWash = _loyalty?.hasAvailableReward ?? false;
    // >= (not >), deliberately: a wallet balance that exactly covers the
    // total is still a perfectly valid way to pay for it.
    final hasSufficientWallet = (_walletBalance ?? 0) >= widget.order.totalAmount;
    final availableMethods = _methods.where((m) {
      if (m.$1 == 'LOYALTY_FREE_WASH') return hasFreeWash;
      if (m.$1 == 'WALLET') return hasSufficientWallet;
      return true;
    }).toList();

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
              Text('Total due: M${formatMoney(widget.order.totalAmount)}', style: const TextStyle(color: DnColors.muted)),
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
