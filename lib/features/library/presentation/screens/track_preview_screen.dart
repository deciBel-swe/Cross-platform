import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/track_audio_provider.dart';
import '../providers/track_preview_derived_providers.dart';
import '../providers/track_preview_provider.dart';
import '../widgets/track_preview_background.dart';
import '../widgets/track_preview_info.dart';
import '../widgets/track_preview_playback_overlay.dart';
import '../widgets/track_preview_top_bar.dart';
import '../widgets/track_preview_waveform_section.dart';

class TrackPreviewScreen extends ConsumerWidget {
  const TrackPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effects (audio initialization) live in providers.
    ref.watch(trackPreviewAutoAudioInitProvider);

    final previewAsync = ref.watch(trackPreviewProvider);
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);
    final playbackUi = ref.watch(trackPreviewPlaybackUiStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF08131B),
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Failed to load preview.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (data) {
          final track = data.track;
          final trackPeaks = data.trackPeaks;

          if (trackPeaks == null) {
            return Stack(
              children: [
                TrackPreviewBackground(
                  imageUrl: track.coverUrl,
                  isBlurred: true,
                ),
                SafeArea(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Waveform is not ready yet.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          }

          final peaks = ref.watch(trackPreviewNormalizedPeaksProvider);

          return TrackPreviewPlaybackOverlay(
            showPlayIcon: playbackUi.showPlayIcon,
            onToggle: () async {
              if (audioState.isPreparing) {
                return;
              }

              if (audioState.isPlaying) {
                await audioNotifier.pause();
              } else {
                await audioNotifier.play();
              }
            },
            child: Stack(
              children: [
                TrackPreviewBackground(
                  imageUrl: track.coverUrl,
                  isBlurred: playbackUi.shouldBlurBackground,
                ),
                SafeArea(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onHorizontalDragStart: (_) {
                                audioNotifier.onDragStart();
                              },
                              onHorizontalDragUpdate: (details) {
                                final progress =
                                    (details.localPosition.dx /
                                            constraints.maxWidth)
                                        .clamp(0.0, 1.0);

                                audioNotifier.onDragUpdate(progress);
                              },
                              onHorizontalDragEnd: (_) async {
                                await audioNotifier.onDragEnd(
                                  audioState.progress,
                                );
                              },
                              child: TrackWaveform(
                                peaks: peaks,
                                currentPosition: playbackUi.displayedPosition,
                                totalDuration: audioState.duration,
                                height: 140,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
