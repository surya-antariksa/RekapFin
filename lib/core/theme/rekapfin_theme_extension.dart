import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';

@immutable
class RekapFinThemeExtension extends ThemeExtension<RekapFinThemeExtension> {
  final Color bgBase;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentAction;
  final Color income;
  final Color expense;
  final Color warning;
  final Color warningText;

  const RekapFinThemeExtension({
    this.bgBase = AppColors.bgBase,
    this.surface = AppColors.surface,
    this.textPrimary = AppColors.textPrimary,
    this.textSecondary = AppColors.textSecondary,
    this.textMuted = AppColors.textMuted,
    this.accent = AppColors.accent,
    this.accentAction = AppColors.accentAction,
    this.income = AppColors.income,
    this.expense = AppColors.expense,
    this.warning = AppColors.warning,
    this.warningText = AppColors.warningText,
  });

  @override
  RekapFinThemeExtension copyWith({
    Color? bgBase,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentAction,
    Color? income,
    Color? expense,
    Color? warning,
    Color? warningText,
  }) {
    return RekapFinThemeExtension(
      bgBase: bgBase ?? this.bgBase,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentAction: accentAction ?? this.accentAction,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
    );
  }

  @override
  RekapFinThemeExtension lerp(
      ThemeExtension<RekapFinThemeExtension>? other, double t) {
    if (other is! RekapFinThemeExtension) {
      return this;
    }
    return RekapFinThemeExtension(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentAction: Color.lerp(accentAction, other.accentAction, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
    );
  }
}

extension BuildContextTheme on BuildContext {
  RekapFinThemeExtension get rekapColors =>
      Theme.of(this).extension<RekapFinThemeExtension>() ??
      const RekapFinThemeExtension();
}
