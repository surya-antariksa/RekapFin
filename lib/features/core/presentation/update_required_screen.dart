import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/primary_button.dart';
import 'package:rekap_fin/core/design_system/rekapfin_background.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_spacing.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';
import 'package:rekap_fin/core/version/app_config.dart';

/// Layar Perbarui Aplikasi (/update-required) sesuai docs/03, docs/11, & T-MIG-03
/// Ditampilkan bila versi aplikasi pengguna di bawah min_app_version
class UpdateRequiredScreen extends StatelessWidget {
  final String updateUrl;
  final String currentVersion;
  final String minVersion;
  final VoidCallback? onDownload;

  const UpdateRequiredScreen({
    super.key,
    this.updateUrl = 'https://drive.google.com',
    this.currentVersion = AppVersionChecker.currentAppVersion,
    this.minVersion = '1.0.0',
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RekapFinBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Ikon Unduh dalam lingkaran 64 px
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.incomeSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    size: 32,
                    color: AppColors.accentAction,
                  ),
                ),
                const SizedBox(height: 24),

                // Judul Halaman 28 px Bold
                const Text(
                  'Perbarui aplikasi',
                  style: AppTypography.pageTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Keterangan 14 px
                Text(
                  'Versi aplikasimu ($currentVersion) sudah tidak didukung. Unduh versi terbaru ($minVersion atau lebih tinggi) lalu pasang untuk melanjutkan.',
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Tombol Primer 350 x 56
                PrimaryButton(
                  label: 'Unduh versi terbaru',
                  icon: Icons.download_rounded,
                  onPressed: onDownload ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Membuka tautan unduhan: $updateUrl'),
                          ),
                        );
                      },
                ),
                const SizedBox(height: AppSpacing.safeBottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
