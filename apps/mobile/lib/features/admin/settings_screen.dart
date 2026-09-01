import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final servicesSettingsProvider = FutureProvider.autoDispose((ref) => ref.watch(posRepositoryProvider).listServices());
final extrasSettingsProvider = FutureProvider.autoDispose((ref) => ref.watch(posRepositoryProvider).listExtras());

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
          const Text('Services, extras and prices. Payment methods, loyalty and backup settings are managed via the API for now.', style: TextStyle(color: DnColors.muted)),
          const SizedBox(height: 16),
          DnCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wash services', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                services.when(
                  data: (list) => Column(
                    children: list
                        .map((s) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.name),
                              subtitle: Text('${s.tier} · ${s.durationMinutes} min'),
                              trailing: Text('M${s.basePrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                const Text('Extras', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                extras.when(
                  data: (list) => Column(
                    children: list
                        .map((e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(e.name),
                              trailing: Text('M${e.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
}
