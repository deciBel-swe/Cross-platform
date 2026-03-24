/// App-wide text styles.
library;

import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  /// App name / hero display text (32sp bold).
  static const TextStyle displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  /// Screen-level heading (24sp bold).
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// Tagline / subtitle (16sp regular).
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB3B3B3),
  );

  /// Primary button label (16sp semibold).
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Standard body text (14sp regular).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB3B3B3),
  );

  /// Small / legal text (12sp regular).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );

  // ---- Desktop-specific ----

  /// Sidebar navigation item label (13sp medium).
  static const TextStyle sidebarItem = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFFB3B3B3),
  );

  /// Desktop section heading (20sp bold).
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// Track / playlist card title (14sp semibold).
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Card subtitle – artist name, metadata (12sp regular).
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB3B3B3),
  );
}
