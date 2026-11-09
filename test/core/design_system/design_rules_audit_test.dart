import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_spacing.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

void main() {
  group('Design Rules Audit (F02)', () {
    test(
        'Audit Tipografi: Tidak ada ukuran font di bawah 12 px selain pengecualian 11 px (OI-03)',
        () {
      final textStyles = <String, double?>{
        'display': AppTypography.display.fontSize,
        'pageTitle': AppTypography.pageTitle.fontSize,
        'title': AppTypography.title.fontSize,
        'subtitle': AppTypography.subtitle.fontSize,
        'body': AppTypography.body.fontSize,
        'bodyRegular': AppTypography.bodyRegular.fontSize,
        'caption': AppTypography.caption.fontSize,
        'captionSemiBold': AppTypography.captionSemiBold.fontSize,
      };

      for (final entry in textStyles.entries) {
        expect(
          entry.value,
          isNotNull,
          reason:
              'Style ${entry.key} harus memiliki ukuran font yang terdefinisi',
        );
        expect(
          entry.value! >= 12.0,
          isTrue,
          reason:
              'Style ${entry.key} memiliki fontSize ${entry.value} px. Standar RekapFin minimal 12 px (docs/08).',
        );
      }

      // Pengecualian sengaja 11 px (OI-03): label BottomNavBar, Tanya AI, Aksi Cepat
      expect(
        AppTypography.micro.fontSize,
        equals(11.0),
        reason:
            'fs-micro harus tepat 11 px sebagai pengecualian yang diputuskan (OI-03)',
      );
    });

    test('Audit Zona Eksklusi Tanya AI (docs/08 bagian 8)', () {
      // Zona bebas teks/nominal Tanya AI: x 302..390, y 672..744 (tanya-zone-x=302, tanya-zone-y=672)
      expect(TanyaAiFab.tanyaZoneX, equals(302.0));
      expect(TanyaAiFab.tanyaZoneY, equals(672.0));
      expect(TanyaAiFab.tanyaZoneEndX, equals(390.0));
      expect(TanyaAiFab.tanyaZoneEndY, equals(744.0));

      expect(
        TanyaAiFab.exclusionZone,
        equals(const Rect.fromLTRB(302.0, 672.0, 390.0, 744.0)),
      );

      // Posisi widget Tanya AI dalam viewport 390 x 844: (x=240, y=684), ukuran 130 x 52
      expect(TanyaAiFab.widgetX, equals(240.0));
      expect(TanyaAiFab.widgetY, equals(684.0));
      expect(TanyaAiFab.widgetWidth, equals(130.0));
      expect(TanyaAiFab.widgetHeight, equals(52.0));

      // Verifikasi tombol bulat Tanya AI (x=318..370, y=684..736) berada dalam batas zona eksklusi
      const buttonLeft = TanyaAiFab.widgetX + 78.0;
      const buttonRight = buttonLeft + 52.0;
      const buttonTop = TanyaAiFab.widgetY;
      const buttonBottom = buttonTop + 52.0;

      expect(buttonLeft >= TanyaAiFab.tanyaZoneX, isTrue);
      expect(buttonRight <= TanyaAiFab.tanyaZoneEndX, isTrue);
      expect(buttonTop >= TanyaAiFab.tanyaZoneY, isTrue);
      expect(buttonBottom <= TanyaAiFab.tanyaZoneEndY, isTrue);
    });

    test('Audit Radius dan Dimensi Komponen Inti (docs/08)', () {
      // Radius token
      expect(AppRadius.card, equals(24.0));
      expect(AppRadius.button, equals(16.0));
      expect(AppRadius.chip, equals(999.0));
      expect(AppRadius.nav, equals(34.0));

      // Layout & Spacing
      expect(AppSpacing.screenPadding, equals(20.0));
      expect(AppSpacing.scrollBottomPadding, equals(160.0));
      expect(AppSpacing.contentTop, equals(54.0));
      expect(AppSpacing.safeBottom, equals(24.0));
      expect(AppSpacing.sm, equals(12.0)); // jarak antar kartu
      expect(AppSpacing.md, equals(16.0)); // jarak antar section
    });
  });
}
