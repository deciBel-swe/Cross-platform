import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decibel_cached_image.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/presentation/widgets/like_button.dart';
import '../../../engagement/presentation/widgets/repost_button.dart';
import '../../../library/domain/entities/track.dart';
import '../providers/track_audio_provider.dart';

/// A SoundCloud-style bottom sheet showing quick actions for a [Track].
///
/// Show it with:
/// ```dart
/// TrackDetails.show(context, track, ref);
/// ```
class TrackDetails extends ConsumerWidget {
  const TrackDetails({
    super.key,
    required this.track,
    required this.parentContext,
  });

  final Track track;
  final BuildContext parentContext;

  // ─── Static launcher ───────────────────────────────────────────────────────

  /// Shows the bottom sheet and temporarily hides the persistent mini player
  /// so it doesn't paint on top of the sheet content.
  ///
  /// Requires a [WidgetRef] so it can toggle [miniPlayerVisibleProvider].
  static Future<void> show(
    BuildContext context,
    Track track,
    WidgetRef ref,
  ) async {
    // Hide the mini player before the sheet appears.
    final miniPlayerNotifier = ref.read(miniPlayerVisibleProvider.notifier);
    miniPlayerNotifier.state = false;
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black54,
        builder: (_) => TrackDetails(track: track, parentContext: context),
      );
    } finally {
      // Always restore the mini player, even if the sheet throws.
      miniPlayerNotifier.state = true;
      // ref.read(miniPlayerVisibleProvider.notifier).state = true;
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : null;

    final isOwnTrack =
        currentUserId != null && currentUserId == track.artist.id;

    void goToArtist() {
      context.pop(); // dismiss the sheet first
      if (isOwnTrack) {
        context.go(RoutePaths.profile);
      } else {
        context.push(RoutePaths.publicProfile(track.artist.username));
      }
    }

    return _SheetContent(
      track: track,
      onAddToPlaylist: () {
        // Close the sheet, then push the AddToPlaylist route using the parent
        // context (the one that opened this sheet) so navigation uses an
        // active context and doesn't complete a future twice.
        Navigator.of(context).pop();
        Future.microtask(() {
          if (parentContext.mounted) {
            parentContext.push(RoutePaths.addToPlaylist, extra: track);
          }
        });
      },
      onAddToQueue: () {
        ref.read(trackAudioProvider.notifier).addToQueue(track);
        context.pop();
      },
      onGoToArtist: goToArtist,
      onGoToAlbum: () {
        /* dummy */
      },
      onShare: () {
        /* dummy */
      },
      onCopyLink: () {
        /* dummy */
      },
      onReport: () {
        /* dummy */
      },
    );
  }
}

// ─── Sheet content ────────────────────────────────────────────────────────────

class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.track,
    required this.onAddToPlaylist,
    required this.onAddToQueue,
    required this.onGoToArtist,
    required this.onGoToAlbum,
    required this.onShare,
    required this.onCopyLink,
    required this.onReport,
  });

  final Track track;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onAddToQueue;
  final VoidCallback onGoToArtist;
  final VoidCallback onGoToAlbum;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;
  final VoidCallback onReport;

  // ── Formatting helpers ────────────────────────────────────────────────────

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  Duration _trackDuration(Track t) {
    final seconds = t.releaseDate.difference(t.createdAt).inSeconds.abs();
    return Duration(seconds: seconds);
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
    }
    return '${d.inMinutes.remainder(60)}:${two(d.inSeconds.remainder(60))}';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final artistName = track.artist.displayName ?? track.artist.username;
    final duration = _trackDuration(track);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          const _DragHandle(),

          // ── Track header ────────────────────────────────────────────────
          _TrackHeader(
            track: track,
            artistName: artistName,
            duration: duration,
            formatDuration: _formatDuration,
            formatCount: _formatCount,
          ),

          const Divider(
            color: AppColors.borderDark,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),

          // ── Engagement row — global LikeButton + RepostButton ───────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingRegular,
              vertical: AppConstants.spacingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LikeButton(
                  trackId: track.id,
                  isLiked: track.isLiked,
                  likeCount: track.likeCount,
                  iconSize: 24,
                  fontSize: AppConstants.fontSizeRegular,
                ),
                Container(width: 1, height: 28, color: AppColors.borderDark),
                RepostButton(
                  trackId: track.id,
                  isReposted: track.isReposted,
                  repostCount: track.repostCount,
                  iconSize: 24,
                  fontSize: AppConstants.fontSizeRegular,
                ),
              ],
            ),
          ),

          const Divider(
            color: AppColors.borderDark,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),

          // ── Action list ─────────────────────────────────────────────────
          _ActionTile(
            icon: Icons.playlist_add_rounded,
            label: 'Add to playlist',
            onTap: onAddToPlaylist,
          ),
          _ActionTile(
            icon: Icons.queue_music_rounded,
            label: 'Add to queue',
            onTap: onAddToQueue,
          ),
          _ActionTile(
            icon: Icons.person_outline_rounded,
            label: 'Go to artist',
            onTap: onGoToArtist,
          ),
          _ActionTile(
            icon: Icons.album_rounded,
            label: 'Go to album',
            onTap: onGoToAlbum,
          ),
          _ActionTile(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: onShare,
          ),
          _ActionTile(
            icon: Icons.link_rounded,
            label: 'Copy link',
            onTap: onCopyLink,
          ),
          _ActionTile(
            icon: Icons.flag_outlined,
            label: 'Report',
            onTap: onReport,
            isDestructive: true,
          ),

          // Safe-area bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.borderDark,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _TrackHeader extends StatelessWidget {
  const _TrackHeader({
    required this.track,
    required this.artistName,
    required this.duration,
    required this.formatDuration,
    required this.formatCount,
  });

  final Track track;
  final String artistName;
  final Duration duration;
  final String Function(Duration) formatDuration;
  final String Function(int) formatCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingRegular,
        vertical: AppConstants.spacingMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cover art
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            child: Container(
              width: 56,
              height: 56,
              color: AppColors.surfaceVariant,
              child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                  ? DecibelCachedImage(
                      imageUrl: track.coverUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholderIcon: Icons.music_note_rounded,
                      errorIcon: Icons.music_note_rounded,
                      iconSize: 28,
                      iconColor: AppColors.textMuted,
                    )
                  : const Icon(
                      Icons.music_note_rounded,
                      color: AppColors.textMuted,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),

          // Title + artist + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.play_arrow_rounded,
                      label: formatCount(track.playCount),
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    _MetaChip(
                      icon: Icons.access_time_rounded,
                      label: formatDuration(duration),
                    ),
                    if (track.genre.isNotEmpty) ...[
                      const SizedBox(width: AppConstants.spacingSmall),
                      _GenreChip(genre: track.genre),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.genre});

  final String genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Text(
        genre,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.errors : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingRegular,
          vertical: AppConstants.spacingMedium,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppConstants.iconSizeMedium + 2),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
