import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/genre_list_provider.dart';

class GenreManagerWidget extends ConsumerStatefulWidget {
  const GenreManagerWidget({super.key, this.initialSelectedGenres = const []});
  final List<String> initialSelectedGenres;

  @override
  ConsumerState<GenreManagerWidget> createState() => _GenreManagerWidgetState();
}

class _GenreManagerWidgetState extends ConsumerState<GenreManagerWidget> {
  late List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();
    // Initialize the local state with whatever was passed in
    _selectedGenres = List.from(widget.initialSelectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch the available genres from the API
    final genresAsyncValue = ref.watch(allGenreListProvider);

    return genresAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),

      data: (eitherGenres) => eitherGenres.fold(
        // 2. Handle API Failure
        (failure) => Center(
          child: Text(
            failure.message,
            style: const TextStyle(color: Colors.red),
          ),
        ),

        // 3. Build the UI on API Success
        (availableGenres) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Chips
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: availableGenres.map((genre) {
                final isSelected = _selectedGenres.contains(genre);

                return FilterChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedGenres.add(genre);
                      } else {
                        _selectedGenres.remove(genre);
                      }
                    });
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.google,
                  checkmarkColor: AppColors.onPrimary,
                  labelStyle: const TextStyle(color: AppColors.onPrimary),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.google
                        : AppColors.transparent,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
