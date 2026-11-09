import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgBase = Color(0xFFF0FDF4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0B2E22);
  static const Color textSecondary = Color(0xFF4F6B5E);
  static const Color textMuted = Color(0xFF557566);
  static const Color accent = Color(0xFF10B981);
  static const Color accentAction = Color(0xFF047857);
  static const Color income = Color(0xFF059669);
  static const Color expense = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);
  static const Color warningText = Color(0xFFB45309);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgBase,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentAction,
        surface: surface,
        primary: accentAction,
        secondary: accent,
        error: expense,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgBase,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
    );
  }
}
