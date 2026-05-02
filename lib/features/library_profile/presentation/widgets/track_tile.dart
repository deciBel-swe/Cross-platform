import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/ref_pro_check_extension.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/domain/models/track_action_data.dart';
import '../../../engagement/presentation/providers/track_social_provider.dart';
import '../../../library/domain/entities/track.dart';
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
    final isPro = ref.isPro;

    final authState = ref.watch(authStateProvider).valueOrNull;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : null;
    final isOwner = currentUserId != null && currentUserId == track.artist.id;
    final isBlockedForViewer = track.isBlocked && !isOwner && !isPro;

    return InkWell(
      onTap: () => _handleTap(context, isOwner: isOwner, isPro: isPro),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
        child: Opacity(
          opacity: isBlockedForViewer ? 0.5 : 1.0,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${track.artist.displayName ?? track.artist.username} - ${track.title}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (track.isPreviewOnly) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF3F00),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PREVIEW',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),

                    Text(
                      track.artist.displayName ?? track.artist.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: subtitleColor,
                      ),
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
                          Formatters.formatDuration(
                            _displayDuration(track, ref),
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        _buildDotSeparator(subtitleColor),

                        // Interactive Like Heart
                        Semantics(
                          button: true,
                          label: isLiked ? 'Unlike track' : 'Like track',
                          child: GestureDetector(
                            onTap: () => ref
                                .read(trackSocialProvider(track.id).notifier)
                                .toggleAction(SocialActionType.like),
                            behavior: HitTestBehavior
                                .opaque, // Ensures the padding is clickable
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 16,
                                color: isLiked
                                    ? activeLikeColor
                                    : subtitleColor,
                              ),
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
                tooltip: 'More track options',
                onPressed: () => TrackDetails.show(context, track, ref),
                color: subtitleColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(
    BuildContext context, {
    required bool isOwner,
    required bool isPro,
  }) {
    if (track.isBlocked && !isOwner && !isPro) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${track.title} is blocked and cannot be played.'),
          backgroundColor: AppColors.errors,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    onTap?.call();
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
    return track.duration;
  }
}
