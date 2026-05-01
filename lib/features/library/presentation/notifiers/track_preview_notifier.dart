import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/domain/repositories/track_repository.dart';
import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/providers/track_repository_provider.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';

/// Loads the track preview details and waveform peaks.
class TrackPreviewNotifier
    extends AutoDisposeFamilyAsyncNotifier<TrackPreviewData, int> {
  /// Builds the preview data for [trackId].
  @override
  Future<TrackPreviewData> build(int trackId) async {
    final repository = ref.read(trackRepositoryProvider);

    final trackResult = await repository.fetchTrackById(trackId);

    final track = trackResult.fold<Track>(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    unawaited(_loadTrackPeaks(repository, track));

    return (track: track, trackPeaks: null);
  }

  Future<void> _loadTrackPeaks(TrackRepository repository, Track track) async {
    final peaksResult = await repository.fetchTrackPeaksById(
      track.id,
      waveformUrl: track.waveformUrl,
    );

    final trackPeaks = peaksResult.fold<TrackPeaks?>(
      (failure) => null,
      (value) => value,
    );

    if (trackPeaks == null) {
      return;
    }

    state = AsyncData((track: track, trackPeaks: trackPeaks));
  }
}
