import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/models/models.dart';
import '../../data/local/loyalty_repository.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/local/settings_repository.dart';
import '../../data/local/wash_orders_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final _servicesProvider = FutureProvider.autoDispose((ref) => ref.watch(offlinePosRepositoryProvider).listServices());
final _extrasProvider = FutureProvider.autoDispose((ref) => ref.watch(offlinePosRepositoryProvider).listExtras());

class NewWashScreen extends ConsumerStatefulWidget {
  const NewWashScreen({super.key});

  @override
  ConsumerState<NewWashScreen> createState() => _NewWashScreenState();
}

class _NewWashScreenState extends ConsumerState<NewWashScreen> {
  final _searchController = TextEditingController();
  List<Customer> _results = [];
  Customer? _selectedCustomer;
  Vehicle? _selectedVehicle;
  WashService? _selectedService;
  final Set<String> _selectedExtraIds = {};
  bool _searching = false;
  LoyaltySummary? _loyalty;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onQueryChanged);
    super.dispose();
  }

  // Invalidating the current pick belongs here — the moment the user
  // actually types something new — not inside _search()'s async result
  // handler. That handler can still run *after* a debounced timer armed
  // by an earlier keystroke finally fires, which used to null out
  // whatever the user had since picked, even though nothing about their
  // selection was actually wrong.
  void _onQueryChanged() {
    _debounce?.cancel();
    setState(() {
      _selectedCustomer = null;
      _selectedVehicle = null;
    });
    if (_searchController.text.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), _search);
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    setState(() => _searching = true);
    try {
      final results = await ref.read(offlinePosRepositoryProvider).searchCustomers(query);
      if (!mounted || query != _searchController.text.trim()) return;
      setState(() => _results = results);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _selectVehicle(Vehicle v) async {
    setState(() => _selectedVehicle = v);
    final scope = await ref.read(loyaltyScopeProvider.future);
    final summary = await ref.read(loyaltyRepositoryProvider).summaryForVehicle(vehicleId: v.id, customerId: v.customerId, scope: scope);
    if (mounted) setState(() => _loyalty = summary);
  }

  int _total(List<WashExtra> extras) {
    var total = _selectedService?.basePrice ?? 0;
    for (final e in extras) {
      if (_selectedExtraIds.contains(e.id)) total += e.price;
    }
    return total;
  }

  Future<void> _startWash() async {
    if (_selectedVehicle == null || _selectedService == null || _selectedCustomer == null) return;
    final items = [
      {'itemType': 'SERVICE', 'serviceId': _selectedService!.id},
      ..._selectedExtraIds.map((id) => {'itemType': 'EXTRA', 'extraId': id}),
    ];
    try {
      final actorId = ref.read(sessionProvider).user!.id;
      await ref.read(washOrdersRepositoryProvider).startWash(
            vehicleId: _selectedVehicle!.id,
            customerId: _selectedCustomer!.id,
            items: items,
            actorId: actorId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wash started and added to the queue')));
        context.go('/queue');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not start the wash: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(_servicesProvider);
    final extras = ref.watch(_extrasProvider);
    final branchId = ref.watch(sessionProvider).user?.branchId ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth > 900;
        final left = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Find Customer / Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(hintText: 'Phone number or registration', prefixIcon: Icon(Icons.search)),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(onPressed: _searching ? null : _search, child: const Text('Search')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Text(
                        _results.isEmpty && !_searching && _searchController.text.isNotEmpty
                            ? 'No customer matches that.'
                            : 'Can\'t find who you\'re looking for?',
                        style: const TextStyle(color: DnColors.muted),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showAddCustomerDialog(branchId),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add customer'),
                      ),
                    ],
                  ),
                  ..._results.map((c) => _CustomerTile(
                        customer: c,
                        selected: _selectedCustomer?.id == c.id,
                        onTap: () => setState(() {
                          _selectedCustomer = c;
                          _selectedVehicle = null;
                        }),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DnCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Select Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (_selectedCustomer == null)
                    const Text('Find a customer first and their cars will appear here.', style: TextStyle(color: DnColors.muted))
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ..._selectedCustomer!.vehicles.map((v) => _VehicleChip(
                              vehicle: v,
                              selected: _selectedVehicle?.id == v.id,
                              onTap: () => _selectVehicle(v),
                            )),
                        OutlinedButton.icon(
                          onPressed: () => _showAddVehicleDialog(),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add vehicle'),
                        ),
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
                  const Text('3. Choose Wash Service', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  services.when(
                    data: (list) => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: list.map((s) {
                        final selected = _selectedService?.id == s.id;
                        return ChoiceChip(
                          label: Text('${s.name} · M${formatMoney(s.basePrice)}'),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedService = s),
                          selectedColor: DnColors.blue,
                          labelStyle: TextStyle(color: selected ? Colors.white : DnColors.ink),
                        );
                      }).toList(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Could not load services: $e'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Optional extras', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  extras.when(
                    data: (list) => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: list.map((e) {
                        final selected = _selectedExtraIds.contains(e.id);
                        return FilterChip(
                          label: Text('${e.name} · M${formatMoney(e.price)}'),
                          selected: selected,
                          onSelected: (v) => setState(() => v ? _selectedExtraIds.add(e.id) : _selectedExtraIds.remove(e.id)),
                        );
                      }).toList(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Could not load extras: $e'),
                  ),
                ],
              ),
            ),
          ],
        );

        final summary = extras.when(
          data: (list) => DnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wash Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Text('Customer', style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                Text(_selectedCustomer?.fullName ?? 'Not selected', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text('Vehicle', style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                Text(_selectedVehicle?.regNumberDisplay ?? 'Not selected', style: const TextStyle(fontWeight: FontWeight.w600)),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('M${formatMoney(_total(list))}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: DnColors.green)),
                  ],
                ),
                if (_loyalty != null) ...[
                  const SizedBox(height: 16),
                  Text('Monthly loyalty', style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                  const SizedBox(height: 6),
                  DnLoyaltyMeter(count: _loyalty!.qualifyingCount),
                  const SizedBox(height: 6),
                  Text(
                    _loyalty!.hasAvailableReward
                        ? 'A free wash is available for this car'
                        : '${_loyalty!.remaining} more wash${_loyalty!.remaining == 1 ? '' : 'es'} for a free wash',
                    style: const TextStyle(fontSize: 12, color: DnColors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (_selectedVehicle != null && _selectedService != null) ? _startWash : null,
                  child: const Text('START WASH'),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox(),
          error: (_, _) => const SizedBox(),
        );

        if (wide) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: left),
                const SizedBox(width: 16),
                Expanded(child: summary),
              ],
            ),
          );
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, const SizedBox(height: 16), summary]);
      }),
    );
  }

  void _showAddCustomerDialog(String branchId) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: const Text('Add customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: 8),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final customer = await ref
                  .read(offlinePosRepositoryProvider)
                  .createCustomer(fullName: nameController.text.trim(), phone: phoneController.text.trim(), branchId: branchId);
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {
                  _selectedCustomer = customer;
                  _results = [customer];
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog() {
    // Captured once, up front — the dialog stays open across an await, and
    // the search box's listener can null out _selectedCustomer in the
    // meantime (typing a new query resets it synchronously; see
    // _onQueryChanged). Reading the field itself inside the async Save
    // handler below risked exactly that race.
    final customer = _selectedCustomer;
    if (customer == null) return;
    final regController = TextEditingController();
    final makeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: const Text('Add vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: regController, decoration: const InputDecoration(labelText: 'Registration number')),
            const SizedBox(height: 8),
            TextField(controller: makeController, decoration: const InputDecoration(labelText: 'Make / model')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final vehicle = await ref
                  .read(offlinePosRepositoryProvider)
                  .createVehicle(customerId: customer.id, regNumber: regController.text.trim(), make: makeController.text.trim());
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {
                  customer.vehicles.add(vehicle);
                  // Only adopt it as the active pick if the user is still on
                  // the same customer — they may have searched again and
                  // moved on to someone else while this dialog was open.
                  if (_selectedCustomer?.id == customer.id) _selectedVehicle = vehicle;
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final Customer customer;
  final bool selected;
  final VoidCallback onTap;
  const _CustomerTile({required this.customer, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? DnColors.blue : DnColors.line, width: selected ? 1.5 : 1),
            borderRadius: BorderRadius.circular(10),
            color: selected ? const Color(0xFFF7FAFF) : Colors.white,
          ),
          child: Row(
            children: [
              const CircleAvatar(backgroundColor: DnColors.blueSoft, child: Icon(Icons.person, color: DnColors.blue, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(customer.phone, style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: DnColors.green),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleChip extends StatelessWidget {
  final Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;
  const _VehicleChip({required this.vehicle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? DnColors.green : DnColors.line, width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(10),
          color: selected ? DnColors.greenSoft : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vehicle.regNumberDisplay, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${vehicle.make ?? ''} ${vehicle.model ?? ''}'.trim(), style: const TextStyle(color: DnColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
