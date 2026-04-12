import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist_details_provider.dart';
import '../widgets/playlist_options_bottom_sheet.dart';

/// The main playlist details screen
class PlaylistDetailsScreen extends ConsumerWidget {
  const PlaylistDetailsScreen({super.key, required this.playlistSummary});

  final Playlist playlistSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistAsync = ref.watch(
      playlistDetailsProvider(playlistSummary.id),
    );

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
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Static Header & Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _PlaylistHeader(playlist: playlistSummary),
                  const SizedBox(height: 16),
                  _PlaylistActions(playlist: playlistSummary),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // 2. The Tracks List
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
                  return _TrackTile(
                    key: ValueKey(track.id),
                    track: track,
                    playlist: fullPlaylist,
                  );
                }, childCount: fullPlaylist.tracks.length),
              );
            },
          ),

          // 3. Suggested For You Section "Will be deleted or be a feature I don't know"
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
    // Determine track count string
    final trackCount = playlist.tracks.length;
    final trackString = trackCount == 1 ? 'One Track' : '$trackCount Tracks';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover Art
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          // Ensures the mosaic grid stays inside the rounded corners
          clipBehavior: Clip.hardEdge,
          child:
              (playlist.coverArt != null &&
                  playlist.coverArt!.trim().isNotEmpty)
              ? Image.file(
                  File(playlist.coverArt!),
                  fit: BoxFit.cover,
                  // error builder so if the cover image file is deleted or corrupted the app shows an icon instead of the giant red error box
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: AppColors.textMuted,
                  ),
                )
              : _MosaicCover(tracks: playlist.tracks),
        ),
        const SizedBox(width: 16),

        // Metadata
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

              // Metadata Row
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

              // Owner Row
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors
                          .primary, // TODO: It may be the user profile image
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
                      'By ${playlist.owner.username}',
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

class _PlaylistActions extends StatelessWidget {
  const _PlaylistActions({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {
            PlaylistOptionsBottomSheet.show(context, playlist);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.shuffle, color: AppColors.textSecondary),
              onPressed: () {
                // TODO: Shuffle play logic
              },
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // TODO: Play playlist logic
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

class _TrackTile extends StatelessWidget {
  const _TrackTile({super.key, required this.track, required this.playlist});

  final Track track;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
          image: track.coverUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(track.coverUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: track.coverUrl == null
            ? const Icon(Icons.music_note, color: AppColors.textMuted)
            : null,
      ),
      title: Text(
        track.title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            track.artist.username,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.pause_circle_filled,
                color: AppColors.textMuted,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                track.state.name,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
        onPressed: () {
          // TODO: Open the track options bottom sheet
        },
      ),
    );
  }
}

class _MosaicCover extends StatelessWidget {
  const _MosaicCover({required this.tracks});

  final List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    // Filter tracks that actually have a cover URL
    final tracksWithCovers = tracks
        .where((t) => t.coverUrl != null && t.coverUrl!.trim().isNotEmpty)
        .toList();

    // If we have 4 or more, build a 2x2 grid
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

    // If we have at least 1, just show the first one taking up the whole space
    if (tracksWithCovers.isNotEmpty) {
      return DecibelCachedImage(imageUrl: tracksWithCovers.first.coverUrl!, fit: BoxFit.cover);
    }

    // fallback if no tracks have covers
    return const Icon(Icons.music_note, color: AppColors.textMuted, size: 48);
  }
}
