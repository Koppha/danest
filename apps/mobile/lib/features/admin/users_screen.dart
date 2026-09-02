import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/session.dart';
import '../../data/local/app_database.dart';
import '../../data/local/auth_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

const _roles = ['ATTENDANT', 'SUPERVISOR', 'ADMINISTRATOR', 'OWNER'];

final usersProvider = FutureProvider.autoDispose<List<LocalUser>>((ref) => ref.watch(authRepositoryProvider).listUsers());

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(context, ref),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add user'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Users', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Staff accounts and roles.', style: TextStyle(color: DnColors.muted)),
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
                    final u = list[i];
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
                                  Text(u.fullName, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 1),
                                  Text('${u.username} · ${u.role}', style: const TextStyle(color: DnColors.muted, fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Edit',
                              onPressed: () => _showUserDialog(context, ref, existing: u),
                            ),
                            Switch(
                              value: u.active,
                              onChanged: (v) async {
                                await ref.read(authRepositoryProvider).setActive(userId: u.id, active: v, actorId: ref.read(sessionProvider).user!.id);
                                ref.invalidate(usersProvider);
                              },
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

  void _showUserDialog(BuildContext context, WidgetRef ref, {LocalUser? existing}) {
    final nameController = TextEditingController(text: existing?.fullName ?? '');
    final usernameController = TextEditingController(text: existing?.username ?? '');
    final passwordController = TextEditingController();
    final pinController = TextEditingController();
    String role = existing?.role ?? 'ATTENDANT';
    bool obscurePassword = true;
    String? error;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add user' : 'Edit user'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full name')),
                const SizedBox(height: 8),
                TextField(controller: usernameController, enabled: existing == null, decoration: const InputDecoration(labelText: 'Username')),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: existing == null ? 'Password' : 'New password (leave blank to keep unchanged)',
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setDialogState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: existing == null ? 'PIN (optional, for overrides)' : 'New PIN (leave blank to keep unchanged)'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setDialogState(() => role = v ?? role),
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!, style: const TextStyle(color: DnColors.red)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final actorId = ref.read(sessionProvider).user!.id;
                final name = nameController.text.trim();
                final username = usernameController.text.trim();
                final newPassword = passwordController.text;
                final newPin = pinController.text.trim();
                if (name.isEmpty || (existing == null && (username.isEmpty || newPassword.length < 8))) return;
                if (newPassword.isNotEmpty && newPassword.length < 8) {
                  setDialogState(() => error = 'Password must be at least 8 characters');
                  return;
                }
                try {
                  if (existing == null) {
                    await ref.read(authRepositoryProvider).createUser(
                          fullName: name,
                          username: username,
                          password: newPassword,
                          role: role,
                          pin: newPin.isEmpty ? null : newPin,
                          actorId: actorId,
                        );
                  } else {
                    await ref.read(authRepositoryProvider).updateUser(userId: existing.id, fullName: name, role: role, actorId: actorId);
                    if (newPassword.isNotEmpty) {
                      await ref.read(authRepositoryProvider).setPassword(userId: existing.id, newPassword: newPassword, actorId: actorId);
                    }
                    if (newPin.isNotEmpty) {
                      await ref.read(authRepositoryProvider).setPin(userId: existing.id, newPin: newPin, actorId: actorId);
                    }
                  }
                  ref.invalidate(usersProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                } on UsernameTakenException catch (e) {
                  setDialogState(() => error = e.toString());
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
