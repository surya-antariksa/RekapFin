import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Header bottom sheet RekapFin sesuai docs/08-design-system.md
/// Spesifikasi: judul 20/700, tombol tutup (X) lingkaran di kanan
class AppSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final Widget? leading;

  const AppSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTypography.title.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClose != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.0,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 18,
                icon: const Icon(
                  AppIcons.close,
                  color: AppColors.textSecondary,
                ),
                onPressed: onClose,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
