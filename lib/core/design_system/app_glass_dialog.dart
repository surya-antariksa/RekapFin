import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/glass_card.dart';
import 'package:rekap_fin/core/design_system/primary_button.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Dialog konfirmasi kaca RekapFin sesuai docs/08-design-system.md
class AppGlassDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const AppGlassDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Lanjutkan',
    this.cancelLabel = 'Batal',
    required this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  /// Menampilkan dialog kaca modal di atas overlay transparan
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Lanjutkan',
    String cancelLabel = 'Batal',
    IconData? icon,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: const Color(0x660B2E22), // overlay gelap transparan
      builder: (ctx) => AppGlassDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        iconColor: iconColor,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        width: 350,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.expenseSoft
                      : AppColors.incomeSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ??
                      (isDestructive
                          ? AppColors.expense
                          : AppColors.accentAction),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton.secondary(
                    label: cancelLabel,
                    height: 48,
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: confirmLabel,
                    height: 48,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
