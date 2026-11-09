import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class DebtPaymentScreen extends StatelessWidget {
  const DebtPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Catat Pembayaran Hutang', route: '/debt-payment');
  }
}
