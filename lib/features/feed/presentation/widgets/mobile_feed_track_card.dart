library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';
import '../../../library/presentation/widgets/track_comments_bottom_sheet.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';

/// Reusable mobile feed track card matching the native-style post layout.
class MobileFeedTrackCard extends StatelessWidget {
  const MobileFeedTrackCard({
    super.key,
    required this.trackId,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.onPlay,
    this.onAddToPlaylist,
    required this.duration,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.commentCount,
    required this.gradientColors,
  });

  final int trackId;
  final String title;
  final String artist;
  final String? coverUrl;
  final VoidCallback? onPlay;
  final VoidCallback? onAddToPlaylist;
  final String duration;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final int commentCount;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Track card: $title by $artist, duration $duration',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 0.92,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: onPlay,
                  child: _MobileCoverBackground(
                    coverUrl: coverUrl,
                    gradientColors: gradientColors,
                  ),
                ),
              ),
              Positioned(
                top: AppDimensions.paddingMd,
                right: AppDimensions.paddingMd,
                child: _MobileRightActions(
                  trackId: trackId,
                  initialLikeCount: likeCount,
                  initialRepostCount: repostCount,
                  initialIsLiked: isLiked,
                  initialIsReposted: isReposted,
                  commentCount: commentCount,
                  onAddToPlaylist: onAddToPlaylist,
                ),
              ),
              Positioned(
                left: AppDimensions.paddingSm,
                right:
                    AppDimensions.paddingMd +
                    48, // Account for right actions width
                bottom: AppDimensions.paddingMd,
                child: GestureDetector(
                  onTap: onPlay,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _CardPlayButton(onPressed: onPlay),
                        const SizedBox(width: AppDimensions.paddingSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          duration,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileCoverBackground extends StatelessWidget {
  const _MobileCoverBackground({required this.gradientColors, this.coverUrl});

  final List<Color> gradientColors;
  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final normalizedCoverUrl = coverUrl?.trim();
    if (normalizedCoverUrl != null && normalizedCoverUrl.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          DecibelCachedImage(
            imageUrl: normalizedCoverUrl,
            placeholder: _GradientCoverFallback(gradientColors: gradientColors),
            errorWidget: _GradientCoverFallback(gradientColors: gradientColors),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.22),
            ),
          ),
        ],
      );
    }

    return _GradientCoverFallback(gradientColors: gradientColors);
  }
}

class _GradientCoverFallback extends StatelessWidget {
  const _GradientCoverFallback({required this.gradientColors});

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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.45),
        ),
        child: Center(
          child: Icon(
            Icons.music_note,
            size: 96,
            color: AppColors.textPrimary.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}

class _CardPlayButton extends StatefulWidget {
  const _CardPlayButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<_CardPlayButton> createState() => _CardPlayButtonState();
}

class _CardPlayButtonState extends State<_CardPlayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Semantics(
        button: true,
        label: 'Play track',
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered ? AppColors.primary : AppColors.surface,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              Icons.play_arrow,
              color: _isHovered ? Colors.white : AppColors.textPrimary,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileRightActions extends ConsumerStatefulWidget {
  const _MobileRightActions({
    required this.trackId,
    required this.initialLikeCount,
    required this.initialRepostCount,
    required this.initialIsLiked,
    required this.initialIsReposted,
    required this.commentCount,
    this.onAddToPlaylist,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final bool initialIsLiked;
  final bool initialIsReposted;
  final int commentCount;
  final VoidCallback? onAddToPlaylist;

  @override
  ConsumerState<_MobileRightActions> createState() =>
      _MobileRightActionsState();
}

class _MobileRightActionsState extends ConsumerState<_MobileRightActions> {
  late int _currentCommentCount;
  bool _isCommentHovered = false;
  bool _isAddHovered = false;

  @override
  void initState() {
    super.initState();
    _currentCommentCount = widget.commentCount;
  }

  @override
  void didUpdateWidget(_MobileRightActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.commentCount != widget.commentCount) {
      _currentCommentCount = widget.commentCount;
    }
  }

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.volume_off_outlined, color: AppColors.textPrimary),
        const SizedBox(height: AppDimensions.paddingMd),

        LikeButton(
          trackId: widget.trackId,
          isLiked: widget.initialIsLiked,
          likeCount: widget.initialLikeCount,
          iconSize: 23,
          fontSize: 12,
          isVertical: true,
        ),

        const SizedBox(height: AppDimensions.paddingMd),

        RepostButton(
          trackId: widget.trackId,
          isReposted: widget.initialIsReposted,
          repostCount: widget.initialRepostCount,
          iconSize: 28,
          fontSize: 12,
          isVertical: true,
        ),

        const SizedBox(height: AppDimensions.paddingMd),

        // COMMENT BUTTON
        Semantics(
          button: true,
          label: 'View $_currentCommentCount comments',
          child: GestureDetector(
            onTap: () async {
              final data = await ref.read(
                trackPreviewProvider(widget.trackId).future,
              );
              if (!context.mounted) return;
              TrackCommentsBottomSheet.show(
                context,
                trackId: widget.trackId,
                track: data.track,
              );
            },
            child: MouseRegion(
              onEnter: (_) => setState(() => _isCommentHovered = true),
              onExit: (_) => setState(() => _isCommentHovered = false),
              cursor: SystemMouseCursors.click,
              child: Column(
                children: [
                  Icon(
                    Icons.mode_comment_outlined,
                    color: _isCommentHovered
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    size: 28,
                  ),
                  const SizedBox(height: AppDimensions.paddingXs),
                  Text(
                    _formatCount(_currentCommentCount),
                    style: AppTextStyles.cardTitle.copyWith(
                      color: _isCommentHovered
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.paddingMd),
        Semantics(
          button: true,
          label: 'Add to playlist or library',
          child: GestureDetector(
            onTap: widget.onAddToPlaylist,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isAddHovered = true),
              onExit: (_) => setState(() => _isAddHovered = false),
              cursor: SystemMouseCursors.click,
              child: Column(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    color: _isAddHovered
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    size: 28,
                  ),
                  const SizedBox(height: AppDimensions.paddingXs),
                  Text(
                    'Add',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: _isAddHovered
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
