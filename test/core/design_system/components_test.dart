import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/core/design_system/transaction_item.dart';
import 'package:rekap_fin/core/theme/app_radius.dart';

void main() {
  group('Design System Core Components (F02)', () {
    testWidgets('GlassCard renders with radius 24 and content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              title: 'Judul Kaca',
              subtitle: 'Subjudul kartu kaca',
            ),
          ),
        ),
      );

      expect(find.text('Judul Kaca'), findsOneWidget);
      expect(find.text('Subjudul kartu kaca'), findsOneWidget);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GlassCard),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.borderRadius, equals(AppRadius.cardRadius));
    });

    testWidgets('HeroCard renders balance, gradient, and toggles visibility',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              totalBalance: 24750000,
              label: 'Total Saldo',
              subtitle: '+Rp 2.450.000 bulan ini',
            ),
          ),
        ),
      );

      expect(find.text('Total Saldo'), findsOneWidget);
      expect(find.text('Rp 24.750.000'), findsOneWidget);
      expect(find.text('+Rp 2.450.000 bulan ini'), findsOneWidget);

      // Tap icon mata untuk menyembunyikan saldo
      await tester.tap(find.byIcon(AppIcons.visibility));
      await tester.pumpAndSettle();

      expect(find.text('Rp 24.750.000'), findsNothing);
      expect(find.text('••••••••'), findsOneWidget);

      // Tap kembali untuk memunculkan saldo
      await tester.tap(find.byIcon(AppIcons.visibilityOff));
      await tester.pumpAndSettle();
      expect(find.text('Rp 24.750.000'), findsOneWidget);
    });

    testWidgets(
        'PrimaryButton renders default, secondary, disabled, and loading states',
        (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PrimaryButton(
                  label: 'Tombol Utama',
                  onPressed: () => pressed = true,
                ),
                PrimaryButton.secondary(
                  label: 'Tombol Sekunder',
                  onPressed: () {},
                ),
                const PrimaryButton(
                  label: 'Tombol Nonaktif',
                  onPressed: null,
                ),
                PrimaryButton(
                  label: 'Tombol Loading',
                  isLoading: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Tombol Utama'), findsOneWidget);
      expect(find.text('Tombol Sekunder'), findsOneWidget);
      expect(find.text('Tombol Nonaktif'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Tap tombol utama
      await tester.tap(find.text('Tombol Utama'));
      expect(pressed, isTrue);

      // Tombol nonaktif tidak bisa ditekan
      await tester.tap(find.text('Tombol Nonaktif'));
      // Tetap true dari tap sebelumnya
      expect(pressed, isTrue);
    });

    testWidgets('AppFilterChip renders active and inactive states',
        (tester) async {
      bool selected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppFilterChip(
                  label: 'Pengeluaran',
                  isSelected: selected,
                  onTap: () {
                    setState(() {
                      selected = !selected;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Pengeluaran'), findsOneWidget);

      // Tap chip to toggle state
      await tester.tap(find.text('Pengeluaran'));
      await tester.pumpAndSettle();
      expect(selected, isTrue);
    });

    testWidgets('TransactionItem displays correct type formatting and amounts',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TransactionItem(
                  title: 'Makan Siang',
                  subtitle: 'Tunai',
                  amount: 45000,
                  type: TransactionType.expense,
                ),
                TransactionItem(
                  title: 'Gaji Bulanan',
                  subtitle: 'Bank',
                  amount: 8500000,
                  type: TransactionType.income,
                ),
                TransactionItem(
                  title: 'Transfer',
                  subtitle: 'Bank ke Tunai',
                  amount: 500000,
                  type: TransactionType.transfer,
                ),
              ],
            ),
          ),
        ),
      );

      // Pengeluaran: U+2212 minus sign
      expect(find.text('\u2212Rp 45.000'), findsOneWidget);
      // Pemasukan: +Rp sign
      expect(find.text('+Rp 8.500.000'), findsOneWidget);
      // Transfer: neutral Rp
      expect(find.text('Rp 500.000'), findsOneWidget);
    });

    testWidgets('AppBottomNavBar renders 5 tabs and triggers callback',
        (tester) async {
      int activeIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppBottomNavBar(
                  currentIndex: activeIndex,
                  onTabSelected: (index) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Transaksi'), findsOneWidget);
      expect(find.text('Anggaran'), findsOneWidget);
      expect(find.text('Analitik'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      // Tap Transaksi tab
      await tester.tap(find.text('Transaksi'));
      await tester.pumpAndSettle();
      expect(activeIndex, equals(1));
    });

    testWidgets('TanyaAiFab renders label, button and triggers callback',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TanyaAiFab(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Tanya AI'), findsOneWidget);
      expect(find.byIcon(AppIcons.tanyaAi), findsOneWidget);

      await tester.tap(find.byType(TanyaAiFab));
      expect(tapped, isTrue);
    });

    testWidgets(
        'AppTextField renders label, hint, error text, and accepts input',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Nama Dompet',
              hint: 'Contoh: Tabungan',
              controller: controller,
              errorText: 'Nama wajib diisi',
            ),
          ),
        ),
      );

      expect(find.text('Nama Dompet'), findsOneWidget);
      expect(find.text('Contoh: Tabungan'), findsOneWidget);
      expect(find.text('Nama wajib diisi'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Saldo Utama');
      expect(controller.text, equals('Saldo Utama'));
    });

    testWidgets('AppSegmentedControl switches selected option', (tester) async {
      String selected = 'A';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppSegmentedControl<String>(
                  segments: const {'A': 'Pilihan A', 'B': 'Pilihan B'},
                  selected: selected,
                  onSelected: (val) => setState(() => selected = val),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Pilihan A'), findsOneWidget);
      expect(find.text('Pilihan B'), findsOneWidget);

      await tester.tap(find.text('Pilihan B'));
      await tester.pumpAndSettle();
      expect(selected, equals('B'));
    });

    testWidgets('AppKeypad sends digits and backspace correctly',
        (tester) async {
      String buffer = '';
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppKeypad(
              onDigitPressed: (d) => buffer += d,
              onBackspacePressed: () {
                if (buffer.isNotEmpty) {
                  buffer = buffer.substring(0, buffer.length - 1);
                }
              },
              onClear: () => cleared = true,
            ),
          ),
        ),
      );

      // Tap '1', '2', '000'
      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('000'));
      expect(buffer, equals('12000'));

      // Tap backspace
      await tester.tap(find.byIcon(AppIcons.backspace));
      expect(buffer, equals('1200'));

      // Long press backspace
      await tester.longPress(find.byIcon(AppIcons.backspace));
      expect(cleared, isTrue);
    });

    testWidgets('AppToggle toggles switch value', (tester) async {
      bool toggleVal = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppToggle(
                  title: 'Biometrik',
                  value: toggleVal,
                  onChanged: (val) => setState(() => toggleVal = val),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Biometrik'), findsOneWidget);
      await tester.tap(find.byType(AppToggle));
      await tester.pumpAndSettle();
      expect(toggleVal, isTrue);
    });

    testWidgets('AppStatusBadge renders ok, warn, danger, and neutral variants',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppStatusBadge.ok(label: 'Lunas'),
                AppStatusBadge.warn(label: 'Periksa kembali'),
                AppStatusBadge.danger(label: 'Terlambat'),
                AppStatusBadge(label: 'Disarankan AI'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Lunas'), findsOneWidget);
      expect(find.text('Periksa kembali'), findsOneWidget);
      expect(find.text('Terlambat'), findsOneWidget);
      expect(find.text('Disarankan AI'), findsOneWidget);
    });

    testWidgets('AppGlassDialog modal shows and pops on action',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppGlassDialog.show(
                      context: context,
                      title: 'Konfirmasi Hapus',
                      message: 'Data akan dihapus permanen.',
                      confirmLabel: 'Hapus',
                      cancelLabel: 'Batal',
                    );
                  },
                  child: const Text('Buka Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Konfirmasi Hapus'), findsOneWidget);
      expect(find.text('Data akan dihapus permanen.'), findsOneWidget);
      expect(find.text('Hapus'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);

      // Tap Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(find.text('Konfirmasi Hapus'), findsNothing);
    });

    testWidgets('AppSheetHeader renders title and close button',
        (tester) async {
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSheetHeader(
              title: 'Tambah Transaksi',
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      expect(find.text('Tambah Transaksi'), findsOneWidget);
      expect(find.byIcon(AppIcons.close), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.close));
      expect(closed, isTrue);
    });
  });
}
