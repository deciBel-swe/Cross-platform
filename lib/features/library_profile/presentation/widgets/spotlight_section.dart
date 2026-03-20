import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../notifiers/track_notifier.dart';
import 'track_tile.dart';

class TopTracksSection extends ConsumerWidget {

  const TopTracksSection({
    super.key,
    required this.userId,
  });
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Riverpod state
    final tracksState = ref.watch(userTracksProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Section Header ---
        const SizedBox(height: AppConstants.spacingSmall),

        // --- State Handling ---
        tracksState.when(
          // 1. Loading State
          loading: () => const Padding(
            padding: EdgeInsets.all(AppConstants.spacingLarge),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.surface),
            ),
          ),

          // 2. Error State (With Retry Button)
          error: (error, stack) => _buildErrorState(context, ref, error),

          // 3. Success State
          data: (tracks) {
            if (tracks.isEmpty) {
              return _buildEmptyState(context);
            }

            // Grab exactly the top 3 (or fewer if they have < 3 tracks)
            final topTracks = tracks.take(3).toList();

            // Use ListView with shrinkWrap so it plays nicely inside your ProfileScreen's SingleChildScrollView
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Let the parent scroll view handle scrolling
              padding: EdgeInsets.zero,
              itemCount: topTracks.length,
              itemBuilder: (context, index) {
                final track = topTracks[index];
                
                return TrackTile(
                  track: track,
                  onTap: () {
                    debugPrint('Playing track: ${track.title}');
                    // TODO: Trigger audio player
                  },
                  onMorePressed: () {
                    debugPrint('Options for: ${track.title}');
                    // TODO: Open bottom sheet
                  },
                  onLikePressed: () {
                    debugPrint('Liked: ${track.title}');
                    // TODO: Call like provider
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  // --- Helper Widgets for Clean Code ---

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 32),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            error.toString().replaceAll('Exception: ', ''),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          TextButton.icon(
            onPressed: () {
              // Trigger the refresh method on your AsyncNotifier
              ref.read(userTracksProvider(userId).notifier).refresh();
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Tap to Retry'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      child: Center(
        child: Text(
          'No tracks uploaded yet.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ),
    );
  }
}