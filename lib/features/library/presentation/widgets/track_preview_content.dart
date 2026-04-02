import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/presentation/widgets/bottom_bar_widget.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/track_preview_derived_providers.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/widgets/track_preview_background.dart';
import '../../../library_profile/presentation/widgets/track_preview_info.dart';
import '../../../library_profile/presentation/widgets/track_preview_playback_overlay.dart';
import '../../../library_profile/presentation/widgets/track_preview_top_bar.dart';
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

    final isReady = trackPeaks != null;
    final peaks = isReady
        ? ref.watch(trackPreviewNormalizedPeaksProvider(trackId))
        : null;

    final contentColumn = Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
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
                            const TrackPreviewTopBar(),
                            const SizedBox(height: 16),
                            TrackPreviewInfo(
                              title: track.title,
                              artistName: track.artist.username,
                              tagLabel: 'Behind this track',
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: ActiveCommentsOverlay(trackId: trackId),
                            ),
                            const SizedBox(height: 12),
                            if (isReady)
                              InteractiveWaveform(
                                peaks: peaks as List<double>,
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
          ),
        ),
        BottomBarWidget(
          isLiked: isReady,
          likeCount: 28,
          commentCount: 3,
          onLikePressed: () {},
          onCommentPressed: () {
            TrackCommentsBottomSheet.show(
              context,
              trackId: trackId,
              track: track,
            );
          },
          onSharePressed: () {},
          onPlaylistAddPressed: () {},
          onMoreOptionsPressed: () {},
        ),
      ],
    );

    if (!isReady) return contentColumn;

    return TrackPreviewPlaybackOverlay(
      showPlayIcon: playbackUi.showPlayIcon,
      onToggle: () async {
        if (audioState.isPreparing) return;
        if (audioState.isPlaying) {
          await audioNotifier.pause();
        } else {
          await audioNotifier.play();
        }
      },
      child: contentColumn,
    );
  }
}
