import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../../domain/entities/track_status.dart';
import '../providers/track_preview_provider.dart';
import '../providers/track_repository_provider.dart';

class TrackPreviewNotifier extends AsyncNotifier<TrackPreviewData> {
  @override
  Future<TrackPreviewData> build() async {
    final selectedTrackId = ref.watch(selectedTrackIdProvider);

    if (selectedTrackId == null) {
      throw Exception('No track selected');
    }

    final repository = ref.read(trackRepositoryProvider);

    final trackResult = await repository.fetchTrackById(selectedTrackId);

    final track = trackResult.fold<Track>(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );

    if (track.state != TrackStatus.finished || track.waveformUrl == null) {
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
