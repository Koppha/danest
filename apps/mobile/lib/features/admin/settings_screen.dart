import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/connectivity.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/models/models.dart';
import '../../data/remote/api_client.dart';
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
    final isOnline = ref.watch(connectivityProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Services, extras and prices. Payment methods, loyalty and backup settings are managed via the API for now.', style: TextStyle(color: DnColors.muted)),
          if (!isOnline) ...[
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
                    child: Text('Offline — price edits will sync automatically. Adding a new service or extra needs a connection.', style: TextStyle(fontSize: 12, color: DnColors.amber)),
                  ),
                ],
              ),
            ),
          ],
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
                      onPressed: isOnline ? () => _showServiceDialog(context, ref) : null,
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
                                  Text('M${s.basePrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                      onPressed: isOnline ? () => _showExtraDialog(context, ref) : null,
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
                                  Text('M${e.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
        ],
      ),
    );
  }

  void _showServiceDialog(BuildContext context, WidgetRef ref, {WashService? existing}) {
    final nameController = TextEditingController(text: existing?.name);
    final priceController = TextEditingController(text: existing?.basePrice.toStringAsFixed(2));
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
              final price = double.tryParse(priceController.text);
              final duration = int.tryParse(durationController.text);
              if (nameController.text.trim().isEmpty || price == null || duration == null) return;
              final name = nameController.text.trim();
              if (existing == null) {
                await ref.read(apiClientProvider).post('/wash-services', data: {'name': name, 'basePrice': price, 'durationMinutes': duration});
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
    final priceController = TextEditingController(text: existing?.price.toStringAsFixed(2));
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
              final price = double.tryParse(priceController.text);
              if (nameController.text.trim().isEmpty || price == null) return;
              final name = nameController.text.trim();
              if (existing == null) {
                await ref.read(apiClientProvider).post('/wash-extras', data: {'name': name, 'price': price});
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
