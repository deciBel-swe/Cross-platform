/// Individual feed entry — user action + rich inline track post.
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
import '../../../library_profile/presentation/widgets/waveform_painter.dart';
import 'mobile_feed_track_card.dart';

/// A single mocked entry in the activity feed.
class FeedItem extends StatelessWidget {
  const FeedItem({
    super.key,
    required this.trackId,
    required this.userName,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.genre,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.plays,
    required this.commentCount,
    required this.duration,
    required this.waveformPeaks,
    this.onPlay,
    this.onAddToPlaylist,
    this.userAvatarUrl,
    this.coverUrl,
    this.gradientColors,
  });

  final int trackId;
  final String userName;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final String genre;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final String plays;
  final int commentCount;
  final String duration;
  final List<double> waveformPeaks;
  final VoidCallback? onPlay;
  final VoidCallback? onAddToPlaylist;
  final String? userAvatarUrl;
  final String? coverUrl;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        const [AppColors.surfaceLight, AppColors.surfaceContainer];
    final isDesktop = _isDesktopLayout(context);

    if (!isDesktop) {
      return _MobileFeedItem(
        trackId: trackId,
        userName: userName,
        userAvatarUrl: userAvatarUrl,
        action: action,
        trackTitle: trackTitle,
        trackArtist: trackArtist,
        timeAgo: timeAgo,
        likeCount: likeCount,
        repostCount: repostCount,
        isLiked: isLiked,
        isReposted: isReposted,
        commentCount: commentCount,
        duration: duration,
        onPlay: onPlay,
        onAddToPlaylist: onAddToPlaylist,
        coverUrl: coverUrl,
        gradientColors: colors,
      );
    }

    return Semantics(
      label: 'Feed item: $trackTitle by $trackArtist',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Avatar(
                  colors: colors,
                  userName: userName,
                  imageUrl: userAvatarUrl,
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: userName, style: AppTextStyles.cardTitle),
                        TextSpan(
                          text: ' $action $timeAgo',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArtworkTile(
                  colors: colors,
                  title: trackTitle,
                  imageUrl: coverUrl,
                  onTap: onPlay,
                ),
                const SizedBox(width: AppDimensions.paddingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _PlayButton(onPressed: onPlay),
                          const SizedBox(width: AppDimensions.paddingMd),
                          Expanded(
                            child: GestureDetector(
                              onTap: onPlay,
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trackArtist,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    trackTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.sectionTitle.copyWith(
                                      fontSize: 33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _GenreChip(genre: genre),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingMd),
                      _WaveformStrip(peaks: waveformPeaks, duration: duration),
                      const SizedBox(height: AppDimensions.paddingMd),
                      _DesktopFeedActions(
                        trackId: trackId,
                        initialLikeCount: likeCount,
                        initialRepostCount: repostCount,
                        initialIsLiked: isLiked,
                        initialIsReposted: isReposted,
                        commentCount: commentCount,
                        plays: plays,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool _isDesktopLayout(BuildContext context) {
  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery == null) {
    return false;
  }
  return mediaQuery.size.width >= 801;
}

class _MobileFeedItem extends StatelessWidget {
  const _MobileFeedItem({
    required this.trackId,
    required this.userName,
    this.userAvatarUrl,
    required this.action,
    required this.trackTitle,
    required this.trackArtist,
    required this.timeAgo,
    required this.likeCount,
    required this.repostCount,
    required this.isLiked,
    required this.isReposted,
    required this.commentCount,
    required this.duration,
    this.onPlay,
    this.onAddToPlaylist,
    this.coverUrl,
    required this.gradientColors,
  });

  final int trackId;
  final String userName;
  final String? userAvatarUrl;
  final String action;
  final String trackTitle;
  final String trackArtist;
  final String timeAgo;
  final int likeCount;
  final int repostCount;
  final bool isLiked;
  final bool isReposted;
  final int commentCount;
  final String duration;
  final VoidCallback? onPlay;
  final VoidCallback? onAddToPlaylist;
  final String? coverUrl;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$userName $action $timeAgo',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MobileAvatar(
                  imageUrl: userAvatarUrl,
                  userName: userName,
                  colors: gradientColors,
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                Expanded(
                  child: Text(
                    '$userName $action · $timeAgo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                const Icon(Icons.more_vert, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            MobileFeedTrackCard(
              trackId: trackId,
              title: trackTitle,
              artist: trackArtist,
              coverUrl: coverUrl,
              onPlay: onPlay,
              onAddToPlaylist: onAddToPlaylist,
              duration: duration,
              likeCount: likeCount,
              repostCount: repostCount,
              isLiked: isLiked,
              isReposted: isReposted,
              commentCount: commentCount,
              gradientColors: gradientColors,
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.colors,
    required this.userName,
    this.imageUrl,
  });

  final List<Color> colors;
  final String userName;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final normalizedImageUrl = imageUrl?.trim();
    if (normalizedImageUrl != null && normalizedImageUrl.isNotEmpty) {
      return DecibelCachedImage(
        imageUrl: normalizedImageUrl,
        width: 40,
        height: 40,
        shape: BoxShape.circle,
        placeholderIcon: Icons.person,
        errorIcon: Icons.person,
        iconSize: 18,
        iconColor: AppColors.textSecondary,
        placeholder: _AvatarFallback(colors: colors, userName: userName),
        errorWidget: _AvatarFallback(colors: colors, userName: userName),
      );
    }

    return _AvatarFallback(colors: colors, userName: userName);
  }
}

class _MobileAvatar extends StatelessWidget {
  const _MobileAvatar({
    required this.colors,
    required this.userName,
    this.imageUrl,
  });

  final List<Color> colors;
  final String userName;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final normalizedImageUrl = imageUrl?.trim();
    if (normalizedImageUrl != null && normalizedImageUrl.isNotEmpty) {
      return DecibelCachedImage(
        imageUrl: normalizedImageUrl,
        width: 24,
        height: 24,
        shape: BoxShape.circle,
        placeholderIcon: Icons.person,
        errorIcon: Icons.person,
        iconSize: 14,
        iconColor: AppColors.textSecondary,
        placeholder: _AvatarFallback(
          colors: colors,
          userName: userName,
          size: 24,
          fontSize: 10,
        ),
        errorWidget: _AvatarFallback(
          colors: colors,
          userName: userName,
          size: 24,
          fontSize: 10,
        ),
      );
    }

    return _AvatarFallback(
      colors: colors,
      userName: userName,
      size: 24,
      fontSize: 10,
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({
    required this.colors,
    required this.userName,
    this.size = 40,
    this.fontSize = 14,
  });

  final List<Color> colors;
  final String userName;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final initial = userName.trim().isEmpty
        ? '?'
        : userName.trim().substring(0, 1).toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ).copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}

class _ArtworkTile extends StatelessWidget {
  const _ArtworkTile({
    required this.colors,
    required this.title,
    this.imageUrl,
    this.onTap,
  });

  final List<Color> colors;
  final String title;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final normalizedImageUrl = imageUrl?.trim();
    final borderRadius = BorderRadius.circular(AppDimensions.radiusSm);

    if (normalizedImageUrl != null && normalizedImageUrl.isNotEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: DecibelCachedImage(
          imageUrl: normalizedImageUrl,
          width: 162,
          height: 162,
          borderRadius: borderRadius,
          placeholder: _ArtworkFallback(colors: colors, title: title),
          errorWidget: _ArtworkFallback(colors: colors, title: title),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: _ArtworkFallback(colors: colors, title: title),
    );
  }
}

class _ArtworkFallback extends StatelessWidget {
  const _ArtworkFallback({required this.colors, required this.title});

  final List<Color> colors;
  final String title;

  @override
  Widget build(BuildContext context) {
    final initials = title.trim().isEmpty
        ? '?'
        : title.trim().substring(0, title.trim().length > 1 ? 2 : 1);

    return Container(
      width: 162,
      height: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered ? AppColors.primary : AppColors.surfaceVariant,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              Icons.play_arrow,
              color: _isHovered ? Colors.white : AppColors.textSecondary,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.genre});

  final String genre;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Genre: $genre',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSm,
          vertical: AppDimensions.paddingXs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          '#$genre',
          style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _WaveformStrip extends StatelessWidget {
  const _WaveformStrip({required this.peaks, required this.duration});

  final List<double> peaks;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WaveformPainter(
                peaks: peaks,
                progress: 0,
                playedColor: AppColors.primary,
                dragColor: AppColors.borderLight,
                unplayedColor: AppColors.surfaceVariant,
                centerLineColor: AppColors.borderDark,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: Text(
              duration,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopFeedActions extends ConsumerStatefulWidget {
  const _DesktopFeedActions({
    required this.trackId,
    required this.initialLikeCount,
    required this.initialRepostCount,
    required this.initialIsLiked,
    required this.initialIsReposted,
    required this.commentCount,
    required this.plays,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final bool initialIsLiked;
  final bool initialIsReposted;
  final int commentCount;
  final String plays;

  @override
  ConsumerState<_DesktopFeedActions> createState() => _DesktopFeedActionsState();
}

class _DesktopFeedActionsState extends ConsumerState<_DesktopFeedActions> {
  late int _currentCommentCount;
  bool _isCommentHovered = false;

  @override
  void initState() {
    super.initState();
    _currentCommentCount = widget.commentCount;
  }

  @override
  void didUpdateWidget(_DesktopFeedActions oldWidget) {
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
    return Row(
      children: [
        LikeButton(
          trackId: widget.trackId,
          isLiked: widget.initialIsLiked,
          likeCount: widget.initialLikeCount,
          iconSize: 18,
          fontSize: 13,
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        RepostButton(
          trackId: widget.trackId,
          isReposted: widget.initialIsReposted,
          repostCount: widget.initialRepostCount,
          iconSize: 18,
          fontSize: 13,
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        const _IconSquareButton(icon: Icons.ios_share_outlined),
        const SizedBox(width: AppDimensions.paddingSm),
        const _IconSquareButton(icon: Icons.content_copy_outlined),
        const SizedBox(width: AppDimensions.paddingSm),
        const _IconSquareButton(icon: Icons.more_horiz),
        const Spacer(),
        Icon(
          Icons.play_arrow,
          size: 14,
          color: AppColors.textSecondary.withValues(alpha: 0.8),
        ),
        const SizedBox(width: AppDimensions.paddingXs),
        Text(
          widget.plays,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMd),
        Semantics(
          button: true,
          label: 'View $_currentCommentCount comments',
          child: GestureDetector(
            onTap: () async {
              final data = await ref.read(trackPreviewProvider(widget.trackId).future);
              if (!context.mounted) return;
              
              await TrackCommentsBottomSheet.show(
                context,
                trackId: widget.trackId,
                track: data.track,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isCommentHovered = true),
              onExit: (_) => setState(() => _isCommentHovered = false),
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mode_comment_outlined,
                    size: 14,
                    color: _isCommentHovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: AppDimensions.paddingXs),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _isCommentHovered ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                    child: Text(_formatCount(_currentCommentCount)),
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

class _IconSquareButton extends StatefulWidget {
  const _IconSquareButton({required this.icon});

  final IconData icon;

  @override
  State<_IconSquareButton> createState() => _IconSquareButtonState();
}

class _IconSquareButtonState extends State<_IconSquareButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 34,
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceLight : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Icon(
          widget.icon,
          color: _isHovered ? AppColors.textPrimary : AppColors.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}
