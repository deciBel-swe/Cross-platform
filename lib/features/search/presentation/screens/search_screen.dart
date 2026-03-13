/// Desktop Search screen — search bar + browse categories grid.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/genre_tile.dart';

/// Search page with a large search bar and genre category grid.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        children: [
          Text('Search', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.paddingMd),

          // ---- Search field ----
          const _LargeSearchField(),

          const SizedBox(height: AppDimensions.paddingXl),

          Text('Browse Categories', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimensions.paddingMd),

          // ---- Genre grid ----
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                      ? 3
                      : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: AppDimensions.paddingMd,
                  crossAxisSpacing: AppDimensions.paddingMd,
                  childAspectRatio: 2.0,
                ),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  return GenreTile(
                    label: genre.label,
                    gradientColors: genre.colors,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Large search input field for the browse page.
class _LargeSearchField extends StatelessWidget {
  const _LargeSearchField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        style: const TextStyle(fontSize: 15, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'What do you want to listen to?',
          hintStyle: TextStyle(fontSize: 15, color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          filled: true,
          fillColor: AppColors.surfaceLight,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ---- Mock genre data ----

class _Genre {
  const _Genre({required this.label, required this.colors});

  final String label;
  final List<Color> colors;
}

const _genres = [
  _Genre(label: 'Electronic', colors: [Color(0xFF6200EA), Color(0xFF7C4DFF)]),
  _Genre(label: 'Hip-Hop', colors: [Color(0xFFD50000), Color(0xFFFF1744)]),
  _Genre(label: 'Rock', colors: [Color(0xFFBF360C), Color(0xFFE64A19)]),
  _Genre(label: 'Pop', colors: [Color(0xFFAD1457), Color(0xFFC2185B)]),
  _Genre(label: 'R&B / Soul', colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)]),
  _Genre(label: 'Jazz', colors: [Color(0xFF311B92), Color(0xFF512DA8)]),
  _Genre(label: 'Classical', colors: [Color(0xFF004D40), Color(0xFF00695C)]),
  _Genre(label: 'Ambient', colors: [Color(0xFF006064), Color(0xFF00838F)]),
  _Genre(label: 'Lo-Fi', colors: [Color(0xFF33691E), Color(0xFF558B2F)]),
  _Genre(label: 'Metal', colors: [Color(0xFF212121), Color(0xFF424242)]),
  _Genre(label: 'Indie', colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)]),
  _Genre(label: 'Reggae', colors: [Color(0xFFF57F17), Color(0xFFFF6F00)]),
  _Genre(label: 'Country', colors: [Color(0xFF795548), Color(0xFF8D6E63)]),
  _Genre(label: 'Latin', colors: [Color(0xFFE65100), Color(0xFFFF6D00)]),
  _Genre(label: 'K-Pop', colors: [Color(0xFFE91E63), Color(0xFFF06292)]),
  _Genre(label: 'Podcast', colors: [Color(0xFF0277BD), Color(0xFF039BE5)]),
];
