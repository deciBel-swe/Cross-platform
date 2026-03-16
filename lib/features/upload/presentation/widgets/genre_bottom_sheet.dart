import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';

class GenreBottomSheet extends ConsumerWidget {
  const GenreBottomSheet({super.key});

  // The hardcoded list of genres based on your Upload_Genre.jpg mockup
  static const List<String> _genres = [
    "Qur'an", 'Alternative Rock', 'Ambient', 'Classical', 'Country', 
    'Dance & EDM', 'Dancehall', 'Deep House', 'Disco', 
    'Drum & Bass', 'Dubstep', 'Electronic', 'Folk & Singer-Songwriter', 
    'Hip-hop & Rap', 'House'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadNotifierProvider);
    final currentGenre = state.value?.genre;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pick genre',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onPrimary),
          ),
          const SizedBox(height: 16),
          
          // The list of genres
          Expanded(
            child: ListView.builder(
              itemCount: _genres.length,
              itemBuilder: (context, index) {
                final genre = _genres[index];
                final isSelected = currentGenre == genre;

                return ListTile(
                  title: Text(
                    genre,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.onPrimary, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected 
                      ? const Icon(Icons.check, color: AppColors.primary) 
                      : null,
                  onTap: () {
                    // 1. Update the state
                    ref.read(uploadNotifierProvider.notifier).updateGenre(genre);
                    // 2. Close the bottom sheet
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}