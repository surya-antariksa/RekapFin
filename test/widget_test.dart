import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/app/app.dart';
import 'package:rekap_fin/core/config/env_config.dart';

void main() {
  testWidgets('App smoke test loads initial shell and HomeScreen',
      (WidgetTester tester) async {
    const config = EnvConfig(
      flavor: AppFlavor.dev,
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    await tester.pumpWidget(const RekapFinApp(config: config));
    await tester.pumpAndSettle();

    // Verify Beranda route and placeholder are displayed
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Route: /home'), findsOneWidget);
    expect(find.text('Tanya AI'), findsOneWidget);
  });
}
