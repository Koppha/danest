import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../data/remote/pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

class PrepaidScreen extends ConsumerStatefulWidget {
  const PrepaidScreen({super.key});

  @override
  ConsumerState<PrepaidScreen> createState() => _PrepaidScreenState();
}

class _PrepaidScreenState extends ConsumerState<PrepaidScreen> {
  Customer? _selected;
  Map<String, dynamic>? _overview;
  final _searchController = TextEditingController();
  List<Customer> _results = [];

  Future<void> _search() async {
    final results = await ref.read(posRepositoryProvider).searchCustomers(_searchController.text.trim());
    setState(() => _results = results);
  }

  Future<void> _select(Customer c) async {
    final overview = await ref.read(posRepositoryProvider).prepaidOverview(c.id);
    setState(() {
      _selected = c;
      _overview = overview;
    });
  }

  Future<void> _deposit() async {
    if (_selected == null) return;
    final amountController = TextEditingController();
    String method = 'CASH';
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text('Top up ${_selected!.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: method,
                items: const [
                  DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                  DropdownMenuItem(value: 'CARD', child: Text('Card')),
                  DropdownMenuItem(value: 'MOBILE_MONEY', child: Text('Mobile money')),
                  DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Bank transfer')),
                ],
                onChanged: (v) => setDialogState(() => method = v ?? 'CASH'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount <= 0) return;
                await ref.read(posRepositoryProvider).depositToWallet(customerId: _selected!.id, amount: amount, method: method);
                if (mounted) {
                  Navigator.pop(ctx);
                  _select(_selected!);
                }
              },
              child: const Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(hintText: 'Search customer', prefixIcon: Icon(Icons.search)),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _search, child: const Text('Search')),
            ],
          ),
          const SizedBox(height: 12),
          ..._results.map((c) => ListTile(
                title: Text(c.fullName),
                subtitle: Text(c.phone),
                onTap: () => _select(c),
                selected: _selected?.id == c.id,
              )),
          if (_selected != null && _overview != null) ...[
            const SizedBox(height: 12),
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selected!.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Prepaid balance', style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                  Text('M${(_overview!['balance'] as num).toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: DnColors.green)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(onPressed: _deposit, icon: const Icon(Icons.add, size: 16), label: const Text('Top up wallet')),
                  if ((_overview!['packages'] as List).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Active packages', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...(_overview!['packages'] as List).map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('${p['package']['name']} — ${p['remainingCount']} washes left', style: const TextStyle(fontSize: 13)),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
