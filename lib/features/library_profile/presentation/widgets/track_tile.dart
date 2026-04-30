import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../engagement/domain/models/track_action_data.dart';
import '../../../engagement/presentation/providers/track_social_provider.dart';
import '../../../library/domain/entities/track.dart';
import '../providers/track_audio_provider.dart';
import 'track_details.dart';

class TrackTile extends ConsumerWidget {
  const TrackTile({
    super.key,
    required this.track,
    this.onTap,
    this.onMorePressed,
    this.onLikePressed,
  });
  final Track track;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    const activeLikeColor = Color(0xffff3f00);

    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;

    final trackSocial = ref.watch(trackSocialProvider(track.id));
    final isLiked = trackSocial.valueOrNull?.isLiked ?? track.isLiked;

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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              child: Container(
                width: 72,
                height: 72,
                color: AppColors.surface,
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

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  Text(
                    track.artist.displayName ?? track.artist.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(color: subtitleColor),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 18,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatCount(track.playCount),
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      _buildDotSeparator(subtitleColor),

                      Text(
                        Formatters.formatDuration(_displayDuration(track, ref)),
                        style: textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      _buildDotSeparator(subtitleColor),

                      GestureDetector(
                        onTap: () => ref
                            .read(trackSocialProvider(track.id).notifier)
                            .toggleAction(SocialActionType.like),
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

            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => TrackDetails.show(context, track, ref),
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

  Duration _displayDuration(Track track, WidgetRef ref) {
    if (ref.read(trackAudioProvider).preparedTrackId == track.id) {
      return ref.read(trackAudioProvider).duration;
    }

    return Duration.zero;
  }
}
