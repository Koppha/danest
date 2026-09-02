import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/local/app_database.dart';
import '../../data/local/database_provider.dart';
import '../../data/local/sms_service.dart';
import '../../design_system/theme.dart';
import '../../design_system/widgets.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

String _humanizeAction(String action) {
  final words = action.split('_').where((w) => w.isNotEmpty).map((w) => w.toLowerCase()).toList();
  if (words.isEmpty) return action;
  words[0] = words[0][0].toUpperCase() + words[0].substring(1);
  return words.join(' ');
}

final auditLogProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final entries = await (db.select(db.localAuditLog)
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
        ..limit(200))
      .get();
  final users = await db.select(db.localUsers).get();
  final namesById = {for (final u in users) u.id: u.fullName};
  return entries
      .map(
        (e) => {
          'action': e.action,
          'entityType': e.entityType,
          'actorName': e.actorId == null ? 'System' : (namesById[e.actorId] ?? 'Unknown'),
          'createdAt': e.createdAt,
        },
      )
      .toList();
});

final smsLogProvider = FutureProvider.autoDispose<List<LocalSmsMessage>>((ref) => ref.watch(smsServiceProvider).list());

Color _smsStatusColor(String status) {
  switch (status) {
    case 'SENT':
      return DnColors.green;
    case 'FAILED':
      return DnColors.red;
    default:
      return DnColors.amber;
  }
}

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
          const Expanded(
            child: TabBarView(
              children: [_AuditList(), _SmsList()],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditList extends ConsumerWidget {
  const _AuditList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(auditLogProvider);
    return data.when(
      data: (list) => list.isEmpty
          ? const DnEmptyState(icon: Icons.shield_outlined, title: 'No audit entries yet', hint: '')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final a = list[i];
                return ListTile(
                  title: Text(_humanizeAction(a['action'] as String)),
                  subtitle: Text('${a['entityType'] ?? '—'} · ${a['actorName']}'),
                  trailing: Text(_dateFormat.format((a['createdAt'] as DateTime).toLocal()), style: const TextStyle(fontSize: 11, color: DnColors.muted)),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
    );
  }
}

class _SmsList extends ConsumerWidget {
  const _SmsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(smsLogProvider);
    return data.when(
      data: (list) => list.isEmpty
          ? const DnEmptyState(icon: Icons.sms_outlined, title: 'No SMS messages yet', hint: '')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final m = list[i];
                return ListTile(
                  title: Text(m.phone),
                  subtitle: Text(m.renderedBody, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(m.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _smsStatusColor(m.status))),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
    );
  }
}
