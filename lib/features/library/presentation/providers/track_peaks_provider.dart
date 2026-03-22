import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track_peaks.dart';
import 'track_repository_provider.dart';

final trackWaveformDataProvider = FutureProvider.family<List<double>, int>((
  ref,
  trackId,
) async {
  final repository = ref.read(trackRepositoryProvider);
  final result = await repository.fetchTrackPeaksById(trackId);
  return result.fold(
    (failure) => const <double>[],
    (value) => value.waveformData,
  );
});
