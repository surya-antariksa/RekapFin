import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class InvestmentDetailScreen extends StatelessWidget {
  const InvestmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Detail Investasi', route: '/investment-detail');
  }
}
