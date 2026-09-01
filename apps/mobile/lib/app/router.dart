import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/session.dart';
import '../features/auth/login_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/new_wash/new_wash_screen.dart';
import '../features/wash_queue/wash_queue_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/prepaid/prepaid_screen.dart';
import '../features/transactions/transactions_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/admin/collections_screen.dart';
import '../features/admin/expenses_screen.dart';
import '../features/admin/settings_screen.dart';
import '../features/admin/audit_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _SessionRefreshListenable(ref);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      if (session.loading) return null;
      final loggingIn = state.matchedLocation == '/login';
      if (!session.isAuthenticated) return loggingIn ? null : '/login';
      if (loggingIn) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/new-wash', builder: (context, state) => const NewWashScreen()),
          GoRoute(path: '/queue', builder: (context, state) => const WashQueueScreen()),
          GoRoute(path: '/customers', builder: (context, state) => const CustomersScreen()),
          GoRoute(path: '/prepaid', builder: (context, state) => const PrepaidScreen()),
          GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen()),
          GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen()),
          GoRoute(path: '/admin/collections', builder: (context, state) => const CollectionsScreen()),
          GoRoute(path: '/admin/expenses', builder: (context, state) => const ExpensesScreen()),
          GoRoute(path: '/admin/settings', builder: (context, state) => const SettingsScreen()),
          GoRoute(path: '/admin/audit', builder: (context, state) => const AuditScreen()),
        ],
      ),
    ],
  );
});

/// Bridges Riverpod's sessionProvider changes into something go_router's
/// redirect can react to (GoRouter expects a plain Listenable).
class _SessionRefreshListenable extends ChangeNotifier {
  _SessionRefreshListenable(Ref ref) {
    ref.listen(sessionProvider, (previous, next) => notifyListeners());
  }
}
