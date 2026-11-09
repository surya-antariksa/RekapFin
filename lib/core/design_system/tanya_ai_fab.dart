import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Tombol melayang Tanya AI RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Wadah: 130 x 52 di koordinat (x=240, y=684) pada viewport 390 x 844
/// - Label pil di kiri: 70 x 24, teks 11/600 (AppTypography.micro) "Tanya AI"
/// - Tombol bulat di kanan: 52 x 52 di offset x=78, gradien hero-start ke hero-end, ikon sparkles 24
/// - Zona eksklusi bebas teks/nominal: x 302..390, y 672..744 (tanyaZoneX/Y)
class TanyaAiFab extends StatelessWidget {
  final VoidCallback onTap;

  /// Konstanta koordinat zona eksklusi bebas teks/nominal (docs/08 bagian 8)
  static const double tanyaZoneX = 302.0;
  static const double tanyaZoneY = 672.0;
  static const double tanyaZoneEndX = 390.0;
  static const double tanyaZoneEndY = 744.0;
  static const Rect exclusionZone = Rect.fromLTRB(302, 672, 390, 744);

  /// Posisi dan dimensi widget dalam frame 390 x 844
  static const double widgetX = 240.0;
  static const double widgetY = 684.0;
  static const double widgetWidth = 130.0;
  static const double widgetHeight = 52.0;
  static const Rect widgetRect =
      Rect.fromLTWH(widgetX, widgetY, widgetWidth, widgetHeight);

  const TanyaAiFab({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Label Pil Kiri (70 x 24)
            Positioned(
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width:
                        90, // meluas sedikit di belakang tombol bulat agar mulus
                    height: 28,
                    padding: const EdgeInsets.only(left: 12, right: 28),
                    decoration: BoxDecoration(
                      color: AppColors.glassFill,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.glassShadow,
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tanya AI',
                      style: AppTypography.micro.copyWith(
                        color: AppColors.accentAction,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Bulat Kanan (52 x 52) di x=78
            Positioned(
              left: 78,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.heroStart,
                      AppColors.heroEnd,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.heroShadow,
                      offset: Offset(0, 4),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.tanyaAi,
                    size: 24,
                    color: AppColors.textOnAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
