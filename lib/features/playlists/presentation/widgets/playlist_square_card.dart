import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../domain/entities/playlist.dart';

class PlaylistSquareCard extends StatelessWidget {
  const PlaylistSquareCard({
    super.key,
    required this.playlist,
    required this.onTap,
    this.onMore,
    this.size = 184,
  });

  final Playlist playlist;
  final VoidCallback onTap;
  final VoidCallback? onMore;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trackCount = playlist.trackCount > 0
        ? playlist.trackCount
        : playlist.tracks.length;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PlaylistSquareCover(playlist: playlist),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.26),
                      AppColors.background.withValues(alpha: 0.9),
                    ],
                    stops: const [0, 0.48, 1],
                  ),
                ),
              ),
              Positioned(
                right: AppDimensions.paddingSm,
                top: AppDimensions.paddingSm,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.72),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 38,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onMore,
                      tooltip: 'More playlist options',
                      icon: Icon(
                        onMore == null
                            ? Icons.playlist_play_rounded
                            : Icons.more_horiz,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppDimensions.paddingMd,
                right: AppDimensions.paddingMd,
                bottom: AppDimensions.paddingMd,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$trackCount ${trackCount == 1 ? 'track' : 'tracks'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistSquareCover extends StatelessWidget {
  const _PlaylistSquareCover({required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final coverArt = playlist.coverArt?.trim();
    if (coverArt != null && coverArt.isNotEmpty) {
      return _isRemote(coverArt)
          ? DecibelCachedImage(
              imageUrl: coverArt,
              fit: BoxFit.cover,
              placeholder: const _PlaylistFallbackCover(),
              errorWidget: const _PlaylistFallbackCover(),
            )
          : Image.file(
              File(coverArt),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _PlaylistFallbackCover(),
            );
    }

    final tracksWithCovers = playlist.tracks
        .map((track) => track.coverUrl?.trim())
        .whereType<String>()
        .where((coverUrl) => coverUrl.isNotEmpty)
        .take(4)
        .toList(growable: false);

    if (tracksWithCovers.isEmpty) {
      return const _PlaylistFallbackCover();
    }

    if (tracksWithCovers.length == 1) {
      return DecibelCachedImage(
        imageUrl: tracksWithCovers.first,
        fit: BoxFit.cover,
        placeholder: const _PlaylistFallbackCover(),
        errorWidget: const _PlaylistFallbackCover(),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return DecibelCachedImage(
          imageUrl: tracksWithCovers[index % tracksWithCovers.length],
          fit: BoxFit.cover,
          placeholder: const _PlaylistFallbackCover(),
          errorWidget: const _PlaylistFallbackCover(),
        );
      },
    );
  }

  bool _isRemote(String path) {
    final uri = Uri.tryParse(path);
    final scheme = uri?.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }
}

class _PlaylistFallbackCover extends StatelessWidget {
  const _PlaylistFallbackCover();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF243029), Color(0xFF331A22)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.playlist_play_rounded,
          color: AppColors.textPrimary,
          size: 36,
        ),
      ),
    );
  }
}
