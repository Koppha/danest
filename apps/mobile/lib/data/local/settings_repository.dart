import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loyalty_repository.dart';

const _loyaltyScopeKey = 'loyalty_scope';

/// Small, app-wide, non-sensitive settings that don't warrant a database
/// table of their own — backed by shared_preferences, per its intended use
/// noted in pubspec.yaml.
class SettingsRepository {
  Future<LoyaltyScope> loyaltyScope() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loyaltyScopeKey) == 'customer' ? LoyaltyScope.customer : LoyaltyScope.vehicle;
  }

  Future<void> setLoyaltyScope(LoyaltyScope scope) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loyaltyScopeKey, scope == LoyaltyScope.customer ? 'customer' : 'vehicle');
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) => SettingsRepository());

/// One-shot read of the current setting — `ref.read(loyaltyScopeProvider.future)`
/// at a call site that needs it once, or `ref.watch(loyaltyScopeProvider)`
/// where a screen should rebuild if it changes.
final loyaltyScopeProvider = FutureProvider<LoyaltyScope>((ref) => ref.watch(settingsRepositoryProvider).loyaltyScope());
