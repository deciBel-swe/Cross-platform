import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/data/datasources/offline_local_data_source.dart';
import 'package:decibel/features/offline/data/repositories/offline_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOfflineLocalDataSource extends Mock
    implements OfflineLocalDataSource {}

class FakeTrack extends Fake implements Track {}

class FakeOfflineCollectionInfo extends Fake implements OfflineCollectionInfo {}

Track _makeTrack({int id = 1, String? trackUrl = 'https://example.com/t.mp3'}) {
  return Track(
    id: id,
    title: 'Track $id',
    artist: const Artist(id: 10, username: 'artist'),
    trackUrl: trackUrl,
    genre: 'Electronic',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2024),
    playCount: 0,
    likeCount: 0,
    repostCount: 0,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2024),
    trackDurationSeconds: 200,
  );
}

const _tCollection = OfflineCollectionInfo(
  id: 5,
  title: 'Summer Vibes',
  coverUrl: null,
  trackIds: [1, 2],
);

void main() {
  late MockOfflineLocalDataSource mockDataSource;
  late OfflineRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeTrack());
    registerFallbackValue(FakeOfflineCollectionInfo());
  });

  setUp(() {
    mockDataSource = MockOfflineLocalDataSource();
    repository = OfflineRepositoryImpl(mockDataSource);
  });

  // ── downloadTrack ──────────────────────────────────────────────────────────

  group('downloadTrack', () {
    final tTrack = _makeTrack();
    const tPath = '/docs/tracks/track_1.dat';

    test('returns Right(path) when datasource succeeds', () async {
      when(() => mockDataSource.downloadAndSave(tTrack))
          .thenAnswer((_) async => tPath);

      final result = await repository.downloadTrack(tTrack);

      expect(result, const Right<Failure, String>(tPath));
      verify(() => mockDataSource.downloadAndSave(tTrack)).called(1);
    });

    test('returns Left(NetworkFailure) on DioException connection error', () async {
      when(() => mockDataSource.downloadAndSave(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.downloadTrack(tTrack);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on DioException connectionTimeout', () async {
      when(() => mockDataSource.downloadAndSave(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.downloadTrack(tTrack);
      expect(result.isLeft(), true);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });

    test('returns Left(NetworkFailure) on DioException receiveTimeout', () async {
      when(() => mockDataSource.downloadAndSave(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      final result = await repository.downloadTrack(tTrack);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });

    test('returns Left(NetworkFailure) on unknown DioException with SocketException', () async {
      when(() => mockDataSource.downloadAndSave(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.unknown,
          error: const SocketException('No internet'),
        ),
      );

      final result = await repository.downloadTrack(tTrack);
      expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });

    test('returns Left(ServerFailure) on generic exception', () async {
      when(() => mockDataSource.downloadAndSave(any()))
          .thenThrow(Exception('disk full'));

      final result = await repository.downloadTrack(tTrack);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('ServerFailure message contains exception text', () async {
      when(() => mockDataSource.downloadAndSave(any()))
          .thenThrow(Exception('quota exceeded'));

      final result = await repository.downloadTrack(tTrack);
      result.fold(
        (f) => expect(f.message, contains('quota exceeded')),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── downloadTracks ─────────────────────────────────────────────────────────

  group('downloadTracks', () {
    test('returns Right(null) immediately for empty list', () async {
      final result = await repository.downloadTracks([]);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true), // reached Right branch
      );
      verifyNever(() => mockDataSource.downloadAndSave(any()));
    });

    test('calls downloadAndSave for each track and reports progress', () async {
      final tracks = [_makeTrack(id: 1), _makeTrack(id: 2)];
      when(() => mockDataSource.downloadAndSave(any()))
          .thenAnswer((_) async => '/path/to/track.dat');

      final progressValues = <double>[];
      final result = await repository.downloadTracks(
        tracks,
        onProgress: progressValues.add,
      );

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
      // Two tracks -> progress 0.5, 1.0
      expect(progressValues, contains(0.5));
      expect(progressValues, contains(1.0));
      verify(() => mockDataSource.downloadAndSave(any())).called(2);
    });

    test('reports correct progress for single-track list', () async {
      final tracks = [_makeTrack(id: 1)];
      when(() => mockDataSource.downloadAndSave(any()))
          .thenAnswer((_) async => '/path/1.dat');

      final progressValues = <double>[];
      await repository.downloadTracks(tracks, onProgress: progressValues.add);
      expect(progressValues.last, 1.0);
    });

    test('skips individual track failures and continues (non-fatal)', () async {
      final tracks = [_makeTrack(id: 1), _makeTrack(id: 2)];
      when(() => mockDataSource.downloadAndSave(tracks[0]))
          .thenThrow(Exception('io error'));
      when(() => mockDataSource.downloadAndSave(tracks[1]))
          .thenAnswer((_) async => '/path/track_2.dat');

      final result = await repository.downloadTracks(tracks);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
    });

    test('returns Left(NetworkFailure) when DioException connection error occurs', () async {
      final tracks = [_makeTrack(id: 1)];
      when(() => mockDataSource.downloadAndSave(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.downloadTracks(tracks);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── getDownloadedTracks ────────────────────────────────────────────────────

  group('getDownloadedTracks', () {
    test('returns Right(tracks) when datasource succeeds', () async {
      final tTracks = [_makeTrack(id: 1), _makeTrack(id: 2)];
      when(() => mockDataSource.getOfflineTracks())
          .thenAnswer((_) async => tTracks);

      final result = await repository.getDownloadedTracks();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).length, 2);
    });

    test('preserves track list order from datasource', () async {
      final tTracks = [_makeTrack(id: 5), _makeTrack(id: 3)];
      when(() => mockDataSource.getOfflineTracks())
          .thenAnswer((_) async => tTracks);

      final result = await repository.getDownloadedTracks();
      final tracks = result.getOrElse(() => []);
      expect(tracks[0].id, 5);
      expect(tracks[1].id, 3);
    });

    test('returns Right([]) for empty datasource', () async {
      when(() => mockDataSource.getOfflineTracks())
          .thenAnswer((_) async => []);

      final result = await repository.getDownloadedTracks();
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.getOfflineTracks()).thenThrow(Exception('read error'));

      final result = await repository.getDownloadedTracks();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── saveCollectionMetadata ─────────────────────────────────────────────────

  group('saveCollectionMetadata', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.saveCollectionMetadata(any()))
          .thenAnswer((_) async {});

      final result = await repository.saveCollectionMetadata(_tCollection);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
      verify(() => mockDataSource.saveCollectionMetadata(any())).called(1);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.saveCollectionMetadata(any()))
          .thenThrow(Exception('write error'));

      final result = await repository.saveCollectionMetadata(_tCollection);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── getOfflineCollections ──────────────────────────────────────────────────

  group('getOfflineCollections', () {
    test('returns Right(collections) on success', () async {
      when(() => mockDataSource.getOfflineCollections())
          .thenAnswer((_) async => [_tCollection]);

      final result = await repository.getOfflineCollections();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).single.id, 5);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.getOfflineCollections())
          .thenThrow(Exception('read error'));

      final result = await repository.getOfflineCollections();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── deleteCollectionMetadata ───────────────────────────────────────────────

  group('deleteCollectionMetadata', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.deleteCollectionMetadata(5))
          .thenAnswer((_) async {});

      final result = await repository.deleteCollectionMetadata(5);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
      verify(() => mockDataSource.deleteCollectionMetadata(5)).called(1);
    });

    test('passes correct id to datasource', () async {
      when(() => mockDataSource.deleteCollectionMetadata(any()))
          .thenAnswer((_) async {});
      await repository.deleteCollectionMetadata(42);
      verify(() => mockDataSource.deleteCollectionMetadata(42)).called(1);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.deleteCollectionMetadata(5))
          .thenThrow(Exception('delete error'));

      final result = await repository.deleteCollectionMetadata(5);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── updateCollectionMetadata ───────────────────────────────────────────────

  group('updateCollectionMetadata', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.updateCollectionMetadata(any()))
          .thenAnswer((_) async {});

      final result = await repository.updateCollectionMetadata(_tCollection);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
      verify(() => mockDataSource.updateCollectionMetadata(any())).called(1);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.updateCollectionMetadata(any()))
          .thenThrow(Exception('write error'));

      final result = await repository.updateCollectionMetadata(_tCollection);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── removeTrackFromCollection ──────────────────────────────────────────────

  group('removeTrackFromCollection', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.removeTrackFromCollection(5, 99))
          .thenAnswer((_) async {});

      final result = await repository.removeTrackFromCollection(5, 99);

      result.fold(
        (_) => fail('Expected Right'),
        (_) => expect(true, true),
      );
      verify(() => mockDataSource.removeTrackFromCollection(5, 99)).called(1);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(() => mockDataSource.removeTrackFromCollection(5, 99))
          .thenThrow(Exception('mutation error'));

      final result = await repository.removeTrackFromCollection(5, 99);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
