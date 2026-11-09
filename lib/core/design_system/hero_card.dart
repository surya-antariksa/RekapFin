import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/money/rupiah.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Kartu Hero Total Saldo RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Lebar: 350, padding: 24, radius: 24
/// - Gradien linear rotasi 225°: hero-start (#047857) ke hero-end (#078761)
/// - Garis tepi: 1 px hero-border (#FFFFFF80)
/// - Bayangan luar: 0/8, blur 32, hero-shadow (#10B98140)
/// - Label: 14/600 text-on-accent-muted (#FFFFFFCC)
/// - Nilai: 36/800 putih (AppTypography.display, text-on-accent)
/// - Keterangan: 12/500 dengan ikon trending-up 16
/// - Ikon mata untuk menyembunyikan/menampilkan saldo
class HeroCard extends StatefulWidget {
  final int totalBalance;
  final String label;
  final String? subtitle;
  final bool initialBalanceVisible;
  final ValueChanged<bool>? onVisibilityChanged;

  const HeroCard({
    super.key,
    required this.totalBalance,
    this.label = 'Total Saldo',
    this.subtitle,
    this.initialBalanceVisible = true,
    this.onVisibilityChanged,
  });

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> {
  late bool _isBalanceVisible;

  @override
  void initState() {
    super.initState();
    _isBalanceVisible = widget.initialBalanceVisible;
  }

  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
    widget.onVisibilityChanged?.call(_isBalanceVisible);
  }

  @override
  Widget build(BuildContext context) {
    final formattedBalance = _isBalanceVisible
        ? Rupiah.formatAmount(widget.totalBalance)
        : '••••••••';

    return Container(
      width: 350,
      decoration: const BoxDecoration(
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.heroShadow,
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
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.heroStart,
                  AppColors.heroEnd,
                ],
              ),
              borderRadius: AppRadius.cardRadius,
              border: Border.all(
                color: AppColors.heroBorder,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris Label + Ikon Mata
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.label,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textOnAccentMuted,
                      ),
                    ),
                    InkWell(
                      onTap: _toggleVisibility,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          _isBalanceVisible
                              ? AppIcons.visibility
                              : AppIcons.visibilityOff,
                          size: 20,
                          color: AppColors.textOnAccentMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Nilai Saldo
                Text(
                  formattedBalance,
                  style: AppTypography.display.copyWith(
                    color: AppColors.textOnAccent,
                  ),
                ),

                // Keterangan / Tren
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        AppIcons.trendingUp,
                        size: 16,
                        color: AppColors.textOnAccent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.subtitle!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textOnAccentMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
