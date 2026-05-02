import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ref_pro_check_extension.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../engagement/presentation/widgets/track_report_bottom_sheet.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/presentation/providers/track_comment_provider.dart';
import '../../../library/presentation/widgets/bottom_bar_widget.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';
import '../../../library_profile/presentation/widgets/track_preview_background.dart';
import '../../../library_profile/presentation/widgets/track_preview_info.dart';
import '../../../library_profile/presentation/widgets/track_preview_playback_overlay.dart';
import '../../../library_profile/presentation/widgets/track_preview_top_bar.dart';
import '../../../offline/presentation/providers/track_download_provider.dart';
import '../../../player/presentation/widgets/queue_bottom_sheet.dart';
import 'active_comments_overlay.dart';
import 'interactive_waveform.dart';
import 'track_comments_bottom_sheet.dart';
import 'track_more_options_menu.dart';
import 'track_preview_input_section.dart';
import 'waveform_not_ready.dart';

class TrackPreviewContent extends ConsumerWidget {
  const TrackPreviewContent({
    super.key,
    required this.trackId,
    required this.data,
    this.onMinimize,
  });

  final int trackId;
  final TrackPreviewData data;
  final VoidCallback? onMinimize;

  /// Builds the full track preview, playback area, comments, and action bar.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = data.track;
    final trackPeaks = data.trackPeaks;
    final isPro = ref.isPro;

    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);
    final playbackUi = ref.watch(trackPreviewPlaybackUiStateProvider);
    final commentsState = ref.watch(trackCommentsProvider(trackId));
    final authState = ref.watch(authStateProvider).valueOrNull;
    final isOwner = authState is AuthAuthenticated
        ? authState.user.id == track.artist.id ||
              authState.user.username.trim().toLowerCase() ==
                  track.artist.username.trim().toLowerCase()
        : false;

    final isReady = trackPeaks != null;
    final peaks = isReady
        ? ref.watch(trackPreviewNormalizedPeaksProvider(trackId))
        : null;

    final mainArea = Semantics(
      container: true,
      label:
          'Track preview content for ${track.title} by ${track.artist.username}',
      child: Stack(
        children: [
          TrackPreviewBackground(
            imageUrl: track.coverUrl,
            isBlurred: isReady ? playbackUi.shouldBlurBackground : true,
          ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TrackPreviewTopBar(onMore: onMinimize),
                      const SizedBox(height: 16),
                      TrackPreviewInfo(
                        title: track.title,
                        artistName: track.artist.username,
                        tagLabel: track.isPreviewOnly
                            ? 'PREVIEW'
                            : 'Behind this track',
                        onTagTap: () {
                          context.push(RoutePaths.behindTrack(trackId));
                        },
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ActiveCommentsOverlay(trackId: trackId),
                      ),
                      const SizedBox(height: 12),
                      if (isReady)
                        InteractiveWaveform(
                          peaks: peaks!,
                          audioState: audioState,
                          audioNotifier: audioNotifier,
                        )
                      else
                        const WaveformNotReady(),
                      const SizedBox(height: 16),
                      TrackPreviewInputSection(trackId: trackId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: isReady
              ? TrackPreviewPlaybackOverlay(
                  showPlayIcon: playbackUi.showPlayIcon,
                  onToggle: () async {
                    if (audioState.isPreparing) return;
                    if (audioState.isPlaying) {
                      await audioNotifier.pause();
                    } else {
                      await audioNotifier.play();
                    }
                  },
                  child: mainArea,
                )
              : mainArea,
        ),
        Semantics(
          container: true,
          label: 'Track actions for ${track.title}',
          child: BottomBarWidget(
            trackId: trackId,
            initialLikeCount: track.likeCount,
            initialRepostCount: track.repostCount,
            isLiked: track.isLiked,
            isReposted: track.isReposted,
            commentCount: commentsState.comments.length,
            onCommentPressed: () {
              TrackCommentsBottomSheet.show(
                context,
                trackId: trackId,
                track: track,
              );
            },
            onSharePressed: () {
              _copyTrackLink(
                context: context,
                track: track,
                message: 'Track link copied to share',
              );
            },
            onAddToPlaylistPressed: () async {
              await Future<void>.delayed(Duration.zero);
              if (context.mounted) {
                context.push(RoutePaths.addToPlaylist, extra: track);
              }
            },
            onMoreOptionsPressed: (anchorContext) async {
              final action = await showTrackMoreOptionsMenu(
                context: context,
                anchorContext: anchorContext,
                includeEdit: isOwner,
                includeDelete: isOwner,
                isPro: isPro,
              );

              if (action == null || !context.mounted) {
                return;
              }

              switch (action) {
                case TrackMoreOption.report:
                  await TrackReportBottomSheet.show(context, trackId);
                  break;
                case TrackMoreOption.addToPlaylist:
                  context.push(RoutePaths.addToPlaylist, extra: track);
                  break;
                case TrackMoreOption.addToQueue:
                  audioNotifier.addToQueue(track);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added "${track.title}" to queue'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  break;
                case TrackMoreOption.viewQueue:
                  QueueBottomSheet.show(context);
                  break;
                case TrackMoreOption.editTrack:
                  await context.push(RoutePaths.trackEdit(trackId));
                  break;
                case TrackMoreOption.goToArtist:
                  if (isOwner) {
                    context.go(RoutePaths.profile);
                  } else {
                    context.go(RoutePaths.publicProfile(track.artist.username));
                  }
                  break;
                case TrackMoreOption.goToAlbum:
                  _showUnavailableSnackBar(
                    context,
                    'Album pages are not available yet',
                  );
                  break;
                case TrackMoreOption.share:
                  await _copyTrackLink(
                    context: context,
                    track: track,
                    message: 'Track link copied to share',
                  );
                  break;
                case TrackMoreOption.copyLink:
                  await _copyTrackLink(context: context, track: track);
                  break;
                case TrackMoreOption.download:
                  await _downloadTrack(
                    context: context,
                    ref: ref,
                    track: track,
                  );
                  break;
                case TrackMoreOption.deleteTrack:
                  await _deleteTrack(context: context, ref: ref, track: track);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  /// Copies the track deep link and reports success to the user.
  Future<void> _copyTrackLink({
    required BuildContext context,
    required Track track,
    String message = 'Track link copied',
  }) async {
    final link =
        'https://decibel.foo${RoutePaths.deepLinkTrack(track.artist.username, track.id.toString())}';
    await Clipboard.setData(ClipboardData(text: link));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  /// Downloads [track] and reports the result to the user.
  Future<void> _downloadTrack({
    required BuildContext context,
    required WidgetRef ref,
    required Track track,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Downloading "${track.title}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await ref.read(trackDownloadProvider.notifier).downloadTrack(track);
    if (!context.mounted) {
      return;
    }

    final state = ref.read(trackDownloadProvider);
    messenger.hideCurrentSnackBar();
    if (state.hasError) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Download failed: ${state.error}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errors,
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('Downloaded "${track.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows a short snackbar for an unavailable action.
  void _showUnavailableSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  /// Confirms and deletes [track].
  Future<void> _deleteTrack({
    required BuildContext context,
    required WidgetRef ref,
    required Track track,
  }) async {
    final confirmed = await _confirmDeleteTrack(context: context, track: track);
    if (!confirmed || !context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleting "${track.title}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final deleted = await ref
        .read(uploadsProvider.notifier)
        .deleteTrack(track.id);
    if (!context.mounted) {
      return;
    }

    messenger.hideCurrentSnackBar();
    if (!deleted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete track'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errors,
        ),
      );
      return;
    }

    final audioNotifier = ref.read(trackAudioProvider.notifier);
    await audioNotifier.removeDeletedTrack(track.id);
    ref.invalidate(trackPreviewProvider(track.id));

    if (!context.mounted) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${track.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go(RoutePaths.uploadLibrary);
    }
  }

  /// Shows the destructive confirmation dialog for [track].
  Future<bool> _confirmDeleteTrack({
    required BuildContext context,
    required Track track,
  }) async {
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
