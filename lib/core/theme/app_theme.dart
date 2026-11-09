import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';
import 'package:rekap_fin/core/theme/rekapfin_theme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.bgBase,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentAction,
        surface: AppColors.surface,
        primary: AppColors.accentAction,
        secondary: AppColors.accent,
        error: AppColors.expense,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBase,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTypography.pageTitle,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),
      extensions: const [
        RekapFinThemeExtension(),
      ],
    );
  }
}
