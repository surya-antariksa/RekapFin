import 'package:flutter/material.dart';
import 'package:rekap_fin/core/design_system/app_bottom_nav_bar.dart';
import 'package:rekap_fin/core/design_system/app_filter_chip.dart';
import 'package:rekap_fin/core/design_system/app_glass_dialog.dart';
import 'package:rekap_fin/core/design_system/app_icons.dart';
import 'package:rekap_fin/core/design_system/app_keypad.dart';
import 'package:rekap_fin/core/design_system/app_segmented_control.dart';
import 'package:rekap_fin/core/design_system/app_sheet_header.dart';
import 'package:rekap_fin/core/design_system/app_status_badge.dart';
import 'package:rekap_fin/core/design_system/app_text_field.dart';
import 'package:rekap_fin/core/design_system/app_toggle.dart';
import 'package:rekap_fin/core/design_system/glass_card.dart';
import 'package:rekap_fin/core/design_system/hero_card.dart';
import 'package:rekap_fin/core/design_system/primary_button.dart';
import 'package:rekap_fin/core/design_system/rekapfin_background.dart';
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/core/design_system/transaction_item.dart';
import 'package:rekap_fin/core/money/rupiah.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';
import 'package:rekap_fin/core/theme/app_spacing.dart';
import 'package:rekap_fin/core/theme/app_typography.dart';

/// Halaman Katalog Komponen RekapFin untuk verifikasi visual, golden test, dan audit token
class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({super.key});

  @override
  State<ComponentCatalogScreen> createState() => _ComponentCatalogScreenState();
}

class _ComponentCatalogScreenState extends State<ComponentCatalogScreen> {
  int _selectedChipIndex = 0;
  int _bottomNavIndex = 0;
  String _selectedSegment = 'expense';
  bool _toggleValue = true;
  String _keypadOutput = '0';
  final TextEditingController _textController =
      TextEditingController(text: 'rizky@email.com');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    setState(() {
      if (_keypadOutput == '0') {
        _keypadOutput = digit;
      } else if (_keypadOutput.length < 12) {
        _keypadOutput += digit;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_keypadOutput.length > 1) {
        _keypadOutput = _keypadOutput.substring(0, _keypadOutput.length - 1);
      } else {
        _keypadOutput = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RekapFinBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Konten scrollable dengan padding bawah 160 px sesuai docs/08
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.screenPadding,
                  right: AppSpacing.screenPadding,
                  top: AppSpacing.md,
                  bottom: AppSpacing.scrollBottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Katalog
                    const Text(
                      'Katalog Komponen',
                      style: AppTypography.pageTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Design System RekapFin (Plus Jakarta Sans, iOS Glassmorphism)',
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 1: Hero Card
                    _buildSectionHeader('1. Kartu Hero (Total Saldo)'),
                    const SizedBox(height: AppSpacing.xs),
                    const HeroCard(
                      totalBalance: 24750000,
                      label: 'Total Saldo',
                      subtitle: '+Rp 2.450.000 bulan ini',
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 2: GlassCard
                    _buildSectionHeader('2. GlassCard'),
                    const SizedBox(height: AppSpacing.xs),
                    GlassCard(
                      title: 'Ringkasan Dompet',
                      subtitle:
                          'Tiga dompet aktif tersambung: Saldo Utama, Tunai, dan E-wallet.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ringkasan Dompet',
                            style: AppTypography.title.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Saldo Utama: ${Rupiah.formatAmount(18500000)}',
                            style: AppTypography.bodyRegular,
                          ),
                          Text(
                            'Tunai: ${Rupiah.formatAmount(1250000)}',
                            style: AppTypography.bodyRegular,
                          ),
                          Text(
                            'E-wallet: ${Rupiah.formatAmount(5000000)}',
                            style: AppTypography.bodyRegular,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 3: Filter Chip
                    _buildSectionHeader('3. FilterChip (Pil radius 999)'),
                    const SizedBox(height: AppSpacing.xs),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AppFilterChip(
                            label: 'Semua',
                            isSelected: _selectedChipIndex == 0,
                            onTap: () => setState(() => _selectedChipIndex = 0),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Pengeluaran',
                            isSelected: _selectedChipIndex == 1,
                            onTap: () => setState(() => _selectedChipIndex = 1),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Pemasukan',
                            isSelected: _selectedChipIndex == 2,
                            onTap: () => setState(() => _selectedChipIndex = 2),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Transfer',
                            isSelected: _selectedChipIndex == 3,
                            onTap: () => setState(() => _selectedChipIndex = 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 4: PrimaryButton & Varian
                    _buildSectionHeader(
                        '4. PrimaryButton (350 x 56, radius 16)'),
                    const SizedBox(height: AppSpacing.xs),
                    PrimaryButton(
                      label: 'Simpan Transaksi',
                      icon: AppIcons.add,
                      onPressed: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton.secondary(
                      label: 'Tombol Sekunder (Kaca)',
                      icon: AppIcons.edit,
                      onPressed: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const PrimaryButton(
                      label: 'Tombol Nonaktif (Disabled)',
                      onPressed: null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      label: 'Memproses...',
                      isLoading: true,
                      onPressed: () {},
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 5: TransactionItem
                    _buildSectionHeader('5. TransactionItem'),
                    const SizedBox(height: AppSpacing.xs),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          TransactionItem(
                            title: 'Makan Siang & Kopi',
                            subtitle: 'Saldo Utama • Hari Ini',
                            amount: 45000,
                            type: TransactionType.expense,
                            sourceLabel: 'manual',
                            showChevron: true,
                            onTap: () {},
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.glassBorder,
                          ),
                          TransactionItem(
                            title: 'Gaji Bulanan',
                            subtitle: 'Saldo Utama • 1 Nov',
                            amount: 8500000,
                            type: TransactionType.income,
                            sourceLabel: 'manual',
                            showChevron: true,
                            onTap: () {},
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.glassBorder,
                          ),
                          TransactionItem(
                            title: 'Transfer ke Tunai',
                            subtitle: 'Bank → Tunai • 3 Nov',
                            amount: 500000,
                            type: TransactionType.transfer,
                            showChevron: true,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 6: Pola Umum (Input, Segmented, Toggle, Header, Badge, Keypad)
                    _buildSectionHeader('6. Pola Umum Reusable'),
                    const SizedBox(height: AppSpacing.xs),

                    // Segmented Control
                    AppSegmentedControl<String>(
                      segments: const {
                        'expense': 'Pengeluaran',
                        'income': 'Pemasukan',
                      },
                      selected: _selectedSegment,
                      onSelected: (val) =>
                          setState(() => _selectedSegment = val),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Text Field
                    AppTextField(
                      label: 'Email Pengguna',
                      hint: 'masukkan email...',
                      controller: _textController,
                      prefix: const Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const AppTextField(
                      label: 'Contoh Field Error',
                      hint: 'kata sandi',
                      errorText:
                          'Format email tidak valid atau belum terdaftar.',
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Toggle
                    AppToggle(
                      title: 'Masuk dengan Biometrik',
                      subtitle:
                          'Buka sesi tersimpan dengan sidik jari atau wajah.',
                      value: _toggleValue,
                      onChanged: (val) => setState(() => _toggleValue = val),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Sheet Header
                    AppSheetHeader(
                      title: 'Contoh Header Sheet',
                      onClose: () {},
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Status Badges
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppStatusBadge.ok(label: 'Lunas'),
                        AppStatusBadge.warn(label: 'Periksa kembali'),
                        AppStatusBadge.danger(label: 'Terlambat'),
                        AppStatusBadge(label: 'Disarankan AI'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Keypad Showcase
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Nominal Input:',
                                style: AppTypography.caption,
                              ),
                              Text(
                                Rupiah.formatAmount(
                                  int.tryParse(_keypadOutput) ?? 0,
                                ),
                                style: AppTypography.title.copyWith(
                                  color: AppColors.accentAction,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AppKeypad(
                            onDigitPressed: _onDigit,
                            onBackspacePressed: _onBackspace,
                            onClear: () => setState(() => _keypadOutput = '0'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Glass Dialog Trigger
                    PrimaryButton.secondary(
                      label: 'Buka Dialog Kaca Konfirmasi',
                      onPressed: () {
                        AppGlassDialog.show(
                          context: context,
                          title: 'Konfirmasi Tindakan',
                          message:
                              'Apakah kamu yakin ingin melanjutkan tindakan ini? Data akan disimpan secara permanen.',
                          confirmLabel: 'Lanjutkan',
                          cancelLabel: 'Batal',
                          icon: AppIcons.info,
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Fixed Tanya AI (x=240, y=684)
              Positioned(
                left: TanyaAiFab.widgetX,
                top: TanyaAiFab.widgetY,
                child: TanyaAiFab(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tanya AI disentuh'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),

              // Fixed BottomNavBar (350 x 68 di x=20, y=752)
              Positioned(
                left: 20,
                top: 752,
                child: AppBottomNavBar(
                  currentIndex: _bottomNavIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _bottomNavIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.title.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
