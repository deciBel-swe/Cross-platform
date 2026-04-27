import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/domain/entities/track_peaks.dart';
import 'track_repository_provider.dart';

final trackWaveformDataProvider = FutureProvider.family<List<double>, int>((
  ref,
  trackId,
) async {
  final repository = ref.read(trackRepositoryProvider);
  final result = await repository.fetchTrackPeaksById(trackId);
  return result.fold(
    (failure) => const <double>[],
    (value) => normalizeWaveformPeaks(value.waveformData),
  );
});

List<double> normalizeWaveformPeaks(Iterable<num> peaks) {
  final values = peaks
      .map((peak) => peak.toDouble())
      .where((peak) => peak.isFinite && peak >= 0)
      .toList(growable: false);
  if (values.isEmpty) {
    return const <double>[];
  }

  final maxPeak = values.reduce((a, b) => a > b ? a : b);
  if (maxPeak <= 0) {
    return const <double>[];
  }
  if (maxPeak <= 1) {
    return values
        .map((peak) => peak.clamp(0.0, 1.0).toDouble())
        .toList(growable: false);
  }

  return values
      .map((peak) => (peak / maxPeak).clamp(0.0, 1.0).toDouble())
      .toList(growable: false);
}
