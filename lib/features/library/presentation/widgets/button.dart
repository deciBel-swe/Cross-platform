import 'package:flutter/material.dart';
import 'package:decibel/core/theme/app_colors.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.outline,
        foregroundColor: AppColors.onPrimary,
        shape: const CircleBorder(), // Ensures it stays a perfect circle
        padding: const EdgeInsets.all(8), // Adjust size if needed
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
