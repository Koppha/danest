import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/session.dart';
import '../../data/remote/auth_repository.dart';
import '../../design_system/theme.dart';
import 'sync_status.dart';

class NavItem {
  final String path;
  final String label;
  final IconData icon;
  const NavItem(this.path, this.label, this.icon);
}

const _mainNav = [
  NavItem('/dashboard', 'Dashboard', Icons.home_outlined),
  NavItem('/new-wash', 'New Wash', Icons.local_car_wash_outlined),
  NavItem('/queue', 'Wash Queue', Icons.access_time),
  NavItem('/customers', 'Customers', Icons.people_outline),
  NavItem('/prepaid', 'Prepaid', Icons.account_balance_wallet_outlined),
  NavItem('/transactions', 'Transactions', Icons.receipt_long_outlined),
  NavItem('/reports', 'Reports', Icons.bar_chart_outlined),
];

const _adminNav = [
  NavItem('/admin/collections', 'Collections', Icons.savings_outlined),
  NavItem('/admin/expenses', 'Expenses', Icons.description_outlined),
  NavItem('/admin/settings', 'Settings', Icons.settings_outlined),
  NavItem('/admin/audit', 'Audit & SMS', Icons.shield_outlined),
];

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).user;
    final location = GoRouterState.of(context).uri.toString();
    final isAdmin = user?.isAdminOrAbove ?? false;
    final wide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: DnColors.navySoft, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.local_car_wash, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                wide ? 'De Nest Car Wash' : 'De Nest',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          const SyncStatusIndicator(),
          if (user != null && wide)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authRepositoryProvider).logout(),
          ),
        ],
      ),
      drawer: wide ? null : _NavDrawer(location: location, isAdmin: isAdmin, user: user),
      body: Row(
        children: [
          if (wide) _NavRail(location: location, isAdmin: isAdmin, user: user),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavRail extends StatelessWidget {
  final String location;
  final bool isAdmin;
  final DnUser? user;
  const _NavRail({required this.location, required this.isAdmin, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: DnColors.navy,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ..._mainNav.map((n) => _RailItem(item: n, selected: location.startsWith(n.path))),
          if (isAdmin) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: Text('Back office', style: TextStyle(color: Color(0xFF6D89B0), fontSize: 12)),
            ),
            ..._adminNav.map((n) => _RailItem(item: n, selected: location.startsWith(n.path))),
          ],
        ],
      ),
    );
  }
}

class _NavDrawer extends StatelessWidget {
  final String location;
  final bool isAdmin;
  final DnUser? user;
  const _NavDrawer({required this.location, required this.isAdmin, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DnColors.navy,
      child: SafeArea(
        child: _NavRail(location: location, isAdmin: isAdmin, user: user),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final NavItem item;
  final bool selected;
  const _RailItem({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: selected ? DnColors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.go(item.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: selected ? Colors.white : const Color(0xFFB4C6DE)),
                const SizedBox(width: 10),
                Text(item.label, style: TextStyle(color: selected ? Colors.white : const Color(0xFFB4C6DE), fontSize: 13.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
