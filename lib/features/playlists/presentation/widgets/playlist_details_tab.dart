import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/playlist.dart';
import '../notifiers/playlist_form_notifier.dart';

/// The Details tab showing the editable form (cover art, title, privacy).
class PlaylistDetailsTab extends ConsumerWidget {
  const PlaylistDetailsTab({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playlistFormProvider(playlist));
    final isLoading = state is AsyncLoading;

    // Fallback safely if data is not yet initialized
    final metadata = state.value;
    if (metadata == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 16),

        // Editable Cover Art
        Center(
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () => ref
                      .read(playlistFormProvider(playlist).notifier)
                      .pickCoverImage(),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Show picked image
                  if (metadata.coverImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        metadata.coverImage!,
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    )
                  // Fallback to existing playlist image
                  else if (playlist.coverArt != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(playlist.coverArt!),
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColors.apple,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (state.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              state.error.toString(),
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 32),

        // Title Input
        TextFormField(
          enabled: !isLoading,
          initialValue: metadata.title,
          maxLength: 100,
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Playlist title cannot be empty';
            }

            if (value.trim().isEmpty) {
              return 'Playlist title cannot be only spaces.';
            }

            if (value.trim().length > 100) {
              return 'Title must be 100 characters or less.';
            }
            return null;
          },
          onChanged: (val) => ref
              .read(playlistFormProvider(playlist).notifier)
              .updateTitle(val),
        ),

        const SizedBox(height: 16),
        // Description Menu Item
        TextFormField(
          enabled: !isLoading,
          initialValue: metadata.description,
          maxLength: 2000,
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
          onChanged: (val) => ref
              .read(playlistFormProvider(playlist).notifier)
              .updateDescription(val),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (v != null && v.length > 2000) {
              if (v.trim().isEmpty) {
                return 'Description cannot contain only spaces.';
              }
              // 2. Length check
              if (v.trim().length > 2000) {
                return 'Description must be 2000 characters or less.';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 32),

        // Make Public Switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Make public',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: !metadata.isPrivate,
              onChanged: isLoading
                  ? null
                  : (val) {
                      ref
                          .read(playlistFormProvider(playlist).notifier)
                          .togglePrivacy(!val);
                    },
              // 1. Customize the Thumb
              thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.textMuted.withValues(alpha: 0.5);
                }
                if (states.contains(WidgetState.selected)) {
                  return AppColors.onPrimary; // ON
                }
                return AppColors.textMuted; // OFF
              }),
              // 2. Customize the Track
              trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.transparent;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary; // ON
                }
                return AppColors.transparent; // OFF
              }),
              trackOutlineColor: WidgetStateProperty.resolveWith<Color>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.transparent; // ON
                }
                return AppColors.textPrimary; // OFF
              }),
              trackOutlineWidth: WidgetStateProperty.resolveWith<double>((
                states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return 0.0;
                }
                return 1.5;
              }),
            ),
          ],
        ),
      ],
    );
  }
}
