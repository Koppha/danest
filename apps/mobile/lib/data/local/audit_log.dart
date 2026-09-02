import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

const _uuid = Uuid();

/// The canonical action codes written to [AppDatabase.localAuditLog]. A
/// typed constant per action (rather than bare strings at each call site)
/// means a typo is a compile error, not a silently-missing log entry.
abstract final class AuditAction {
  static const userLoggedIn = 'USER_LOGGED_IN';
  static const userCreated = 'USER_CREATED';
  static const userUpdated = 'USER_UPDATED';
  static const userActivated = 'USER_ACTIVATED';
  static const userDeactivated = 'USER_DEACTIVATED';
  static const userPasswordReset = 'USER_PASSWORD_RESET';
  static const userPinReset = 'USER_PIN_RESET';
  static const washOrderCompleted = 'WASH_ORDER_COMPLETED';
  static const washOrderCancelled = 'WASH_ORDER_CANCELLED';
  static const paymentVoided = 'PAYMENT_VOIDED';
  static const expenseReversed = 'EXPENSE_REVERSED';
  static const cashCollectionConfirmed = 'CASH_COLLECTION_CONFIRMED';
}

/// Appends one row to the unified audit trail. Not a class of its own —
/// every repository already holds an [AppDatabase], so a free function
/// avoids threading a new constructor dependency (and rewriting every
/// test that builds a repository directly) just for this.
Future<void> recordAudit(
  AppDatabase db, {
  required String action,
  String? actorId,
  String? entityType,
  String? entityId,
  Map<String, dynamic>? metadata,
}) {
  return db.into(db.localAuditLog).insert(
        LocalAuditLogCompanion.insert(
          id: _uuid.v4(),
          action: action,
          actorId: Value(actorId),
          entityType: Value(entityType),
          entityId: Value(entityId),
          metadataJson: Value(metadata == null ? null : jsonEncode(metadata)),
        ),
      );
}
