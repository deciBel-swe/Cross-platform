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
  /// Used for elevated cards, BottomSheets, and form containers
  static const Color surface = Color(0xFF1E1E1E);
  /// Used for nested elevated items like input chips
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  
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
}
