import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/upload_notifier.dart';
import 'genre_bottom_sheet.dart';
import 'tags_bottom_sheet.dart';

/// Contains the text input fields for the track's metadata.
///
/// Handles the Title, scrollable Genre chips,
/// Tag summary, and the Description text area.

class TrackDetailsForm extends ConsumerWidget {
  const TrackDetailsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadNotifierProvider);
    final isLoading = state is AsyncLoading;
    final metadata = state.value!;
    final notifier = ref.read(uploadNotifierProvider.notifier);
    final genreSuggestions = notifier.genreSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Input
        TextFormField(
          enabled: !isLoading,
          initialValue: metadata.title,
          style: const TextStyle(color: AppColors.onPrimary),
          decoration: const InputDecoration(
            labelText: 'Title *',
            labelStyle: TextStyle(color: AppColors.textMuted),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.onPrimary),
            ),
          ),
          onChanged: notifier.updateTitle,
          // Fulfills the acceptance criteria for inline required error
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 16),

        // Genre Selection
        const Text(
          'Genre *',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        // Allow horizontal scrolling if genres exceed screen width
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Pass 'context' as the first argument to each chip!
              _buildGenreChip(
                context,
                ref,
                'PICK GENRE',
                Icons.search,
                isSelected: false,
              ),

              if (metadata.genre.isNotEmpty &&
                  !notifier.genreSuggestions.contains(metadata.genre))
                _buildGenreChip(
                  context,
                  ref,
                  metadata.genre,
                  null,
                  isSelected: true,
                  onTap: () {},
                ),

              ...genreSuggestions.map(
                (genreName) => _buildGenreChip(
                  context,
                  ref,
                  genreName,
                  null,
                  isSelected: metadata.genre == genreName,
                  onTap: () {
                    ref
                        .read(uploadNotifierProvider.notifier)
                        .updateGenre(genreName);
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.borderLight, height: 32),

        // Tags Summary
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Tags',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          subtitle: Text(
            metadata.tags.isEmpty
                ? 'Add tags to describe track for reachability'
                : metadata.tags.join(', '),
            style: const TextStyle(color: AppColors.onPrimary),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textMuted,
            size: 16,
          ),
          onTap: () {
            // Open the BottomSheet
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled:
                  true, // Allows the sheet to move up with the keyboard
              backgroundColor: Colors.transparent,
              builder: (context) => const TagsBottomSheet(),
            );
          },
        ),
        const Divider(color: AppColors.borderLight),

        // Description Input
        TextFormField(
          enabled: !isLoading,
          maxLength: 500,
          maxLines: 4,
          style: const TextStyle(color: AppColors.onPrimary),
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: AppColors.textMuted),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.onPrimary),
            ),
          ),
          onChanged: notifier.updateDescription,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Helper method to create consistent, style-guide compliant ActionChips for genres.
  Widget _buildGenreChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    IconData? icon, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        backgroundColor: isSelected ? AppColors.onPrimary : Colors.transparent,
        side: BorderSide(
          color: isSelected ? AppColors.onPrimary : AppColors.borderLight,
        ),
        avatar: icon != null
            ? Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.background : AppColors.onPrimary,
              )
            : null,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.onPrimary,
            fontSize: 12,
          ),
        ),
        onPressed:
            onTap ??
            () {
              // If they click 'PICK GENRE', open the bottom sheet
              if (label == 'PICK GENRE') {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const FractionallySizedBox(
                    heightFactor: 0.7,
                    child: GenreBottomSheet(),
                  ),
                );
              }
            },
      ),
    );
  }
}
