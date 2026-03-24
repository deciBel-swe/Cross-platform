import 'dart:io';

import 'package:decibel/features/library/data/datasources/library_mock_fixtures.dart';
import 'package:decibel/features/upload/data/repository/mock_upload_repository_impl.dart';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = MockUploadRepository();

  test(
    'maps local waveform data into deterministic peaks in mock upload',
    () async {
      final metadata = TrackUploadMetadata(
        audioFile: File('C:/tmp/mock_song.mp3'),
        title: 'Mock song',
        genre: 'Lo-fi',
        waveFormData: <double>[0.0, 0.1, 0.5, 1.0, double.nan, -0.3],
      );

      final result = await repository.uploadTrack(metadata);

      result.fold(
        (failure) =>
            fail('Expected upload success but got failure: ${failure.message}'),
        (track) {
          final storedPeaks = LibraryMockFixtures.trackPeaksById[track.id];

          expect(storedPeaks, isNotNull);
          expect(storedPeaks!['trackId'], track.id);
          expect(storedPeaks['peaks'], <int>[0, 5, 25, 50, 0, 15]);
        },
      );
    },
  );
}
