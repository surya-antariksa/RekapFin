import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rekap_fin/core/theme/app_colors.dart';

/// Komponen Latar RekapFin dengan efek glassmorphism dan blur blob emerald
class RekapFinBackground extends StatelessWidget {
  final Widget child;

  const RekapFinBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Latar dasar bg-base
        Container(
          color: AppColors.bgBase,
        ),

        // Blob 1: emerald-deep di pojok kanan atas
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobEmeraldDeep,
            ),
          ),
        ),

        // Blob 2: emerald-light di kiri tengah
        Positioned(
          top: 280,
          left: -80,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobEmeraldLight,
            ),
          ),
        ),

        // Blob 3: mint di kanan bawah
        Positioned(
          bottom: 40,
          right: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobMint,
            ),
          ),
        ),

        // Efek blur menyeluruh
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
          child: Container(
            color: Colors.transparent,
          ),
        ),

        // Konten utama aplikasi
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}

