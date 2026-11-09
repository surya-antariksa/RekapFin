import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Sakelar pengalih (Toggle switch) RekapFin sesuai docs/08-design-system.md
class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? title;
  final String? subtitle;

  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: value ? AppColors.accentAction : AppColors.glassFill,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: value ? AppColors.accentAction : AppColors.glassBorder,
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.glassShadow,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (title == null) {
      return switchWidget;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            switchWidget,
          ],
        ),
      ),
    );
  }
}
