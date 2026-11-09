import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/design_system/app_filter_chip.dart';
import 'package:rekap_fin/core/design_system/hero_card.dart';
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/features/core/presentation/component_catalog_screen.dart';

void main() {
  testWidgets(
      'ComponentCatalogScreen renders without overflow and supports interaction',
      (tester) async {
    // Set standard viewport size 390 x 844
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: ComponentCatalogScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Pastikan judul halaman katalog tampil
    expect(find.text('Katalog Komponen'), findsOneWidget);

    // Pastikan HeroCard dan TanyaAiFab ter-render
    expect(find.byType(HeroCard), findsOneWidget);
    expect(find.byType(TanyaAiFab), findsOneWidget);

    // Filter chip interaksi
    expect(find.text('Pengeluaran'), findsWidgets);
    await tester.tap(find.widgetWithText(AppFilterChip, 'Pengeluaran'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Scroll ke bawah untuk memastikan tidak ada overflow
    await tester.drag(
        find.byType(SingleChildScrollView).first, const Offset(0, -500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Pastikan keypad atau elemen bawah muncul
    expect(find.text('Nominal Input:'), findsOneWidget);
  });
}
