import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class DebtNetScreen extends StatelessWidget {
  const DebtNetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Saldo Bersih Hutang/Piutang', route: '/debt-net');
  }
}
