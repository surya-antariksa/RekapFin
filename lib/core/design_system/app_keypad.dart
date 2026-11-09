import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Papan tombol angka (Keypad) RekapFin sesuai docs/08-design-system.md
/// Berisi tombol 1-9, 000, 0, dan tombol hapus (backspace).
class AppKeypad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onClear;

  const AppKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['000', '0', 'delete'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _KeypadButton(
                    label: key,
                    onTap: () {
                      if (key == 'delete') {
                        onBackspacePressed();
                      } else {
                        onDigitPressed(key);
                      }
                    },
                    onLongPress: key == 'delete' ? onClear : null,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDelete = label == 'delete';

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isDelete
                ? const Icon(
                    AppIcons.backspace,
                    size: 22,
                    color: AppColors.textPrimary,
                  )
                : Text(
                    label,
                    style: AppTypography.title.copyWith(
                      fontSize: label == '000' ? 18 : 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
