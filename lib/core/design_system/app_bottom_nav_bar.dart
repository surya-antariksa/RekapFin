import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Item navigasi tunggal di dalam AppBottomNavBar
class NavItemData {
  final IconData icon;
  final String label;
  final String route;

  const NavItemData({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// Bilah navigasi bawah kaca (Glassmorphism) RekapFin sesuai docs/08-design-system.md
/// Spesifikasi:
/// - Wadah: 350 x 68, radius 34 (AppRadius.navRadius), padding 6
/// - Fill: glass-nav-fill (#FFFFFFA6), border: 1 px (#FFFFFFCC), blur: 40 (sigma 20)
/// - Bayangan: 0/8 blur 32 glass-shadow (#0F172A14)
/// - 5 tab: Beranda, Transaksi, Anggaran, Analitik, Profil
/// - Mendukung tanpa tab aktif (currentIndex = -1) untuk /debts dan /investments
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<NavItemData>? items;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.items,
  });

  static const List<NavItemData> defaultItems = [
    NavItemData(
      icon: AppIcons.navHome,
      label: 'Beranda',
      route: '/home',
    ),
    NavItemData(
      icon: AppIcons.navTransactions,
      label: 'Transaksi',
      route: '/transactions',
    ),
    NavItemData(
      icon: AppIcons.navBudget,
      label: 'Anggaran',
      route: '/budget',
    ),
    NavItemData(
      icon: AppIcons.navAnalytics,
      label: 'Analitik',
      route: '/analytics',
    ),
    NavItemData(
      icon: AppIcons.navProfile,
      label: 'Profil',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? defaultItems;

    return Container(
      width: 350,
      height: 68,
      decoration: const BoxDecoration(
        borderRadius: AppRadius.navRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            offset: Offset(0, 8),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.navRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppColors.glassNavFill,
              borderRadius: AppRadius.navRadius,
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isActive = index == currentIndex;

                return _NavItemWidget(
                  item: item,
                  isActive: isActive,
                  onTap: () => onTabSelected(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // NavItem: ukuran responsif dalam bar (lebar maks ~80, tinggi 56), radius 28
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: isActive ? AppColors.navActiveFill : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: AppColors.glassShadow,
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color:
                      isActive ? AppColors.accentAction : AppColors.textMuted,
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.micro.copyWith(
                    color:
                        isActive ? AppColors.accentAction : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
