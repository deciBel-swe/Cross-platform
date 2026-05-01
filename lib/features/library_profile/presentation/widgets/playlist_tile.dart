import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/presentation/providers/playlist_social_provider.dart';
import '../../../playlists/domain/entities/playlist.dart';
import '../../../playlists/presentation/widgets/playlist_options_bottom_sheet.dart';

class PlaylistTile extends ConsumerWidget {
  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onMorePressed,
    this.onLikePressed,
  });

  final Playlist playlist;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    // --- Custom Colors ---
    const activeLikeColor = Color(0xffff3f00);
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    final playlistSocial = ref.watch(playlistSocialProvider(playlist.id));
    final isLiked = playlistSocial.valueOrNull?.isLiked ?? playlist.isLiked;

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
                color: AppColors.surface,
                child: playlist.coverArt != null && playlist.coverArt!.isNotEmpty
                    ? DecibelCachedImage(
                        imageUrl: playlist.coverArt!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        placeholderIcon: Icons.playlist_play_rounded,
                        errorIcon: Icons.playlist_play_rounded,
                        iconSize: 32,
                        iconColor: Colors.grey,
                      )
                    : _buildPlaceholderIcon(),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),

            // --- 2. Playlist Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    playlist.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // "Playlist · Owner" Subtitle
                  Text(
                    "Playlist · ${playlist.owner?.displayName ?? playlist.owner?.username ?? 'System'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: subtitleColor),
                  ),
                  const SizedBox(height: 10),

                  // Stats Row (Tracks · Duration · Like)
                  Row(
                    children: [
                      // Playlist Icon
                      Icon(
                        Icons.playlist_play_rounded,
                        size: 18,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${playlist.trackCount} ${playlist.trackCount == 1 ? 'track' : 'tracks'}',
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Separator
                      _buildDotSeparator(subtitleColor),

                      // Duration
                      Text(
                        _formatDuration(Duration(seconds: playlist.totalDurationSeconds)),
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Separator
                      _buildDotSeparator(subtitleColor),

                      // Interactive Like Heart
                      GestureDetector(
                        onTap: () {
                          if (onLikePressed != null) {
                            onLikePressed!();
                          } else {
                            ref
                                .read(playlistSocialProvider(playlist.id).notifier)
                                .toggleLike();
                          }
                        },
                        behavior: HitTestBehavior.opaque,
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
              onPressed: onMorePressed ??
                  () => PlaylistOptionsBottomSheet.show(context, playlist),
              color: subtitleColor,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Icon(Icons.playlist_play_rounded, color: Colors.grey, size: 32);
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${duration.inMinutes.remainder(60)}:$twoDigitSeconds";
    }
  }
}
