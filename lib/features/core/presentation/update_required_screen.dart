import 'package:flutter/material.dart';
import 'package:rekap_fin/features/core/presentation/placeholder_screen.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
        title: 'Perbarui Aplikasi', route: '/update-required');
  }
}
