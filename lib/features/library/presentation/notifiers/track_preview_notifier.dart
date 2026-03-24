import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library_profile/presentation/providers/track_preview_provider.dart';
import '../../../library_profile/presentation/providers/track_repository_provider.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../../domain/entities/track_status.dart';

// This notifier fetches both the track details and its peaks (if available) for a given track ID.
class TrackPreviewNotifier
    extends AutoDisposeFamilyAsyncNotifier<TrackPreviewData, int> {
  @override
  Future<TrackPreviewData> build(int trackId) async {
    final repository = ref.read(trackRepositoryProvider);

    final trackResult = await repository.fetchTrackById(trackId);

    final track = trackResult.fold<Track>(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    if (track.state != TrackStatus.finished) {
      return (track: track, trackPeaks: null);
    }

    final peaksResult = await repository.fetchTrackPeaksById(track.id);

    final trackPeaks = peaksResult.fold<TrackPeaks?>(
      (failure) => null,
      (value) => value,
    );

    return (track: track, trackPeaks: trackPeaks);
  }
}
