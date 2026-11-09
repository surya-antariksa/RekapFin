import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/app/router/app_router.dart';
import 'package:rekap_fin/core/design_system/app_bottom_nav_bar.dart';
import 'package:rekap_fin/core/design_system/tanya_ai_fab.dart';
import 'package:rekap_fin/features/chat/presentation/chat_screen.dart';

void main() {
  testWidgets('MainShellScreen renders bottom nav and Tanya AI FAB',
      (tester) async {
    final router = createAppRouter(initialLocation: '/home');

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.byType(TanyaAiFab), findsOneWidget);

    // Verifikasi navigasi ke tab Transaksi
    await tester.tap(find.text('Transaksi'));
    await tester.pumpAndSettle();

    // Verifikasi tap Tanya AI membawa ke /chat
    await tester.tap(find.byType(TanyaAiFab));
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsOneWidget);
  });
}
