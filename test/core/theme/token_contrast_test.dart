import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_spacing.dart';

/// Menghitung relative luminance sesuai spesifikasi WCAG 2.1
double _calculateLuminance(Color color) {
  double srgbComponent(double c) {
    return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = srgbComponent(color.r);
  final g = srgbComponent(color.g);
  final b = srgbComponent(color.b);

  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Menghitung rasio kontras WCAG 2.1
double _contrastRatio(Color c1, Color c2) {
  final l1 = _calculateLuminance(c1);
  final l2 = _calculateLuminance(c2);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('F01: Verifikasi Kontras Warna Token (docs/08 bagian 1.1)', () {
    test('Putih / accent-action (#047857) >= 4.5:1 (OI-27)', () {
      final ratio = _contrastRatio(Colors.white, AppColors.accentAction);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(5.48, 0.1));
    });

    test('text-muted (#557566) / bg-base (#F0FDF4) >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.textMuted, AppColors.bgBase);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(4.87, 0.1));
    });

    test('text-muted (#557566) / putih >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.textMuted, Colors.white);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(5.09, 0.1));
    });

    test('warning-text (#B45309) / putih >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.warningText, Colors.white);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(5.02, 0.1));
    });

    test('status-danger (#B91C1C) / putih >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.statusDanger, Colors.white);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(6.47, 0.1));
    });

    test('expense (#DC2626) / putih >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.expense, Colors.white);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(4.83, 0.1));
    });

    test('text-secondary (#4F6B5E) / bg-base >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.textSecondary, AppColors.bgBase);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(5.58, 0.1));
    });

    test('text-primary (#0B2E22) / bg-base >= 4.5:1', () {
      final ratio = _contrastRatio(AppColors.textPrimary, AppColors.bgBase);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(14.05, 0.1));
    });

    test('Putih / hero-end (#078761) >= 4.5:1', () {
      final ratio = _contrastRatio(Colors.white, AppColors.heroEnd);
      expect(ratio, greaterThanOrEqualTo(4.5));
      expect(ratio, closeTo(4.52, 0.1));
    });
  });

  group('F01: Verifikasi Batas Tipografi dan Spasi (docs/08)', () {
    test(
        'Tidak ada teks di bawah 12 px selain pengecualian fs-micro 11 px (OI-03)',
        () {
      expect(AppTypography.display.fontSize, greaterThanOrEqualTo(12.0));
      expect(AppTypography.pageTitle.fontSize, greaterThanOrEqualTo(12.0));
      expect(AppTypography.title.fontSize, greaterThanOrEqualTo(12.0));
      expect(AppTypography.subtitle.fontSize, greaterThanOrEqualTo(12.0));
      expect(AppTypography.body.fontSize, greaterThanOrEqualTo(12.0));
      expect(AppTypography.caption.fontSize, greaterThanOrEqualTo(12.0));

      // Pengecualian sengaja 11 px
      expect(AppTypography.micro.fontSize, equals(11.0));
    });

    test(
        'Radius token sesuai docs/08 (card: 24, button: 16, chip: 999, nav: 34)',
        () {
      expect(AppRadius.card, equals(24.0));
      expect(AppRadius.button, equals(16.0));
      expect(AppRadius.chip, equals(999.0));
      expect(AppRadius.nav, equals(34.0));
    });

    test(
        'Spasi token sesuai docs/08 (jarak section 16, kartu 12, scroll padding 160)',
        () {
      expect(AppSpacing.sm, equals(12.0));
      expect(AppSpacing.md, equals(16.0));
      expect(AppSpacing.scrollBottomPadding, equals(160.0));
    });
  });
}
