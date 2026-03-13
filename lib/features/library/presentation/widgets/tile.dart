import 'package:decibel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:decibel/core/constants/app_constants.dart';
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
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, 
                ),
              ),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppColors.textSecondary, 
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
              backgroundColor: AppColors.surface, 
              foregroundColor: AppColors.textPrimary, 
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: const StadiumBorder(),
            ),
            onPressed: onButtonPressed,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}