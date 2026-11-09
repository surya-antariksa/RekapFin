import 'package:flutter/material.dart';

/// Radius border RekapFin sesuai docs/08-design-system.md
class AppRadius {
  static const double card = 24.0;
  static const double button = 16.0;
  static const double chip = 999.0; // pil
  static const double nav = 34.0;

  static const BorderRadius cardRadius =
      BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(button));
  static const BorderRadius chipRadius =
      BorderRadius.all(Radius.circular(chip));
  static const BorderRadius navRadius = BorderRadius.all(Radius.circular(nav));
}
