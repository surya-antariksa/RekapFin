import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Detail Hutang/Piutang', route: '/debt-detail');
  }
}
