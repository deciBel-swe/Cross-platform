import 'package:decibel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
class Tile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const Tile({
    super.key,
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, // Updated to AppColors
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary, // Updated to AppColors
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 32,
          child: FilledButton(
            style: FilledButton.styleFrom(
              // Replace 'surface' with whatever you call your dark grey/card color
              backgroundColor: AppColors.surface, 
              foregroundColor: AppColors.textPrimary, // Updated to AppColors
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: const StadiumBorder(),
            ),
            onPressed: onButtonPressed,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}