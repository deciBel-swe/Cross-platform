import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/track_peaks.dart';
import 'package:decibel/features/library_profile/domain/repositories/track_repository.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_peaks_provider.dart';
import 'package:decibel/features/library_profile/presentation/providers/track_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackRepository extends Mock implements TrackRepository {}

void main() {
  late MockTrackRepository mockRepo;

  setUp(() {
    mockRepo = MockTrackRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [trackRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  group('trackWaveformDataProvider', () {
    const tTrackId = 123;
    const tPeaksInt = [100, 200, 150];
    final tPeaksDouble = tPeaksInt.map((e) => e.toDouble()).toList();

    const tTrackPeaks = TrackPeaks(
      trackId: tTrackId,
      duration: 5000,
      peaks: tPeaksInt,
    );

    test('returns waveform data when repository call is successful', () async {
      // Arrange
      when(
        () => mockRepo.fetchTrackPeaksById(tTrackId),
      ).thenAnswer((_) async => const Right(tTrackPeaks));

      final container = createContainer();

      // Act
      final result = await container.read(
        trackWaveformDataProvider(tTrackId).future,
      );

      // Assert
      expect(result, equals(tPeaksDouble));
      verify(() => mockRepo.fetchTrackPeaksById(tTrackId)).called(1);
    });

    test('returns empty list when repository call fails', () async {
      // Arrange
      when(
        () => mockRepo.fetchTrackPeaksById(tTrackId),
      ).thenAnswer((_) async => const Left(ServerFailure('Error')));

      final container = createContainer();

      // Act
      final result = await container.read(
        trackWaveformDataProvider(tTrackId).future,
      );

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepo.fetchTrackPeaksById(tTrackId)).called(1);
    });
  });
}
