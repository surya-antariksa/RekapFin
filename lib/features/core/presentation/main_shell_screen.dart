import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rekap_fin/core/design_system/app_bottom_nav_bar.dart';
import 'package:rekap_fin/core/design_system/rekapfin_background.dart';
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/core/theme/app_spacing.dart';

/// Kerangka navigasi utama (Shell Route) 5 tab RekapFin sesuai docs/08 & docs/03
class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RekapFinBackground(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Konten tab yang sedang aktif
            Positioned.fill(
              child: navigationShell,
            ),

            // Tombol Tanya AI melayang tetap (Fixed) di koordinat (x=240, y=684)
            // Jarak dari batas bawah: 844 - 684 - 52 = 108 px
            Positioned(
              right: 20,
              bottom: 108,
              child: TanyaAiFab(
                onTap: () => context.push('/chat'),
              ),
            ),

            // Bilah Navigasi Bawah tetap (Fixed 350 x 68) di y=752
            // Jarak dari batas bawah: 844 - 752 - 68 = 24 px (safe-bottom)
            Positioned(
              bottom: AppSpacing.safeBottom,
              child: AppBottomNavBar(
                currentIndex: navigationShell.currentIndex,
                onTabSelected: _onTabSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
