import 'package:flutter/material.dart';

/// De Nest brand tokens — navy/blue, card-based, matching the reference
/// prototype's design language.
class DnColors {
  static const navy = Color(0xFF0A1F44);
  static const navyDeep = Color(0xFF071634);
  static const navySoft = Color(0xFF12305C);
  static const blue = Color(0xFF1B6BE3);
  static const blueDark = Color(0xFF1552B5);
  static const blueSoft = Color(0xFFEAF2FE);
  static const green = Color(0xFF16A34A);
  static const greenSoft = Color(0xFFE7F6EC);
  static const amber = Color(0xFFE08A0B);
  static const amberSoft = Color(0xFFFDF3E2);
  static const red = Color(0xFFDC2626);
  static const redSoft = Color(0xFFFDECEC);
  static const purpleSoft = Color(0xFFF1ECFD);
  static const bg = Color(0xFFF4F6FA);
  static const card = Color(0xFFFFFFFF);
  static const line = Color(0xFFE3E8EF);
  static const ink = Color(0xFF0D1B2A);
  static const muted = Color(0xFF667788);
}

class DnStatus {
  final String label;
  final Color color;
  final Color background;
  const DnStatus(this.label, this.color, this.background);

  static const waiting = DnStatus('Waiting', DnColors.amber, DnColors.amberSoft);
  static const washing = DnStatus('Washing', DnColors.blue, DnColors.blueSoft);
  static const ready = DnStatus('Ready', DnColors.green, DnColors.greenSoft);
  static const completed = DnStatus('Completed', DnColors.muted, Color(0xFFEEF1F5));
  static const cancelled = DnStatus('Cancelled', DnColors.red, DnColors.redSoft);

  static DnStatus forWashStatus(String status) => switch (status) {
        'WAITING' => waiting,
        'WASHING' => washing,
        'READY' => ready,
        'COMPLETED' => completed,
        'CANCELLED' => cancelled,
        _ => waiting,
      };
}

ThemeData buildDnTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  return base.copyWith(
    scaffoldBackgroundColor: DnColors.bg,
    colorScheme: base.colorScheme.copyWith(
      primary: DnColors.blue,
      secondary: DnColors.navy,
      surface: DnColors.card,
      error: DnColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DnColors.navy,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: DnColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: DnColors.line),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DnColors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DnColors.blue,
        side: const BorderSide(color: DnColors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: DnColors.line),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    textTheme: base.textTheme.apply(bodyColor: DnColors.ink, displayColor: DnColors.ink),
  );
}
