import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

enum ButtonVariant {
  primary,
  secondary,
}

/// Tombol utama RekapFin sesuai docs/08-design-system.md
/// Dimensi: 350 x 56, radius 16.
/// Varian:
/// - Default (Primary): isi accent-action (#047857), label 16/600 putih, bayangan 0/8 blur 20 (#10B98133)
/// - Disabled: isi #04785766, ikon & label #FFFFFFCC
/// - Pressed: isi #065F46
/// - Loading: ring putih 20 tanpa label
/// - Sekunder: kaca #FFFFFF8C, tepi 1 px #FFFFFFCC, ikon & label accent-action
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double width;
  final double height;
  final ButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width = 350.0,
    this.height = 56.0,
    this.variant = ButtonVariant.primary,
  });

  /// Factory untuk tombol sekunder (gaya kaca)
  const factory PrimaryButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading,
    bool isFullWidth,
    double width,
    double height,
  }) = _SecondaryPrimaryButton;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _SecondaryPrimaryButton extends PrimaryButton {
  const _SecondaryPrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
    super.isLoading = false,
    super.isFullWidth = true,
    super.width = 350.0,
    super.height = 56.0,
  }) : super(variant: ButtonVariant.secondary);
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final isSecondary = widget.variant == ButtonVariant.secondary;

    // Warna latar belakang berdasarkan state
    Color backgroundColor;
    Border? border;
    List<BoxShadow>? boxShadow;
    Color contentColor;

    if (isSecondary) {
      backgroundColor = _isEnabled
          ? (_isPressed ? const Color(0xB3FFFFFF) : AppColors.glassFill)
          : const Color(0x4DFFFFFF);
      border = Border.all(color: AppColors.glassBorder, width: 1.0);
      contentColor = _isEnabled
          ? AppColors.accentAction
          : AppColors.accentAction.withValues(alpha: 0.5);
      boxShadow = null;
    } else {
      // Primary
      if (!_isEnabled) {
        backgroundColor = const Color(0x66047857);
        contentColor = const Color(0xCCFFFFFF);
        boxShadow = null;
      } else if (_isPressed) {
        backgroundColor = const Color(0xFF065F46);
        contentColor = AppColors.textOnAccent;
        boxShadow = null;
      } else {
        backgroundColor = AppColors.accentAction;
        contentColor = AppColors.textOnAccent;
        boxShadow = const [
          BoxShadow(
            color: Color(0x3310B981),
            offset: Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ];
      }
    }

    Widget content;
    if (widget.isLoading) {
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: contentColor,
        ),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: 20,
              color: contentColor,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              widget.label,
              style: AppTypography.subtitle.copyWith(
                color: contentColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.isFullWidth ? widget.width : null,
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.buttonRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isEnabled ? widget.onPressed : null,
          onHighlightChanged: (highlighted) {
            if (_isEnabled) {
              setState(() {
                _isPressed = highlighted;
              });
            }
          },
          borderRadius: AppRadius.buttonRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
