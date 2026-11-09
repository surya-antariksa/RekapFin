import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class ScanInvestmentResultScreen extends StatelessWidget {
  const ScanInvestmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Hasil Scan Investasi', route: '/scan-investment-result');
  }
}
