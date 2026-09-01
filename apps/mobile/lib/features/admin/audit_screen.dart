import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api_client.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final auditLogProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/audit');
  return resp.data as List<dynamic>;
});

final smsLogProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final resp = await ref.watch(apiClientProvider).get('/sms');
  return resp.data as List<dynamic>;
});

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Material(
            color: DnColors.bg,
            child: TabBar(
              labelColor: DnColors.blue,
              unselectedLabelColor: DnColors.muted,
              indicatorColor: DnColors.blue,
              tabs: [Tab(text: 'Audit log'), Tab(text: 'SMS log')],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _AuditList(provider: auditLogProvider),
                _SmsList(provider: smsLogProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditList extends ConsumerWidget {
  final AutoDisposeFutureProvider<List<dynamic>> provider;
  const _AuditList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return data.when(
      data: (list) => list.isEmpty
          ? const DnEmptyState(icon: Icons.shield_outlined, title: 'No audit entries yet', hint: '')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final a = list[i] as Map<String, dynamic>;
                final user = a['user'] as Map<String, dynamic>?;
                return ListTile(
                  title: Text(a['action'] as String),
                  subtitle: Text('${a['entityType']} · ${user?['fullName'] ?? 'system'}'),
                  trailing: Text((a['createdAt'] as String).substring(0, 16).replaceFirst('T', ' '), style: const TextStyle(fontSize: 11, color: DnColors.muted)),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
    );
  }
}

class _SmsList extends ConsumerWidget {
  final AutoDisposeFutureProvider<List<dynamic>> provider;
  const _SmsList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return data.when(
      data: (list) => list.isEmpty
          ? const DnEmptyState(icon: Icons.sms_outlined, title: 'No SMS messages yet', hint: '')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final m = list[i] as Map<String, dynamic>;
                return ListTile(
                  title: Text(m['phone'] as String),
                  subtitle: Text(m['renderedBody'] as String, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(m['status'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
    );
  }
}
