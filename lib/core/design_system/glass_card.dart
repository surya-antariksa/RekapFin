import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Kartu kaca (iOS glassmorphism) RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Lebar: 350 (default atau sesuai container)
/// - Padding: 16 (default)
/// - Radius: 24 (AppRadius.card)
/// - Fill: glass-fill (#FFFFFF8C, ~55%)
/// - Border: 1 px glass-border (#FFFFFFCC)
/// - Blur latar: glass-blur 30 (sigma 15)
/// - Bayangan luar: 0/8, blur 32, glass-shadow (#0F172A14)
class GlassCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding,
      child: child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: AppTypography.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: content,
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            offset: Offset(0, 8),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.0,
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
