import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/money.dart';
import '../../core/session.dart';
import '../../data/local/loyalty_repository.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/local/settings_repository.dart';
import '../../data/models/models.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final servicesSettingsProvider = FutureProvider.autoDispose((ref) => ref.watch(offlinePosRepositoryProvider).listServices());
final extrasSettingsProvider = FutureProvider.autoDispose((ref) => ref.watch(offlinePosRepositoryProvider).listExtras());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesSettingsProvider);
    final extras = ref.watch(extrasSettingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Services, extras and prices.', style: TextStyle(color: DnColors.muted)),
          const SizedBox(height: 16),
          DnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Wash services', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () => _showServiceDialog(context, ref),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add service'),
                    ),
                  ],
                ),
                services.when(
                  data: (list) => Column(
                    children: list
                        .map((s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.name),
                              subtitle: Text('${s.tier} · ${s.durationMinutes} min'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('M${formatMoney(s.basePrice)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    tooltip: 'Edit',
                                    onPressed: () => _showServiceDialog(context, ref, existing: s),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Extras', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () => _showExtraDialog(context, ref),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add extra'),
                    ),
                  ],
                ),
                extras.when(
                  data: (list) => Column(
                    children: list
                        .map((e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(e.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('M${formatMoney(e.price)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    tooltip: 'Edit',
                                    onPressed: () => _showExtraDialog(context, ref, existing: e),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
              ],
            ),
          ),
          if (ref.watch(sessionProvider).user?.isOwner ?? false) ...[
            const SizedBox(height: 16),
            const _LoyaltyScopeCard(),
          ],
        ],
      ),
    );
  }

  void _showServiceDialog(BuildContext context, WidgetRef ref, {WashService? existing}) {
    final nameController = TextEditingController(text: existing?.name);
    final priceController = TextEditingController(text: existing == null ? null : formatMoney(existing.basePrice));
    final durationController = TextEditingController(text: existing?.durationMinutes.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(existing == null ? 'Add service' : 'Edit service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (M)')),
            const SizedBox(height: 8),
            TextField(controller: durationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (minutes)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final price = parseMoneyInput(priceController.text);
              final duration = int.tryParse(durationController.text);
              if (nameController.text.trim().isEmpty || price == null || duration == null) return;
              final name = nameController.text.trim();
              if (existing == null) {
                await ref.read(offlinePosRepositoryProvider).createService(name: name, basePrice: price, durationMinutes: duration);
              } else {
                await ref.read(offlinePosRepositoryProvider).updateService(id: existing.id, name: name, basePrice: price, durationMinutes: duration);
              }
              ref.invalidate(servicesSettingsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExtraDialog(BuildContext context, WidgetRef ref, {WashExtra? existing}) {
    final nameController = TextEditingController(text: existing?.name);
    final priceController = TextEditingController(text: existing == null ? null : formatMoney(existing.price));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        title: Text(existing == null ? 'Add extra' : 'Edit extra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 8),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (M)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final price = parseMoneyInput(priceController.text);
              if (nameController.text.trim().isEmpty || price == null) return;
              final name = nameController.text.trim();
              if (existing == null) {
                await ref.read(offlinePosRepositoryProvider).createExtra(name: name, price: price);
              } else {
                await ref.read(offlinePosRepositoryProvider).updateExtra(id: existing.id, name: name, price: price);
              }
              ref.invalidate(extrasSettingsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Owner-only: whether a customer's monthly free-wash progress is tracked
/// per vehicle (each car has its own counter) or pooled per customer
/// (washes across all their cars count toward the same free wash).
class _LoyaltyScopeCard extends ConsumerWidget {
  const _LoyaltyScopeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(loyaltyScopeProvider);
    return DnCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Loyalty program', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'How a customer\'s progress toward a free wash is counted.',
            style: TextStyle(color: DnColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          scope.when(
            data: (current) => SegmentedButton<LoyaltyScope>(
              segments: const [
                ButtonSegment(value: LoyaltyScope.vehicle, label: Text('Per vehicle'), icon: Icon(Icons.directions_car_outlined)),
                ButtonSegment(value: LoyaltyScope.customer, label: Text('Per customer'), icon: Icon(Icons.person_outline)),
              ],
              selected: {current},
              onSelectionChanged: (selection) async {
                await ref.read(settingsRepositoryProvider).setLoyaltyScope(selection.first);
                ref.invalidate(loyaltyScopeProvider);
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 8),
          Text(
            scope.value == LoyaltyScope.customer
                ? 'A customer bringing 2 different cars still adds up to one shared free wash.'
                : 'Each car has its own counter — a customer with 2 cars earns free washes twice as fast.',
            style: const TextStyle(color: DnColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
