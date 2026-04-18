import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../offline/presentation/providers/offline_tracks_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineTracksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Downloads'),
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: state.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(
              child: Text(
                'No locally downloaded tracks.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            itemCount: tracks.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TrackTile(
                  track: track,
                  onTap: () {
                    ref
                        .read(trackAudioProvider.notifier)
                        .initializeForTrack(
                          trackId: track.id,
                          trackUrl: track.trackUrl ?? '',
                          track: track,
                          autoPlay: true,
                        );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, StackTrace) => Center(
          child: Text(
            'Error loading downloads: $error',
            style: const TextStyle(color: AppColors.errors),
          ),
        ),
      ),
    );
  }
}
