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


  @override
  Widget build(BuildContext context) {
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
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableGenres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (bool selected) => onGenreToggled(genre, selected),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.google,
              checkmarkColor: AppColors.google,
              labelStyle: TextStyle(color: isSelected ? AppColors.google : AppColors.onPrimary),
              side: BorderSide(color: isSelected ? AppColors.google : Colors.transparent),
            );
          }).toList(),
        ),
      ],
    );
  }
}