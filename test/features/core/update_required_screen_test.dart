import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/design_system/primary_button.dart';
import 'package:rekap_fin/features/core/presentation/update_required_screen.dart';

void main() {
  testWidgets('UpdateRequiredScreen renders message and download button',
      (tester) async {
    bool downloadTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: UpdateRequiredScreen(
          currentVersion: '1.0.0',
          minVersion: '2.0.0',
          updateUrl: 'https://drive.google.com/test',
          onDownload: () => downloadTapped = true,
        ),
      ),
    );

    expect(find.text('Perbarui aplikasi'), findsOneWidget);
    expect(find.textContaining('Versi aplikasimu (1.0.0) sudah tidak didukung'),
        findsOneWidget);
    expect(find.text('Unduh versi terbaru'), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    expect(downloadTapped, isTrue);
  });
}
