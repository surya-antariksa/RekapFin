import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Kontrol segmen RekapFin sesuai docs/08-design-system.md
class AppSegmentedControl<T> extends StatelessWidget {
  final Map<T, String> segments;
  final T selected;
  final ValueChanged<T> onSelected;

  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.0,
            ),
          ),
          child: Row(
            children: segments.entries.map((entry) {
              final isCurrent = entry.key == selected;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isCurrent
                          ? const [
                              BoxShadow(
                                color: AppColors.glassShadow,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        entry.value,
                        style: isCurrent
                            ? AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              )
                            : AppTypography.bodyRegular.copyWith(
                                color: AppColors.textSecondary,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
