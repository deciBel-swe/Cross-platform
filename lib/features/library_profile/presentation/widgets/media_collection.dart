import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../engagement/presentation/notifiers/liked_tracks_notifier.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../playlists/presentation/providers/user_playlists_provider.dart'
    as playlist_providers;
import '../../../playlists/presentation/widgets/playlist_options_bottom_sheet.dart';
import '../../../playlists/presentation/widgets/playlist_square_card.dart';
import 'tile.dart';
import 'track_tile.dart';

class MediaCollection extends ConsumerWidget {
  const MediaCollection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final playlistsAsync = ref.watch(playlist_providers.userPlaylistsProvider);
    final likedTracksAsync = ref.watch(likedTracksProvider);
    final repostedTracksAsync = ref.watch(repostedTracksProvider);

    return Column(
      children: [
        Tile(
          title: "Playlists",
          buttonText: "See All",
          onButtonPressed: () {
            context.push(RoutePaths.playlists);
          },
        ),
        const SizedBox(height: 14),
        playlistsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => Text(
            'Could not load playlists',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          data: (playlists) {
            if (playlists.isEmpty) {
              return Text(
                'No playlists yet',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }

            final previewPlaylists = playlists.take(6).toList();
            return SizedBox(
              height: 184,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: previewPlaylists.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final playlist = previewPlaylists[index];
                  return PlaylistSquareCard(
                    playlist: playlist,
                    onTap: () {
                      context.push(RoutePaths.playlistTracks, extra: playlist);
                    },
                    onMore: () {
                      PlaylistOptionsBottomSheet.show(context, playlist);
                    },
                  );
                },
              ),
            );
          },
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
                  onTap: () => ref
                      .read(trackAudioProvider.notifier)
                      .playTrack(track: track, queue: tracks),
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
                  onTap: () => ref
                      .read(trackAudioProvider.notifier)
                      .playTrack(track: track, queue: tracks),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
