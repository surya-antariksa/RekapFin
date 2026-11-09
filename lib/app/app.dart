import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rekap_fin/app/router/app_router.dart';
import 'package:rekap_fin/core/config/env_config.dart';
import 'package:rekap_fin/core/theme/app_theme.dart';

final envConfigProvider = Provider<EnvConfig>((ref) {
  throw UnimplementedError('envConfigProvider must be initialized');
});

class RekapFinApp extends StatelessWidget {
  final EnvConfig config;

  const RekapFinApp({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        envConfigProvider.overrideWithValue(config),
      ],
      child: MaterialApp.router(
        title: 'RekapFin',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: config.flavor != AppFlavor.prod,
        routerConfig: appRouter,
      ),
    );
  }
}
