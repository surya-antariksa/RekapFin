import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class AddInvestmentScreen extends StatelessWidget {
  const AddInvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Tambah Investasi', route: '/add-investment');
  }
}
