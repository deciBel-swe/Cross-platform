import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/widgets/playlist_like_button.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/widgets/track_details.dart';
import '../../../library_profile/presentation/widgets/track_tile.dart';
import '../../../offline/presentation/widgets/collection_download_button.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist_details_provider.dart';
import '../widgets/playlist_options_bottom_sheet.dart';

class PlaylistDetailsScreen extends ConsumerWidget {
  const PlaylistDetailsScreen({super.key, required this.playlistSummary});

  final Playlist playlistSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(
      playlistDetailsProvider(playlistSummary.id),
    );

    final currentPlaylist = playlistAsync.valueOrNull ?? playlistSummary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Playlist',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: const [],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _PlaylistHeader(playlist: currentPlaylist),
                  const SizedBox(height: 16),
                  _PlaylistActions(playlist: currentPlaylist),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          playlistAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: AppColors.errors),
                ),
              ),
            ),
            data: (fullPlaylist) {
              if (fullPlaylist.tracks.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No tracks yet.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final track = fullPlaylist.tracks[index];

                  return TrackTile(
                    key: ValueKey(track.id),
                    track: track,
                    onTap: () {
                      ref
                          .read(trackAudioProvider.notifier)
                          .playTrack(
                            track: track,
                            queue: fullPlaylist.tracks,
                            autoPlay: true,
                          );
                    },
                    onMorePressed: () {
                      TrackDetails.show(context, track, ref);
                    },
                  );
                }, childCount: fullPlaylist.tracks.length),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Text(
                'Suggested for you',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _PlaylistHeader extends StatelessWidget {
  const _PlaylistHeader({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final trackCount = playlist.tracks.length;
    final trackString = trackCount == 1 ? 'One Track' : '$trackCount Tracks';
    final coverArt = playlist.coverArt?.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.hardEdge,
          child: coverArt != null && coverArt.isNotEmpty
              ? _PlaylistCoverImage(coverArt: coverArt)
              : _MosaicCover(tracks: playlist.tracks),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Playlist • $trackString',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    playlist.isPrivate ? Icons.lock : Icons.public,
                    color: AppColors.textMuted,
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'By ${playlist.owner?.username}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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

class _PlaylistCoverImage extends StatelessWidget {
  const _PlaylistCoverImage({required this.coverArt});

  final String coverArt;

  @override
  Widget build(BuildContext context) {
    return _isRemote(coverArt)
        ? DecibelCachedImage(imageUrl: coverArt, fit: BoxFit.cover)
        : Image.file(
            File(coverArt),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: AppColors.textMuted),
          );
  }
}

bool _isRemote(String path) {
  final uri = Uri.tryParse(path);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

class _PlaylistActions extends ConsumerWidget {
  const _PlaylistActions({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Resolve the full track list from the detail provider if already loaded.
    final fullTracksAsync = ref.watch(playlistDetailsProvider(playlist.id));
    final tracks = fullTracksAsync.valueOrNull?.tracks ?? playlist.tracks;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                PlaylistLikeButton(playlist: playlist),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    PlaylistOptionsBottomSheet.show(context, playlist);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            // Download all tracks in this playlist
            if (tracks.isNotEmpty)
              CollectionDownloadButton(
                collectionId: playlist.id,
                collectionTitle: playlist.title,
                coverUrl: playlist.coverArt,
                tracks: tracks,
                iconColor: AppColors.textSecondary,
              ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.shuffle, color: AppColors.textSecondary),
              onPressed: () {
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.background,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MosaicCover extends StatelessWidget {
  const _MosaicCover({required this.tracks});

  final List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    final tracksWithCovers = tracks
        .where((t) => t.coverUrl != null && t.coverUrl!.trim().isNotEmpty)
        .toList();

    if (tracksWithCovers.length >= 4) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return DecibelCachedImage(
            imageUrl: tracksWithCovers[index].coverUrl!,
            fit: BoxFit.cover,
          );
        },
      );
    }

    if (tracksWithCovers.isNotEmpty) {
      return DecibelCachedImage(
        imageUrl: tracksWithCovers.first.coverUrl!,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.music_note, color: AppColors.textMuted, size: 48);
  }
}
