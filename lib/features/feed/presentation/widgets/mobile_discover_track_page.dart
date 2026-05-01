import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/auto_scrolling_text.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';
import '../../../library/domain/entities/track.dart' as library_track;
import '../../../library/presentation/widgets/track_comments_bottom_sheet.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../domain/entities/feed_track.dart';

class MobileDiscoverTrackPage extends StatelessWidget {
  const MobileDiscoverTrackPage({
    super.key,
    required this.track,
    required this.playableTrack,
    required this.playableQueue,
    required this.gradientColors,
    required this.onPlayTrack,
    required this.onAddToPlaylist,
  });

  final FeedTrack track;
  final library_track.Track playableTrack;
  final List<library_track.Track> playableQueue;
  final List<Color> gradientColors;
  final Future<void> Function(
    library_track.Track track,
    List<library_track.Track> queue,
  )
  onPlayTrack;
  final ValueChanged<library_track.Track> onAddToPlaylist;

  @override
  Widget build(BuildContext context) {
    void play() => onPlayTrack(playableTrack, playableQueue);

    return Semantics(
      label:
          'Discover track: ${track.title} by ${track.displayArtistName}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: play,
            child: _FullBleedTrackImage(
              coverUrl: track.coverUrl,
              gradientColors: gradientColors,
            ),
          ),
          const _DiscoverScrim(),
          Positioned.fill(
            child: SafeArea(
              top: false,
              child: Stack(
                children: [

                  Positioned(
                    right: AppDimensions.paddingMd,
                    bottom: 112,
                    child: _DiscoverActionRail(
                      track: track,
                      onComment: () {
                        TrackCommentsBottomSheet.show(
                          context,
                          trackId: track.id,
                          track: playableTrack,
                        );
                      },
                      onAddToPlaylist: () => onAddToPlaylist(playableTrack),
                    ),
                  ),
                  Positioned(
                    left: AppDimensions.paddingMd,
                    right: 92,
                    bottom: AppDimensions.paddingLg,
                    child: _DiscoverTrackInfo(track: track),
                  ),
                  Positioned(
                    right: AppDimensions.paddingMd,
                    bottom: AppDimensions.paddingLg,
                    child: _DiscoverPlayButton(
                      onPressed: play,
                      trackId: track.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullBleedTrackImage extends StatelessWidget {
  const _FullBleedTrackImage({
    required this.coverUrl,
    required this.gradientColors,
  });

  final String? coverUrl;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final normalizedCoverUrl = coverUrl?.trim();
    if (normalizedCoverUrl != null && normalizedCoverUrl.isNotEmpty) {
      return DecibelCachedImage(
        imageUrl: normalizedCoverUrl,
        fit: BoxFit.cover,
        placeholder: _DiscoverFallback(gradientColors: gradientColors),
        errorWidget: _DiscoverFallback(gradientColors: gradientColors),
      );
    }

    return _DiscoverFallback(gradientColors: gradientColors);
  }
}

class _DiscoverFallback extends StatelessWidget {
  const _DiscoverFallback({required this.gradientColors});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.music_note_rounded,
          color: AppColors.textPrimary.withValues(alpha: 0.22),
          size: 132,
        ),
      ),
    );
  }
}

class _DiscoverScrim extends StatelessWidget {
  const _DiscoverScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x66000000), Color(0x11000000), Color(0xE6000000)],
          stops: [0, 0.48, 1],
        ),
      ),
    );
  }
}

class _DiscoverTrackInfo extends StatelessWidget {
  const _DiscoverTrackInfo({required this.track});

  final FeedTrack track;

  @override
  Widget build(BuildContext context) {
    final metaParts = <String>[
      if (track.genre.trim().isNotEmpty) track.genre,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@${track.artistUsername}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSm),
        AutoScrollingText(
          text: track.title,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textPrimary,
            fontSize: 26,
            height: 1.05,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 8)],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXs),
        Text(
          track.displayArtistName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.86),
            fontSize: 17,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
          ),
        ),
        if (metaParts.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingXs),
          Text(
            metaParts.join(' - '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.72),
              shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
            ),
          ),
        ],
      ],
    );
  }
}

class _DiscoverActionRail extends StatelessWidget {
  const _DiscoverActionRail({
    required this.track,
    required this.onComment,
    required this.onAddToPlaylist,
  });

  final FeedTrack track;
  final VoidCallback onComment;
  final VoidCallback onAddToPlaylist;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(
          trackId: track.id,
          isLiked: track.isLiked,
          likeCount: track.likeCount,
          iconSize: 28,
          fontSize: 12,
          isVertical: true,
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        RepostButton(
          trackId: track.id,
          isReposted: track.isReposted,
          repostCount: track.repostCount,
          iconSize: 30,
          fontSize: 12,
          isVertical: true,
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        _RailActionButton(
          icon: Icons.mode_comment_outlined,
          label: _formatCompactCount(track.commentCount),
          semanticLabel: 'View ${track.commentCount} comments',
          onTap: onComment,
        ),
        const SizedBox(height: AppDimensions.paddingMd),
        _RailActionButton(
          icon: Icons.add_box_outlined,
          label: 'Add',
          semanticLabel: 'Add to playlist or library',
          onTap: onAddToPlaylist,
        ),
      ],
    );
  }
}

class _RailActionButton extends StatelessWidget {
  const _RailActionButton({
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.34),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 44,
                child: Icon(icon, color: AppColors.textPrimary, size: 27),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXs),
            Text(
              label,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverPlayButton extends ConsumerWidget {
  const _DiscoverPlayButton({required this.onPressed, required this.trackId});

  final VoidCallback onPressed;
  final int trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(
      trackAudioProvider.select(
        (s) => s.isPlaying && s.preparedTrackId == trackId,
      ),
    );

    return Semantics(
      button: true,
      label: isPlaying ? 'Pause track' : 'Play track',
      child: GestureDetector(
        onTap: () {
          if (isPlaying) {
            ref.read(trackAudioProvider.notifier).pause();
          } else {
            onPressed();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SizedBox.square(
            dimension: 58,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.background,
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}



String _formatCompactCount(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }
  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
  }
  return number.toString();
}
