/// Decibel color palette.
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============ Brand & Accent colors ============

  /// SoundCloud Orange
  static const Color primary = Color(0xFFFF5500);

  /// Used for progress  checklist circle
  static const Color accentPurple = Color(0xFFB388FF);

  /// Used for switches, active toggles, and scheduling icons
  static const Color accentTeal = Colors.tealAccent;

  /// Used for the "Artist Pro" badge and premium hints
  static const Color proBadge = Colors.orange;

  // ============ Background & Surfaces ============

  /// The strict dark theme background
  static const Color background = Color(0xFF121212);
  static const Color onBackground = Colors.black;
  static const Color surface = Color(0xFF1E1E1E);

  /// Used for nested elevated items like input chips
  static const Color surfaceVariant = Color(0xFF2A2A2A);

  /// Backward-compatible darker brand tone for gradients.
  static const Color primaryDark = Color(0xFFE64A00);

  /// Backward-compatible lighter surface token.
  static const Color surfaceLight = surfaceVariant;

  /// Backward-compatible container surface token.
  static const Color surfaceContainer = Color(0xFF242424);

  // ============ Typography & Icons ============

  /// Standard text and active icons
  static const Color onPrimary = Colors.white;

  /// Slightly dimmed text
  static const Color textSecondary = Colors.white70;

  /// Muted labels, Inactive icons
  static const Color textMuted = Colors.white54;

  /// Disabled text, deep placeholders, and disabled icons
  static const Color textHint = Colors.white38;

  // ============ Borders & Dividers ============

  /// Subtle dividers and light borders
  static const Color borderLight = Colors.white24;

  /// Darker borders around main cards (Equivalent to Colors.grey[800])
  static const Color borderDark = Color(0xFF424242);

  // ============  Status Colors ============

  /// Used for form validation errors and maximum limits
  static const Color errors = Colors.redAccent;
  static const Color transparent = Colors.transparent;
  static const Color success = Colors.green;

  // ---- Text hierarchy ----
  static const Color textPrimary = Colors.white;
  //static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF666666);

  // ---- Borders & dividers ----
  static const Color divider = Color(0xFF2A2A2A);
  static const Color outline = Color(0xFF333333);

  // ---- Social brand ----
  static const Color google = Color(0xFF4285F4);
  static const Color facebook = Color(0xFF1877F2);
  static const Color apple = Colors.white;
  static const Color instagram = Colors.pink;
}
