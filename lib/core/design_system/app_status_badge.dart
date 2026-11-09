import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

enum BadgeVariant {
  ok,
  warn,
  danger,
  neutral,
}

/// Lencana status (Status Badge) RekapFin sesuai docs/08-design-system.md
/// Digunakan untuk status seperti Lunas, Terlambat, Periksa kembali, Disarankan AI, dsb.
class AppStatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const AppStatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  const factory AppStatusBadge.ok({
    Key? key,
    required String label,
    IconData? icon,
  }) = _OkStatusBadge;

  const factory AppStatusBadge.warn({
    Key? key,
    required String label,
    IconData? icon,
  }) = _WarnStatusBadge;

  const factory AppStatusBadge.danger({
    Key? key,
    required String label,
    IconData? icon,
  }) = _DangerStatusBadge;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (variant) {
      case BadgeVariant.ok:
        textColor = AppColors.statusOk;
        backgroundColor = AppColors.incomeSoft;
        borderColor = AppColors.statusOk.withValues(alpha: 0.3);
        break;
      case BadgeVariant.warn:
        textColor = AppColors.warningText;
        backgroundColor = AppColors.warningSoft;
        borderColor = AppColors.warning.withValues(alpha: 0.3);
        break;
      case BadgeVariant.danger:
        textColor = AppColors.statusDanger;
        backgroundColor = AppColors.expenseSoft;
        borderColor = AppColors.statusDanger.withValues(alpha: 0.3);
        break;
      case BadgeVariant.neutral:
        textColor = AppColors.accentAction;
        backgroundColor = AppColors.incomeSoft;
        borderColor = AppColors.accent.withValues(alpha: 0.3);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.captionSemiBold.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OkStatusBadge extends AppStatusBadge {
  const _OkStatusBadge({
    super.key,
    required super.label,
    super.icon,
  }) : super(variant: BadgeVariant.ok);
}

class _WarnStatusBadge extends AppStatusBadge {
  const _WarnStatusBadge({
    super.key,
    required super.label,
    super.icon,
  }) : super(variant: BadgeVariant.warn);
}

class _DangerStatusBadge extends AppStatusBadge {
  const _DangerStatusBadge({
    super.key,
    required super.label,
    super.icon,
  }) : super(variant: BadgeVariant.danger);
}
