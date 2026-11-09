import 'package:flutter/material.dart';
import 'package:rekap_fin/app/app.dart';
import 'package:rekap_fin/core/config/env_config.dart';
import 'package:rekap_fin/core/supabase/supabase_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = EnvConfig.fromEnvironment(AppFlavor.prod);
  await SupabaseInitializer.init(config);
  runApp(RekapFinApp(config: config));
}
