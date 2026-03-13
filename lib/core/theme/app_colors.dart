/// Decibel color palette.
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---- Brand ----
  static const Color primary = Color(0xFFFF5500);
  static const Color background = Color(0xFF121212);
  static const Color onBackground = Colors.black;
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onPrimary = Colors.white;
  static const Color transparent = Colors.transparent;

  // ---- Text hierarchy ----
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF666666);

  // ---- Borders & dividers ----
  static const Color divider = Color(0xFF2A2A2A);
  static const Color outline = Color(0xFF333333);

  // ---- Social brand ----
  static const Color google = Color(0xFF4285F4);
  static const Color facebook = Color(0xFF1877F2);
  static const Color apple = Colors.white;
}
