import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class BudgetEditScreen extends StatelessWidget {
  const BudgetEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Atur Anggaran', route: '/budget-edit');
  }
}
