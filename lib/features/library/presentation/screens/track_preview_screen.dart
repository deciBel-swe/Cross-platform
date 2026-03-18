import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../providers/track_audio_provider.dart';
import '../providers/track_preview_provider.dart';
import '../widgets/track_preview_background.dart';
import '../widgets/track_preview_info.dart';
import '../widgets/track_preview_playback_overlay.dart';
import '../widgets/track_preview_top_bar.dart';
import '../widgets/track_preview_waveform_section.dart';

typedef TrackPreviewData = ({Track track, TrackPeaks? trackPeaks});

class TrackPreviewScreen extends ConsumerStatefulWidget {
  const TrackPreviewScreen({super.key});

  @override
  ConsumerState<TrackPreviewScreen> createState() => _TrackPreviewScreenState();
}

class _TrackPreviewScreenState extends ConsumerState<TrackPreviewScreen> {
  ProviderSubscription<AsyncValue<TrackPreviewData>>? _previewSubscription;

  @override
  void initState() {
    super.initState();

    _previewSubscription = ref.listenManual<AsyncValue<TrackPreviewData>>(
      trackPreviewProvider,
      (previous, next) {
        next.whenData((data) async {
          final trackPeaks = data.trackPeaks;
          if (trackPeaks == null) {
            return;
          }

          final trackUrl = data.track.trackUrl;
          if (trackUrl == null || trackUrl.isEmpty) {
            return;
          }

          await ref
              .read(trackAudioProvider.notifier)
              .initializeForTrack(
                trackId: data.track.id,
                trackUrl: trackUrl,
                duration: Duration(seconds: trackPeaks.duration),
                autoPlay: true,
              );
        });
      },
    );
  }

  @override
  void dispose() {
    _previewSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(trackPreviewProvider);
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);

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

          final peaks = _normalizePeaks(trackPeaks.peaks);

          final displayedPosition = audioState.isDragging
              ? Duration(
                  milliseconds:
                      (audioState.duration.inMilliseconds * audioState.progress)
                          .round(),
                )
              : audioState.position;

          final shouldBlurBackground =
              !audioState.isPlaying || audioState.isDragging;

          final showPlayIcon = !audioState.isPlaying && !audioState.isDragging;

          return TrackPreviewPlaybackOverlay(
            showPlayIcon: showPlayIcon,
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
    );
  }

  List<double> _normalizePeaks(List<num> sourcePeaks) {
    final rawPeaks = sourcePeaks.map((peak) => peak.toDouble()).toList();

    if (rawPeaks.isEmpty) {
      return const [];
    }

    final maxPeak = rawPeaks.reduce((a, b) => a > b ? a : b);

    if (maxPeak == 0) {
      return rawPeaks.map((_) => 0.0).toList();
    }

    return rawPeaks.map((peak) => peak / maxPeak).toList();
  }
}
