import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: semanticLabel,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.outline,
        foregroundColor: AppColors.onPrimary,
        shape: const CircleBorder(), // Ensures it stays a perfect circle
        padding: const EdgeInsets.all(8), // Adjust size if needed
      ),
      onPressed: onPressed,
      icon: Icon(icon, semanticLabel: semanticLabel),
    );
  }
}
