import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class DebtOffsetScreen extends StatelessWidget {
  const DebtOffsetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Konfirmasi Saling Hapus', route: '/debt-offset');
  }
}
