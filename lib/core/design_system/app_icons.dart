import 'package:flutter/material.dart';

/// Pemetaan ikon RekapFin sesuai docs/08-design-system.md
/// Menggunakan ikon standar Flutter (rounded/outline) yang selaras dengan spesifikasi Lucide.
class AppIcons {
  // Navigasi bawah (ukuran 22)
  static const IconData navHome = Icons.home_rounded;
  static const IconData navTransactions = Icons.swap_horiz_rounded;
  static const IconData navBudget = Icons.savings_outlined;
  static const IconData navAnalytics = Icons.pie_chart_outline_rounded;
  static const IconData navProfile = Icons.person_outline_rounded;

  // Aksi & Tombol
  static const IconData add = Icons.add_rounded;
  static const IconData trendingUp = Icons.trending_up_rounded;
  static const IconData tanyaAi = Icons.auto_awesome_rounded;
  static const IconData scan = Icons.qr_code_scanner_rounded;
  static const IconData transfer = Icons.swap_horiz_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData chevronDown = Icons.keyboard_arrow_down_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData backspace = Icons.backspace_outlined;

  // Visibilitas & Notifikasi
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData notification = Icons.notifications_none_rounded;

  // Peringatan & Status
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_outline_rounded;

  // Dompet & Pembayaran
  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData bank = Icons.account_balance_rounded;
  static const IconData cash = Icons.payments_outlined;
  static const IconData eWallet = Icons.phone_android_rounded;

  // Kategori & Transaksi
  static const IconData shoppingBag = Icons.shopping_bag_outlined;
  static const IconData food = Icons.restaurant_rounded;
  static const IconData transport = Icons.directions_car_rounded;
  static const IconData salary = Icons.payments_rounded;
  static const IconData investment = Icons.trending_up_rounded;
}
