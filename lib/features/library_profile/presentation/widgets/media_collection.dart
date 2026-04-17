import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../engagement/presentation/notifiers/liked_tracks_notifier.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import 'tile.dart';
import 'track_tile.dart';

class MediaCollection extends ConsumerWidget {
  const MediaCollection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final likedTracksAsync = ref.watch(likedTracksProvider);
    final repostedTracksAsync = ref.watch(repostedTracksProvider);

    return Column(
      children: [
        Tile(
          title: "Playlist",
          buttonText: "See All",
          onButtonPressed: () {
            //TODO: hndle see all playlist action
          },
        ),
        const SizedBox(height: 14),
        Text(
          'No playlists yet',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Tile(
          title: "Likes",
          buttonText: "See All",
          onButtonPressed: () {
            context.push(RoutePaths.libraryLikes);
          },
        ),
        const SizedBox(height: 14),
        likedTracksAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => Text(
            'Could not load likes',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          data: (tracks) {
            if (tracks.isEmpty) {
              return Text(
                'No likes yet',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }

            final previewTracks = tracks.take(3).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previewTracks.length,
              itemBuilder: (context, index) {
                final track = previewTracks[index];
                return TrackTile(
                  track: track,
                  onTap: () => ref.read(trackAudioProvider.notifier).initializeForTrack(
                        trackId: track.id,
                        trackUrl: track.trackUrl ?? '',
                        track: track,
                        queue: tracks,
                      ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 14),
        Tile(
          title: "Reposts",
          buttonText: "See All",
          onButtonPressed: () {
            context.push(RoutePaths.libraryReposts);
          },
        ),
        const SizedBox(height: 14),
        repostedTracksAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => Text(
            'Could not load reposts',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          data: (tracks) {
            if (tracks.isEmpty) {
              return Text(
                'No reposts yet',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }

            final previewTracks = tracks.take(3).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previewTracks.length,
              itemBuilder: (context, index) {
                final track = previewTracks[index];
                return TrackTile(
                  track: track,
                  onTap: () => ref.read(trackAudioProvider.notifier).initializeForTrack(
                        trackId: track.id,
                        trackUrl: track.trackUrl ?? '',
                        track: track,
                        queue: tracks,
                      ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
