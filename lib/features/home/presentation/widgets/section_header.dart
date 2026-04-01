/// Reusable section header — title on the left, "See all" on the right.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Displays a section title with an optional "See all" action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (onSeeAll != null) _SeeAllButton(onPressed: onSeeAll!),
      ],
    );
  }
}

class _SeeAllButton extends StatefulWidget {
  const _SeeAllButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_SeeAllButton> createState() => _SeeAllButtonState();
}

class _SeeAllButtonState extends State<_SeeAllButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Text(
          'See all',
          style: AppTextStyles.bodyMedium.copyWith(
            color: _isHovered ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
