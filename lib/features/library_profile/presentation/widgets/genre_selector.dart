import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class GenreSelector extends StatelessWidget {
  const GenreSelector({
    super.key,
    required this.availableGenres,
    required this.selectedGenres,
    required this.onGenreToggled,
  });
  final List<String> availableGenres;
  final List<String> selectedGenres;
  final void Function(String genre, bool isSelected) onGenreToggled;

  static const int _maxGenres = 10;

  @override
  Widget build(BuildContext context) {
    final bool atLimit = selectedGenres.length >= _maxGenres;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Genres',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Max-limit banner
        if (atLimit) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Maximum of 10 genres selected. Remove one to add another.',
                    style: TextStyle(color: AppColors.onPrimary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],

        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableGenres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            final isDisabled = atLimit && !isSelected;

            return Semantics(
              button: true,
              selected: isSelected,
              label: '$genre genre',
              child: FilterChip(
                label: Text(genre),
                selected: isSelected,
                onSelected: isDisabled
                    ? null
                    : (bool selected) => onGenreToggled(genre, selected),
                backgroundColor: isDisabled
                    ? AppColors.surface.withValues(alpha: 0.4)
                    : AppColors.surface,
                selectedColor: AppColors.onPrimary,
                showCheckmark: false,
                // checkmarkColor: AppColors.onBackground,
                labelStyle: TextStyle(
                  color: isDisabled
                      ? AppColors.onPrimary.withValues(alpha: 0.35)
                      : isSelected
                      ? AppColors.onBackground
                      : AppColors.onPrimary,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.onPrimary : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
