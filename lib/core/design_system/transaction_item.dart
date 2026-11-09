import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/money/rupiah.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

enum TransactionType {
  expense,
  income,
  transfer,
}

/// Item baris transaksi RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Lebar: 318 (atau memenuhi kontainer), padding vertikal: 8, gap: 12
/// - Bubble ikon 44 lingkaran (expense-soft / income-soft)
/// - Judul: 14/600 text-primary
/// - Keterangan: 12/500 text-secondary
/// - Nominal: 14/700 rata kanan (expense: −Rp n, income: +Rp n, transfer: Rp n)
/// - Mendukung label sumber (badge) & chevron navigasi
class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final int amount;
  final TransactionType type;
  final IconData? icon;
  final String? sourceLabel;
  final bool showChevron;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    this.icon,
    this.sourceLabel,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bubbleColor;
    Color iconColor;
    Color amountColor;
    String formattedAmount;
    IconData defaultIcon;

    switch (type) {
      case TransactionType.expense:
        bubbleColor = AppColors.expenseSoft;
        iconColor = AppColors.expense;
        amountColor = AppColors.expense;
        // U+2212 minus sign
        formattedAmount =
            '${Rupiah.minusSign}${Rupiah.formatAmount(amount.abs())}';
        defaultIcon = AppIcons.shoppingBag;
        break;
      case TransactionType.income:
        bubbleColor = AppColors.incomeSoft;
        iconColor = AppColors.income;
        amountColor = AppColors.income;
        formattedAmount = '+${Rupiah.formatAmount(amount.abs())}';
        defaultIcon = AppIcons.salary;
        break;
      case TransactionType.transfer:
        bubbleColor = AppColors.incomeSoft;
        iconColor = AppColors.accentAction;
        amountColor = AppColors.textPrimary;
        formattedAmount = Rupiah.formatAmount(amount.abs());
        defaultIcon = AppIcons.transfer;
        break;
    }

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Bubble 44 lingkaran
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bubbleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? defaultIcon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),

          // Judul, Keterangan & Label Sumber
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sourceLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.glassFill,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          sourceLabel!,
                          style: AppTypography.micro.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Nominal Rata Kanan
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedAmount,
                textAlign: TextAlign.right,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
            ],
          ),

          if (showChevron) ...[
            const SizedBox(width: 6),
            const Icon(
              AppIcons.chevronRight,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }

    return content;
  }
}
