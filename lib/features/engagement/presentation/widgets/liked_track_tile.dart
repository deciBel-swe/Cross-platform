import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../library/domain/entities/track.dart';

/// A widget that represents a track the user has liked.
/// It combines the visual distinctness of a "Card" with the horizontal
/// layout of a "Tile", optimized for vertical list views.
class LikedTrackTile extends StatelessWidget {
  const LikedTrackTile({
    super.key,
    required this.track,
    required this.onUnlike,
    this.onTap,
  });

  final Track track;
  final VoidCallback onUnlike;
  final VoidCallback? onTap;

  String _resolveImageUrl(String? url, int trackId) {
    if (url == null || url.isEmpty) return '';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final cardColor = isDark ? AppColors.surfaceContainer : Colors.white;

    final resolvedImageUrl = _resolveImageUrl(track.coverUrl, track.id);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: AppColors.onBackground,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Cover Art ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.buttonRadius - 2,
                  ),
                  child: Container(
                    width: 64,
                    height: 64,
                    color: AppColors.surface,
                    child: resolvedImageUrl.isNotEmpty
                        ? Image.network(
                            resolvedImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                ),
                          )
                        : const Icon(Icons.music_note, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),

                // --- Track Info ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.artist.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Unlike Button ---
                IconButton(
                  onPressed: onUnlike,
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.primary, // Red/Orange active heart
                  ),
                  tooltip: 'Unlike',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
