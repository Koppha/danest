import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/connectivity.dart';
import '../../core/session.dart';
import '../../data/remote/api_client.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

const _roles = ['ATTENDANT', 'SUPERVISOR', 'ADMINISTRATOR', 'OWNER'];

final usersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/users');
  return resp.data as List<dynamic>;
});

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final isOnline = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isOnline ? () => _showAddUserDialog(context, ref) : null,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add user'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Users', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Staff accounts and roles for this branch.', style: TextStyle(color: DnColors.muted)),
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
                          child: Text('Offline — user accounts can only be created or changed while connected.', style: TextStyle(fontSize: 12, color: DnColors.amber)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: users.when(
              data: (list) {
                if (list.isEmpty) {
                  return const DnEmptyState(icon: Icons.badge_outlined, title: 'No users yet', hint: 'Use "Add user" to create the first staff account.');
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final u = list[i] as Map<String, dynamic>;
                    final role = (u['role'] as Map<String, dynamic>)['name'] as String;
                    final active = u['active'] as bool;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DnCard(
                        child: Row(
                          children: [
                            const CircleAvatar(backgroundColor: DnColors.blueSoft, child: Icon(Icons.person, color: DnColors.blue, size: 18)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u['fullName'] as String, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 1),
                                  Text('${u['username']} · $role', style: const TextStyle(color: DnColors.muted, fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: active,
                              onChanged: isOnline
                                  ? (v) async {
                                      await ref.read(apiClientProvider).patch('/users/${u['id']}', data: {'active': v});
                                      ref.invalidate(usersProvider);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load users: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final pinController = TextEditingController();
    String role = 'ATTENDANT';
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add user'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full name')),
                const SizedBox(height: 8),
                TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setDialogState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(controller: pinController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN (optional, for overrides)')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setDialogState(() => role = v ?? role),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty || usernameController.text.trim().isEmpty || passwordController.text.length < 8) return;
                final branchId = ref.read(sessionProvider).user?.branchId ?? '';
                await ref.read(apiClientProvider).post('/users', data: {
                  'branchId': branchId,
                  'fullName': nameController.text.trim(),
                  'username': usernameController.text.trim(),
                  'password': passwordController.text,
                  'role': role,
                  if (pinController.text.trim().isNotEmpty) 'pin': pinController.text.trim(),
                });
                ref.invalidate(usersProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
