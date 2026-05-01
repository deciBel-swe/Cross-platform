import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../discovery/domain/entities/paginated_discovery_tracks.dart';
import '../../../discovery/presentation/providers/discovery_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../offline/presentation/widgets/collection_download_button.dart';
import '../../domain/entities/station_playlist.dart';
import '../utils/discovery_track_mapper.dart';
import '../widgets/station_playlist_cover.dart';

class StationPlaylistScreen extends ConsumerWidget {
  const StationPlaylistScreen({super.key, required this.kind});

  final StationPlaylistKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = _watchStation(ref, kind);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Station'),
      ),
      body: tracksAsync.when(
        data: (response) {
          final playlist = StationPlaylist.fromTracks(
            kind: kind,
            tracks: response.content,
          );

          if (playlist.tracks.isEmpty) {
            return const _StationMessage(
              message: 'This station is quiet right now.',
              icon: Icons.graphic_eq_rounded,
            );
          }

          final queue = discoveryTracksToLibraryTracks(playlist.tracks);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: _StationHeader(
                    playlist: playlist,
                    queue: queue,
                    onPlay: () => _playFirst(ref, queue),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: playlist.tracks.length,
                itemBuilder: (context, index) {
                  final track = playlist.tracks[index];
                  final playableTrack = queue[index];

                  return TrackTile(
                    key: ValueKey('station_${kind.name}_${track.id}'),
                    track: playableTrack,
                    onTap: () {
                      ref
                          .read(trackAudioProvider.notifier)
                          .playTrack(
                            track: playableTrack,
                            queue: queue,
                            autoPlay: true,
                          );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stackTrace) => _StationMessage(
          message: error.toString().replaceFirst('Exception: ', ''),
          icon: Icons.error_outline,
          isError: true,
        ),
      ),
    );
  }

  AsyncValue<PaginatedDiscoveryTracks> _watchStation(
    WidgetRef ref,
    StationPlaylistKind kind,
  ) {
    switch (kind) {
      case StationPlaylistKind.likes:
        return ref.watch(likesStationProvider);
      case StationPlaylistKind.artist:
        return ref.watch(artistStationProvider((page: 0, size: 40)));
      case StationPlaylistKind.genre:
        return ref.watch(genreStationProvider((page: 0, size: 40)));
    }
  }

  void _playFirst(WidgetRef ref, List<Track> queue) {
    Track? firstPlayable;
    for (final track in queue) {
      if (track.isPlayable) {
        firstPlayable = track;
        break;
      }
    }
    if (firstPlayable == null) {
      return;
    }

    ref
        .read(trackAudioProvider.notifier)
        .playTrack(track: firstPlayable, queue: queue, autoPlay: true);
  }
}

class _StationHeader extends StatelessWidget {
  const _StationHeader({
    required this.playlist,
    required this.queue,
    required this.onPlay,
  });

  final StationPlaylist playlist;
  final List<Track> queue;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StationPlaylistCover(playlist: playlist, size: 128),
        const SizedBox(width: AppDimensions.paddingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              Text(
                playlist.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              Text(
                '${playlist.trackCount} tracks',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMd),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Play'),
                  ),
                  const SizedBox(width: 35),
                  // Download all station tracks for offline use
                  if (queue.isNotEmpty)
                    CollectionDownloadButton(
                      // Use a stable ID derived from the station kind.
                      collectionId: playlist.kind.index + 9000,
                      collectionTitle: playlist.title,
                      isStation: true,
                      tracks: queue,
                      iconColor: AppColors.textSecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StationMessage extends StatelessWidget {
  const _StationMessage({
    required this.message,
    required this.icon,
    this.isError = false,
  });

  final String message;
  final IconData icon;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: isError ? AppColors.errors : AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
