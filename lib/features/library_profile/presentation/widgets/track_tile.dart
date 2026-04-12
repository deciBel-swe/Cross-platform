import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/domain/models/track_action_data.dart';
import '../../../engagement/presentation/providers/track_social_provider.dart';
import '../../../library/domain/entities/track.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.track,
    this.onTap,
    this.onMorePressed,
  });
  final Track track;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    // --- Custom Colors ---
    // The specific orange color for the active heart from your design
    const activeLikeColor = Color(0xffff3f00);

    // High contrast for the title, muted for the subtitle/stats
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    final trackSocialState = ref.watch(trackSocialProvider);
    final socialData = trackSocialState.trackStates[track.id.toString()];
    final isLiked = socialData?.isLiked ?? track.isLiked;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Cover Image ---
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              child: Container(
                width: 72,
                height: 72,
                color: AppColors.surface, // Placeholder background
                child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                    ? DecibelCachedImage(
                        imageUrl: track.coverUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        placeholderIcon: Icons.music_note_rounded,
                        errorIcon: Icons.music_note_rounded,
                        iconSize: 32,
                        iconColor: Colors.grey,
                      )
                    : _buildPlaceholderIcon(),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),

            // --- 2. Track Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Title (Artist - Title)
                  Text(
                    "${track.artist.displayName ?? track.artist.username} - ${track.title}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Artist Name Subtitle
                  Text(
                    track.artist.displayName ?? track.artist.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: subtitleColor),
                  ),
                  const SizedBox(height: 10),

                  // Stats Row (Plays · Duration · Like)
                  Row(
                    children: [
                      // Play Icon & Count
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 18,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(track.playCount),
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Separator
                      _buildDotSeparator(subtitleColor),

                      // Duration
                      Text(
                        _formatDuration(_displayDuration(track)),
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Separator
                      _buildDotSeparator(subtitleColor),

                      // Interactive Like Heart
                      GestureDetector(
                        onTap: () => ref
                            .read(trackSocialProvider.notifier)
                            .toggleAction(
                              track.id,
                              SocialActionType.like,
                              initialLikeCount: track.likeCount,
                              initialRepostCount: track.repostCount,
                              initialIsLiked: isLiked,
                            ),
                        behavior: HitTestBehavior
                            .opaque, // Ensures the padding is clickable
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: isLiked ? activeLikeColor : subtitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 3. Trailing Menu Button ---
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMorePressed,
              color: subtitleColor,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(), // Removes default padding for tighter layout
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildPlaceholderIcon() {
    return const Icon(Icons.music_note_rounded, color: Colors.grey, size: 32);
  }

  Widget _buildDotSeparator(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        "·",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Formatting Helpers ---

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      // Formats 123000 as 123K, and 1500 as 1.5K
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      // Remove leading zero for single-digit minutes (e.g., "4:02" instead of "04:02")
      return "${duration.inMinutes.remainder(60)}:$twoDigitSeconds";
    }
  }

  Duration _displayDuration(Track track) {
    final seconds = track.releaseDate
        .difference(track.createdAt)
        .inSeconds
        .abs();
    return Duration(seconds: seconds);
  }
}
