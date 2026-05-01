/// Individual feed entry — user action + rich inline track post.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ref_pro_check_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/auto_scrolling_text.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';
import '../../../engagement/presentation/widgets/track_report_bottom_sheet.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/presentation/widgets/track_comments_bottom_sheet.dart';
import '../../../library/presentation/widgets/track_more_options_menu.dart';
import '../../../library_profile/presentation/providers/track_peaks_provider.dart';
import '../../../library_profile/presentation/widgets/waveform_painter.dart';
import '../../../player/presentation/widgets/queue_bottom_sheet.dart';
import '../../domain/entities/feed_item_type.dart';
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
    required this.commentTrack,
    this.onPlay,
    this.onAddToPlaylist,
    this.onAddToQueue,
    this.onViewQueue,
    this.onEditTrack,
    this.onGoToArtist,
    this.onGoToAlbum,
    this.onShare,
    this.onCopyLink,
    this.onDownload,
    this.onDeleteTrack,
    this.onMoreOptions,
    this.userAvatarUrl,
    this.coverUrl,
    this.gradientColors,
    this.feedItemType = FeedItemType.trackPosted,
    this.playlistData,
    this.isBlocked = false,
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
  final Track commentTrack;
  final VoidCallback? onPlay;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onAddToQueue;
  final VoidCallback? onViewQueue;
  final VoidCallback? onEditTrack;
  final VoidCallback? onGoToArtist;
  final VoidCallback? onGoToAlbum;
  final VoidCallback? onShare;
  final VoidCallback? onCopyLink;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteTrack;
  final VoidCallback? onMoreOptions;
  final String? userAvatarUrl;
  final String? coverUrl;
  final List<Color>? gradientColors;
  final FeedItemType feedItemType;
  final Map<String, dynamic>? playlistData;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        const [AppColors.surfaceLight, AppColors.surfaceContainer];
    final isDesktop = ResponsiveUtils.isDesktop(context);

    // Handle playlist posts separately
    if (feedItemType == FeedItemType.playlistPosted) {
      return _PlaylistFeedCard(
        userName: userName,
        userAvatarUrl: userAvatarUrl,
        action: action,
        timeAgo: timeAgo,
        playlistData: playlistData,
        coverUrl: coverUrl,
        colors: colors,
      );
    }

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
        commentTrack: commentTrack,
        duration: duration,
        onPlay: onPlay,
        onAddToPlaylist: onAddToPlaylist,
        onMoreOptions: onMoreOptions,
        onViewQueue: onViewQueue,
        coverUrl: coverUrl,
        gradientColors: colors,
        isBlocked: isBlocked,
      );
    }

    return Semantics(
      label: 'Feed item: $trackTitle by $trackArtist',
      child: Opacity(
        opacity: isBlocked ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeedHeaderRow(
              userName: userName,
              action: action,
              timeAgo: timeAgo,
              colors: colors,
              imageUrl: userAvatarUrl,
              isDesktop: true,
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
                                  AutoScrollingText(
                                    text: trackTitle,
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
                      _WaveformStrip(
                        trackId: trackId,
                        fallbackPeaks: waveformPeaks,
                        duration: duration,
                      ),
                      const SizedBox(height: AppDimensions.paddingMd),
                      _DesktopFeedActions(
                        trackId: trackId,
                        initialLikeCount: likeCount,
                        initialRepostCount: repostCount,
                        initialIsLiked: isLiked,
                        initialIsReposted: isReposted,
                        commentCount: commentCount,
                        commentTrack: commentTrack,
                        plays: plays,
                        onAddToPlaylist: onAddToPlaylist,
                        onAddToQueue: onAddToQueue,
                        onEditTrack: onEditTrack,
                        onGoToArtist: onGoToArtist,
                        onGoToAlbum: onGoToAlbum,
                        onShare: onShare,
                        onCopyLink: onCopyLink,
                        onDownload: onDownload,
                        onDeleteTrack: onDeleteTrack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
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
    required this.commentTrack,
    required this.duration,
    this.onPlay,
    this.onAddToPlaylist,
    this.onMoreOptions,
    this.onViewQueue,
    this.coverUrl,
    required this.gradientColors,
    this.isBlocked = false,
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
  final Track commentTrack;
  final String duration;
  final VoidCallback? onPlay;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onMoreOptions;
  final VoidCallback? onViewQueue;
  final String? coverUrl;
  final List<Color> gradientColors;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$userName $action $timeAgo',
      child: Opacity(
        opacity: isBlocked ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeedHeaderRow(
              userName: userName,
              action: action,
              timeAgo: timeAgo,
              colors: gradientColors,
              imageUrl: userAvatarUrl,
              isDesktop: false,
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            MobileFeedTrackCard(
              trackId: trackId,
              title: trackTitle,
              artist: trackArtist,
              coverUrl: coverUrl,
              onPlay: onPlay,
              onAddToPlaylist: onAddToPlaylist,
              onMoreOptions: onMoreOptions,
              gradientColors: gradientColors,
              likeCount: likeCount,
              repostCount: repostCount,
              isLiked: isLiked,
              isReposted: isReposted,
              commentCount: commentCount,
              commentTrack: commentTrack,
              duration: duration,
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _PlaylistFeedCard extends StatelessWidget {
  const _PlaylistFeedCard({
    required this.userName,
    this.userAvatarUrl,
    required this.action,
    required this.timeAgo,
    this.playlistData,
    this.coverUrl,
    required this.colors,
  });

  final String userName;
  final String? userAvatarUrl;
  final String action;
  final String timeAgo;
  final Map<String, dynamic>? playlistData;
  final String? coverUrl;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final playlistTitle =
        playlistData?['title'] as String? ?? 'Unknown Playlist';
    final trackCount = playlistData?['trackCount'] as int? ?? 0;
    final owner = playlistData?['owner'] as Map<String, dynamic>?;
    final ownerUsername = owner?['username'] as String? ?? userName;
    final ownerDisplayName = owner?['displayName'] as String?;
    final ownerAvatarUrl = owner?['avatarUrl'] as String?;

    return Semantics(
      label: '$userName $action $timeAgo',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeedHeaderRow(
              userName: ownerDisplayName ?? ownerUsername,
              action: action,
              timeAgo: timeAgo,
              colors: colors,
              imageUrl: ownerAvatarUrl ?? userAvatarUrl,
              isDesktop: false,
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                onTap: () {
                  // TODO: Navigate to playlist details
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSm,
                        ),
                        child: coverUrl != null && coverUrl!.isNotEmpty
                            ? DecibelCachedImage(
                                imageUrl: coverUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.queue_music_rounded,
                                  color: AppColors.textMuted,
                                  size: 32,
                                ),
                              ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlistTitle,
                              style: AppTextStyles.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$trackCount track${trackCount == 1 ? '' : 's'}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Layout Components ───────────────────────────────────────────────

class _FeedHeaderRow extends StatelessWidget {
  const _FeedHeaderRow({
    required this.userName,
    required this.action,
    required this.timeAgo,
    required this.colors,
    this.imageUrl,
    this.isDesktop = false,
  });

  final String userName;
  final String action;
  final String timeAgo;
  final List<Color> colors;
  final String? imageUrl;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FeedAvatar(
          colors: colors,
          userName: userName,
          imageUrl: imageUrl,
          size: isDesktop ? 40 : 24,
          iconSize: isDesktop ? 18 : 14,
          fontSize: isDesktop ? 14 : 10,
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        Expanded(
          child: isDesktop
              ? RichText(
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
                )
              : Text(
                  '$userName $action · $timeAgo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}

class _FeedAvatar extends StatelessWidget {
  const _FeedAvatar({
    required this.colors,
    required this.userName,
    this.imageUrl,
    this.size = 40,
    this.iconSize = 18,
    this.fontSize = 14,
  });

  final List<Color> colors;
  final String userName;
  final String? imageUrl;
  final double size;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final normalizedImageUrl = imageUrl?.trim();
    final fallback = _AvatarFallback(
      colors: colors,
      userName: userName,
      size: size,
      fontSize: fontSize,
    );

    if (normalizedImageUrl != null && normalizedImageUrl.isNotEmpty) {
      return DecibelCachedImage(
        imageUrl: normalizedImageUrl,
        width: size,
        height: size,
        shape: BoxShape.circle,
        placeholderIcon: Icons.person,
        errorIcon: Icons.person,
        iconSize: iconSize,
        iconColor: AppColors.textSecondary,
        placeholder: fallback,
        errorWidget: fallback,
      );
    }

    return fallback;
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

// ── Shared Content Elements ──────────────────────────────────────────────────

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
                      ),
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
  const _WaveformStrip({
    required this.trackId,
    required this.fallbackPeaks,
    required this.duration,
  });

  final int trackId;
  final List<double> fallbackPeaks;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final waveformAsync = ref.watch(trackWaveformDataProvider(trackId));
        final peaks = waveformAsync.maybeWhen(
          data: (waveformPeaks) =>
              waveformPeaks.isEmpty ? fallbackPeaks : waveformPeaks,
          orElse: () => fallbackPeaks,
        );

        return _WaveformPaint(peaks: peaks, duration: duration);
      },
    );
  }
}

class _WaveformPaint extends StatelessWidget {
  const _WaveformPaint({required this.peaks, required this.duration});

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
    required this.commentTrack,
    required this.plays,
    this.onAddToPlaylist,
    this.onAddToQueue,
    this.onEditTrack,
    this.onGoToArtist,
    this.onGoToAlbum,
    this.onShare,
    this.onCopyLink,
    this.onDownload,
    this.onDeleteTrack,
  });

  final int trackId;
  final int initialLikeCount;
  final int initialRepostCount;
  final bool initialIsLiked;
  final bool initialIsReposted;
  final int commentCount;
  final Track commentTrack;
  final String plays;
  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onAddToQueue;
  final VoidCallback? onEditTrack;
  final VoidCallback? onGoToArtist;
  final VoidCallback? onGoToAlbum;
  final VoidCallback? onShare;
  final VoidCallback? onCopyLink;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteTrack;

  @override
  ConsumerState<_DesktopFeedActions> createState() =>
      _DesktopFeedActionsState();
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
              await TrackCommentsBottomSheet.show(
                context,
                trackId: widget.trackId,
                track: widget.commentTrack,
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
                      color: _isCommentHovered
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    child: Text(_formatCount(_currentCommentCount)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        _DesktopMoreOptionsButton(
          trackId: widget.trackId,
          onAddToPlaylist: widget.onAddToPlaylist,
          onAddToQueue: widget.onAddToQueue,
          onEditTrack: widget.onEditTrack,
          onGoToArtist: widget.onGoToArtist,
          onGoToAlbum: widget.onGoToAlbum,
          onShare: widget.onShare,
          onCopyLink: widget.onCopyLink,
          onDownload: widget.onDownload,
          onDeleteTrack: widget.onDeleteTrack,
        ),
      ],
    );
  }
}

class _DesktopMoreOptionsButton extends ConsumerWidget {
  const _DesktopMoreOptionsButton({
    required this.trackId,
    this.onAddToPlaylist,
    this.onAddToQueue,
    this.onEditTrack,
    this.onGoToArtist,
    this.onGoToAlbum,
    this.onShare,
    this.onCopyLink,
    this.onDownload,
    this.onDeleteTrack,
  });

  final int trackId;

  final VoidCallback? onAddToPlaylist;
  final VoidCallback? onAddToQueue;
  final VoidCallback? onEditTrack;
  final VoidCallback? onGoToArtist;
  final VoidCallback? onGoToAlbum;
  final VoidCallback? onShare;
  final VoidCallback? onCopyLink;
  final VoidCallback? onDownload;
  final VoidCallback? onDeleteTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.isPro;

    return Builder(
      builder: (buttonContext) {
        return IconButton(
          tooltip: 'More options',
          onPressed: () async {
            final option = await showTrackMoreOptionsMenu(
              context: context,
              anchorContext: buttonContext,
              includeEdit: onEditTrack != null,
              includeDelete: onDeleteTrack != null,
              isPro: isPro,
            );
            if (option == null || !context.mounted) {
              return;
            }

            switch (option) {
              case TrackMoreOption.viewQueue:
                QueueBottomSheet.show(context);
                break;

              case TrackMoreOption.report:
                await TrackReportBottomSheet.show(context, trackId);
                break;

              case TrackMoreOption.addToPlaylist:
                onAddToPlaylist?.call();
                break;
              case TrackMoreOption.addToQueue:
                onAddToQueue?.call();
                break;

              case TrackMoreOption.editTrack:
                onEditTrack?.call();
                break;
              case TrackMoreOption.goToArtist:
                onGoToArtist?.call();
                break;
              case TrackMoreOption.goToAlbum:
                onGoToAlbum?.call();
                break;
              case TrackMoreOption.share:
                onShare?.call();
                break;
              case TrackMoreOption.copyLink:
                onCopyLink?.call();
                break;
              case TrackMoreOption.download:
                onDownload?.call();
                break;
              case TrackMoreOption.deleteTrack:
                onDeleteTrack?.call();
                break;
            }
          },
          icon: const Icon(
            Icons.more_horiz,
            color: AppColors.textSecondary,
            size: 20,
          ),
        );
      },
    );
  }
}
