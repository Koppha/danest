import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/local/app_database.dart';
import '../../data/local/backup_repository.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

final backupHistoryProvider = FutureProvider.autoDispose<List<LocalBackupRun>>((ref) => ref.watch(backupRepositoryProvider).history());

class BackupsScreen extends ConsumerWidget {
  const BackupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(backupHistoryProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBackupDialog(context, ref),
        icon: const Icon(Icons.backup_outlined),
        label: const Text('Back up now'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Backups', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              'Encrypted local exports of everything in this app. Keep the password safe — without it, a backup cannot be restored, by anyone.',
              style: TextStyle(color: DnColors.muted),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: history.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const DnEmptyState(icon: Icons.backup_outlined, title: 'No backups yet', hint: 'Use "Back up now" to create the first one.');
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final run = list[i];
                      final ok = run.status == 'SUCCESS';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DnCard(
                          child: Row(
                            children: [
                              Icon(ok ? Icons.check_circle_outline : Icons.error_outline, color: ok ? DnColors.green : DnColors.red, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_dateFormat.format(run.createdAt.toLocal()), style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(
                                      ok ? '${(run.sizeBytes / 1024).toStringAsFixed(0)} KB' : (run.errorMessage ?? 'Failed'),
                                      style: const TextStyle(color: DnColors.muted, fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (ok) TextButton(onPressed: () => _showVerifyDialog(context, ref, run), child: const Text('Verify')),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Could not load backups: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupDialog(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    bool submitting = false;
    String? error;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Back up now'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose a password for this backup. Write it down somewhere safe — it's the only way to restore it, and it isn't stored anywhere.",
                style: TextStyle(color: DnColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
              const SizedBox(height: 8),
              TextField(controller: confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password')),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: DnColors.red, fontSize: 12)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: submitting ? null : () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: submitting
                  ? null
                  : () async {
                      if (passwordController.text.length < 8) {
                        setDialogState(() => error = 'Password must be at least 8 characters');
                        return;
                      }
                      if (passwordController.text != confirmController.text) {
                        setDialogState(() => error = 'Passwords do not match');
                        return;
                      }
                      setDialogState(() {
                        submitting = true;
                        error = null;
                      });
                      try {
                        await ref.read(backupRepositoryProvider).backupNow(password: passwordController.text);
                        ref.invalidate(backupHistoryProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        setDialogState(() {
                          submitting = false;
                          error = 'Backup failed: $e';
                        });
                      }
                    },
              child: submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Back up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showVerifyDialog(BuildContext context, WidgetRef ref, LocalBackupRun run) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verify backup'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final password = passwordController.text;
              Navigator.pop(ctx);
              try {
                await ref.read(backupRepositoryProvider).decryptBackup(File(run.filePath), password: password);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This backup is valid and restorable.')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not verify: $e')));
                }
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
