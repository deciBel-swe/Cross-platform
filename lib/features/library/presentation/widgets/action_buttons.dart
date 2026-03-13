import 'package:flutter/material.dart';
import 'package:decibel/core/theme/app_colors.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints:
              const BoxConstraints(), // Better than minimumSize: Size.zero
          onPressed: () {},
          color: AppColors.textTertiary,
          iconSize: 29,
          icon: const Icon(Icons.edit_outlined),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          color: AppColors.textTertiary,
          iconSize: 29,
          icon: const Icon(Icons.shuffle),
        ),
        IconButton(
          iconSize: 60,
          onPressed: () {},
          icon: const Icon(Icons.play_circle_fill),
        ),
      ],
    );
  }
}
