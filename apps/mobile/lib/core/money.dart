/// All money in this app is an [int] number of cents/lisente — the backend
/// this was ported from never actually used precise decimal arithmetic
/// despite its Postgres columns being NUMERIC(12,2), so integer minor units
/// is a strict improvement, not a compromise: no float drift, exact
/// equality checks are actually exact.
library;

/// Formats a cents amount as a display string, e.g. 6050 -> "60.50". Callers
/// prefix the currency symbol themselves (this app uses "M" for Maloti).
String formatMoney(int cents) => (cents / 100).toStringAsFixed(2);

/// Parses a user-typed amount (e.g. "60.5") into cents (6050), or null if
/// not a valid non-negative number.
int? parseMoneyInput(String input) {
  final value = double.tryParse(input.trim());
  if (value == null || value.isNaN || value.isInfinite) return null;
  return (value * 100).round();
}

/// Converts a server-side currency-unit value (Prisma Decimal, serialized
/// as a JSON string or number in whole currency units) into cents. Only
/// needed at the boundary with the legacy backend's JSON shape.
int currencyUnitsToCents(dynamic value) => (double.parse(value.toString()) * 100).round();
