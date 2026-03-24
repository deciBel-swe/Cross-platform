import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/data/datasources/library_mock_datasource.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/data/models/track_peaks_model.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_peaks.dart';

final libraryMockDatasourceProvider = Provider<LibraryMockDatasource>((ref) {
  return const LibraryMockDatasource();
});

final firstTrackPreviewProvider =
    FutureProvider<({Track track, TrackPeaks trackPeaks})>((ref) async {
      final datasource = ref.watch(libraryMockDatasourceProvider);

      final trackModel = await datasource.fetchTrackById(1);
      final trackPeaksModel = await datasource.fetchTrackPeaks(1);

      return (
        track: trackModel.toEntity(),
        trackPeaks: trackPeaksModel.toEntity(),
      );
    });
