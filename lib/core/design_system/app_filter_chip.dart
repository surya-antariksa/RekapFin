import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Chip filter RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Bentuk: pil (radius 999)
/// - Tinggi: 36, padding horizontal: 16
/// - Aktif: isi accent-action (#047857), label 12/600 putih, bayangan luar 0/4 blur 12 (#10B98140)
/// - Tidak aktif: kaca (#FFFFFF8C, blur 20), tepi 1 px (#FFFFFFCC), label 12/500 text-secondary
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.accentAction,
          borderRadius: AppRadius.chipRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.heroShadow,
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.chipRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: AppTypography.captionSemiBold.copyWith(
                      color: AppColors.textOnAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // State Tidak Aktif (Kaca)
    return ClipRRect(
      borderRadius: AppRadius.chipRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: AppRadius.chipRadius,
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadius.chipRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
