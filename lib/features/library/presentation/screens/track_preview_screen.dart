import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/track_audio_provider.dart';
import '../providers/track_preview_test_provider.dart';
import '../widgets/track_preview_background.dart';
import '../widgets/track_preview_info.dart';
import '../widgets/track_preview_playback_overlay.dart';
import '../widgets/track_preview_top_bar.dart';
import '../widgets/track_preview_waveform_section.dart';

class TrackPreviewScreen extends ConsumerStatefulWidget {
  const TrackPreviewScreen({super.key});

  @override
  ConsumerState<TrackPreviewScreen> createState() => _TrackPreviewScreenState();
}

class _TrackPreviewScreenState extends ConsumerState<TrackPreviewScreen> {
  bool _isPrepared = false;
  bool _isPreparing = false;

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(firstTrackPreviewProvider);
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);

    return PopScope(
      canPop: true,

      ///make sure to stop the audio when leaving the screen, even if the user uses a system back gesture or button
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await ref.read(trackAudioProvider.notifier).stop(resetState: false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF08131B),
        // The entire screen is a stack of the background, waveform, and info layers
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

            final rawPeaks = trackPeaks.peaks
                .map((peak) => peak.toDouble())
                .toList();

            final maxPeak = rawPeaks.isEmpty
                ? 1.0
                : rawPeaks.reduce((a, b) => a > b ? a : b);

            final peaks = rawPeaks.map((peak) {
              if (maxPeak == 0) {
                return 0.0;
              }
              return peak / maxPeak;
            }).toList();

            final totalDuration = Duration(seconds: trackPeaks.duration);

            if (!_isPrepared && !_isPreparing) {
              _isPreparing = true;

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;

                try {
                  await audioNotifier.prepare(
                    trackUrl: track.trackUrl,
                    duration: totalDuration,
                  );

                  await audioNotifier.play();

                  if (!mounted) return;

                  setState(() {
                    _isPrepared = true;
                    _isPreparing = false;
                  });
                } catch (e) {
                  debugPrint('Track preview prepare error: $e');

                  if (!mounted) return;

                  setState(() {
                    _isPreparing = false;
                  });
                }
              });
            }

            final displayedPosition = audioState.isDragging
                ? Duration(
                    milliseconds:
                        (audioState.duration.inMilliseconds *
                                audioState.progress)
                            .round(),
                  )
                : audioState.position;

            final shouldBlurBackground =
                !audioState.isPlaying || audioState.isDragging;

            final showPlayIcon =
                !audioState.isPlaying && !audioState.isDragging;

            return TrackPreviewPlaybackOverlay(
              showPlayIcon: showPlayIcon,
              onToggle: () async {
                if (_isPreparing) return;

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
                    isBlurred: shouldBlurBackground,
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
                                  currentPosition: displayedPosition,
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
      ),
    );
  }
}
