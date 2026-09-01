import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/session.dart';
import '../../data/local/offline_pos_repository.dart';
import '../../data/models/models.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final customersSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final customersListProvider = FutureProvider.autoDispose<List<Customer>>((ref) {
  final query = ref.watch(customersSearchProvider);
  return ref.watch(offlinePosRepositoryProvider).searchCustomers(query);
});

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(customersSearchProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Search by name, phone, or registration', prefixIcon: Icon(Icons.search)),
                  onChanged: _onQueryChanged,
                  onSubmitted: (v) => ref.read(customersSearchProvider.notifier).state = v.trim(),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _showAddCustomerDialog(context, ref),
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text('Add customer'),
              ),
            ],
          ),
        ),
        Expanded(
          child: customers.when(
            data: (list) {
              if (list.isEmpty) {
                return const DnEmptyState(icon: Icons.people_outline, title: 'No customers found', hint: 'Try a different search, or tap "Add customer" above.');
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

  void _showAddCustomerDialog(BuildContext context, WidgetRef ref) {
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
              final branchId = ref.read(sessionProvider).user?.branchId ?? '';
              await ref.read(offlinePosRepositoryProvider).createCustomer(
                    fullName: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    branchId: branchId,
                  );
              ref.invalidate(customersListProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
