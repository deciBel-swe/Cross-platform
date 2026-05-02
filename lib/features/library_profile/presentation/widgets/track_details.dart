import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../offline/presentation/providers/track_download_provider.dart';
import '../../../player/presentation/widgets/queue_bottom_sheet.dart';
import '../../../upgrade/presentation/widgets/pro_promotion_bottom_sheet.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/track_audio_provider.dart';
import '../providers/track_preview_provider.dart';
import '../providers/uploads_provider.dart';
import '../providers/user_profile_provider.dart';

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

    // Wait a short duration to let the mini player slide down before the bottom sheet covers the screen
    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

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

    final profileAsync = ref.watch(userProfileProvider);
    final isOwnTrack =
        currentUserId != null && currentUserId == track.artist.id;

    String? artistIdentifier() {
      final username = track.artist.username.trim();
      if (username.isNotEmpty) return username;
      if (track.artist.id > 0) return track.artist.id.toString();
      return null;
    }

    void goToArtist() {
      Navigator.of(context).pop();
      Future.microtask(() {
        if (!parentContext.mounted) return;

        if (isOwnTrack) {
          parentContext.go(RoutePaths.profile);
        } else {
          final identifier = artistIdentifier();
          if (identifier == null) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              const SnackBar(
                content: Text('Artist profile is unavailable for this track.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          parentContext.push(RoutePaths.publicProfile(identifier));
        }
      });
    }

    Future<void> copyTrackLink({String message = 'Track link copied'}) async {
      Navigator.of(context).pop();
      final link =
          'https://decibel.foo${RoutePaths.deepLinkTrack(track.artist.username, track.id.toString())}';

      await Clipboard.setData(ClipboardData(text: link));

      if (!parentContext.mounted) return;

      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }

    void showUnavailable(String message) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }

    final userProfile = profileAsync.valueOrNull?.fold(
      (_) => null,
      (profile) => profile,
    );

    final isPro =
        userProfile?.tier == UserTier.pro ||
        userProfile?.tier == UserTier.artistPro;

    Future<void> deleteTrack() async {
      final container = ProviderScope.containerOf(parentContext, listen: false);

      Navigator.of(context).pop();
      await Future<void>.delayed(Duration.zero);

      if (!parentContext.mounted) return;

      final confirmed = await _confirmDeleteTrack(parentContext);
      if (!confirmed || !parentContext.mounted) return;

      final messenger = ScaffoldMessenger.of(parentContext);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Deleting "${track.title}"...'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      final deleted = await container
          .read(uploadsProvider.notifier)
          .deleteTrack(track.id);

      if (!parentContext.mounted) return;

      messenger.hideCurrentSnackBar();

      if (deleted) {
        final audioState = container.read(trackAudioProvider);
        final audioNotifier = container.read(trackAudioProvider.notifier);

        if (audioState.preparedTrackId == track.id) {
          await audioNotifier.stop();
        }

        audioNotifier.removeFromQueue(track.id);
        container.invalidate(trackPreviewProvider(track.id));

        if (!parentContext.mounted) return;

        messenger.showSnackBar(
          SnackBar(
            content: Text('Deleted "${track.title}"'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete track'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errors,
        ),
      );
    }

    // const isPro = true;
    return _SheetContent(
      track: track,
      isPro: isPro,
      showEditAction: isOwnTrack,
      showDeleteAction: isOwnTrack,
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

        ScaffoldMessenger.of(parentContext).showSnackBar(
          SnackBar(
            content: Text('Added "${track.title}" to queue'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onOpenQueue: () {
        Navigator.of(context).pop();
        Future.microtask(() {
          if (parentContext.mounted) {
            QueueBottomSheet.show(parentContext);
          }
        });
      },
      onGoToArtist: goToArtist,
      onEditTrack: () {
        Navigator.of(context).pop();
        Future.microtask(() {
          if (parentContext.mounted) {
            parentContext.push(RoutePaths.trackEdit(track.id));
          }
        });
      },
      onGoToAlbum: () {
        showUnavailable('Album pages are not available yet');
      },
      onShare: () {
        unawaited(copyTrackLink(message: 'Track link copied to share'));
      },
      onCopyLink: () {
        unawaited(copyTrackLink());
      },
      onDownload: () {
        if (!isPro) {
          Navigator.of(context).pop();
          ProPromotionBottomSheet.show(parentContext);
          return;
        }

        ref.read(trackDownloadProvider.notifier).downloadTrack(track).then((_) {
          if (!parentContext.mounted) return;

          final state = ProviderScope.containerOf(
            parentContext,
          ).read(trackDownloadProvider);

          if (state.hasError) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              SnackBar(
                content: Text('Download failed: ${state.error}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.errors,
              ),
            );
          } else {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              SnackBar(
                content: Text('Downloaded "${track.title}"'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });

        ScaffoldMessenger.of(parentContext).showSnackBar(
          SnackBar(
            content: Text('Downloading "${track.title}"...'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        context.pop();
      },
      onDeleteTrack: deleteTrack,
    );
  }

  Future<bool> _confirmDeleteTrack(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text(
                'Delete track?',
                style: TextStyle(color: AppColors.onPrimary),
              ),
              content: Text(
                'This will permanently delete "${track.title}".',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.errors),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

// ─── Sheet content ────────────────────────────────────────────────────────────

class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.track,
    required this.isPro,
    required this.showEditAction,
    required this.showDeleteAction,
    required this.onAddToPlaylist,
    required this.onAddToQueue,
    required this.onOpenQueue,
    required this.onEditTrack,
    required this.onGoToArtist,
    required this.onGoToAlbum,
    required this.onShare,
    required this.onCopyLink,
    required this.onDownload,
    required this.onDeleteTrack,
  });

  final Track track;
  final bool isPro;
  final bool showEditAction;
  final bool showDeleteAction;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onAddToQueue;
  final VoidCallback onOpenQueue;
  final VoidCallback onEditTrack;
  final VoidCallback onGoToArtist;
  final VoidCallback onGoToAlbum;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;
  final VoidCallback onDownload;
  final Future<void> Function() onDeleteTrack;

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
      child: SingleChildScrollView(
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
              icon: Icons.featured_play_list_rounded,
              label: 'View queue',
              onTap: onOpenQueue,
            ),
            if (showEditAction)
              _ActionTile(
                icon: Icons.edit_outlined,
                label: 'Edit track',
                onTap: onEditTrack,
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
              icon: Icons.download_rounded,
              label: 'Download',
              onTap: onDownload,
              enabled: isPro,
              isDestructive: false,
            ),
            if (showDeleteAction)
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                label: 'Delete track',
                onTap: () => unawaited(onDeleteTrack()),
                isDestructive: true,
              ),
            // Safe-area bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
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
              mainAxisSize: MainAxisSize.min,
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
                Wrap(
                  spacing: AppConstants.spacingSmall,
                  runSpacing: AppConstants.spacingSmall,
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
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = !enabled
        ? AppColors.textHint
        : isDestructive
        ? AppColors.errors
        : AppColors.textSecondary;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingRegular,
          vertical: AppConstants.spacingMedium,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppConstants.iconSizeMedium + 2),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (!enabled)
              Icon(Icons.lock_outline_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
