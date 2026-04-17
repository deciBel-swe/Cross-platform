import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/track_options_bottom_sheet.dart';
import '../../../auth/domain/entities/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library/presentation/notifiers/track_comment_notifier.dart';
import '../../../library/presentation/widgets/bottom_bar_widget.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/widgets/track_preview_background.dart';
import '../../../library_profile/presentation/widgets/track_preview_info.dart';
import '../../../library_profile/presentation/widgets/track_preview_playback_overlay.dart';
import '../../../library_profile/presentation/widgets/track_preview_top_bar.dart';
import '../../../player/presentation/widgets/queue_bottom_sheet.dart';
import 'active_comments_overlay.dart';
import 'interactive_waveform.dart';
import 'track_comments_bottom_sheet.dart';
import 'track_preview_input_section.dart';
import 'waveform_not_ready.dart';

class TrackPreviewContent extends ConsumerWidget {
  const TrackPreviewContent({
    super.key,
    required this.trackId,
    required this.data,
  });

  final int trackId;
  final TrackPreviewData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = data.track;
    final trackPeaks = data.trackPeaks;

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

    final mainArea = Stack(
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
                    const TrackPreviewTopBar(),
                    const SizedBox(height: 16),
                    TrackPreviewInfo(
                      title: track.title,
                      artistName: track.artist.username,
                      tagLabel: 'Behind this track',
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
        BottomBarWidget(
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
          onSharePressed: () {},
          onAddToPlaylistPressed: () async {
            await Future<void>.delayed(Duration.zero);
            if (context.mounted) {
              context.push(RoutePaths.addToPlaylist, extra: track);
            }
          },
          onMoreOptionsPressed: () async {
            final action = await showTrackOptionsBottomSheet(
              context: context,
              isOwner: isOwner,
            );

            if (!context.mounted) return;

            switch (action) {
              case TrackOptionsAction.queue:
                await QueueBottomSheet.show(context);
              case TrackOptionsAction.edit:
                await context.push(RoutePaths.trackEdit(trackId));
              case TrackOptionsAction.addToPlaylist:
                await context.push(RoutePaths.addToPlaylist, extra: track);
              case TrackOptionsAction.cancel:
              case null:
                break;
            }
          },
        ),
      ],
    );
  }
}
