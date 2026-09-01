import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/models.dart';
import '../../data/remote/pos_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final customersSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final customersListProvider = FutureProvider.autoDispose<List<Customer>>((ref) {
  final query = ref.watch(customersSearchProvider);
  return ref.watch(posRepositoryProvider).searchCustomers(query);
});

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(hintText: 'Search by name, phone, or registration', prefixIcon: Icon(Icons.search)),
            onSubmitted: (v) => ref.read(customersSearchProvider.notifier).state = v,
          ),
        ),
        Expanded(
          child: customers.when(
            data: (list) {
              if (list.isEmpty) {
                return const DnEmptyState(icon: Icons.people_outline, title: 'No customers found', hint: 'Try a different search, or add one from New Wash.');
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final c = list[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DnCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(backgroundColor: DnColors.blueSoft, child: Icon(Icons.person, color: DnColors.blue, size: 18)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(c.phone, style: const TextStyle(color: DnColors.muted, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (c.vehicles.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 10),
                            ...c.vehicles.map((v) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.directions_car, size: 16, color: DnColors.muted),
                                      const SizedBox(width: 8),
                                      Text(v.regNumberDisplay, style: const TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Could not load customers: $e')),
          ),
        ),
      ],
    );
  }
}
