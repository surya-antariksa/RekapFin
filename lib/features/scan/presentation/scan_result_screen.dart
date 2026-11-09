import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Hasil Scan Nota', route: '/scan-result');
  }
}
