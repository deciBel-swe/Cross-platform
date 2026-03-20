import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'track_audio_provider.dart';
import 'track_preview_provider.dart';

typedef TrackPreviewPlaybackUiState = ({
  Duration displayedPosition,
  bool shouldBlurBackground,
  bool showPlayIcon,
});

//made it a family provider to be able to preview something correct if authenticated user has been routed to the page immediately without having to click on it
final trackPreviewAutoAudioInitProvider = Provider.autoDispose
    .family<void, int>((ref, trackId) {
      ref.listen<AsyncValue<TrackPreviewData>>(trackPreviewProvider(trackId), (
        previous,
        next,
      ) {
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
      }, fireImmediately: true);
    });

final trackPreviewNormalizedPeaksProvider = Provider.autoDispose
    .family<List<double>, int>((ref, trackId) {
      final previewAsync = ref.watch(trackPreviewProvider(trackId));

      return previewAsync.maybeWhen(
        data: (data) {
          final peaks = data.trackPeaks?.peaks;
          if (peaks == null) {
            return const <double>[];
          }
          return _normalizePeaks(peaks);
        },
        orElse: () => const <double>[],
      );
    });

final trackPreviewPlaybackUiStateProvider =
    Provider.autoDispose<TrackPreviewPlaybackUiState>((ref) {
      final audioState = ref.watch(trackAudioProvider);

      final displayedPosition = audioState.isDragging
          ? (audioState.dragPosition ?? audioState.position)
          : audioState.position;

      final shouldBlurBackground =
          !audioState.isPlaying || audioState.isDragging;
      final showPlayIcon = !audioState.isPlaying && !audioState.isDragging;

      return (
        displayedPosition: displayedPosition,
        shouldBlurBackground: shouldBlurBackground,
        showPlayIcon: showPlayIcon,
      );
    });

List<double> _normalizePeaks(List<num> sourcePeaks) {
  final rawPeaks = sourcePeaks.map((peak) => peak.toDouble()).toList();

  if (rawPeaks.isEmpty) {
    return const <double>[];
  }

  final maxPeak = rawPeaks.reduce((a, b) => a > b ? a : b);

  if (maxPeak == 0) {
    return rawPeaks.map((_) => 0.0).toList();
  }

  // Linear scaling
  return rawPeaks.map((peak) {
    return peak / maxPeak;
  }).toList();
}
