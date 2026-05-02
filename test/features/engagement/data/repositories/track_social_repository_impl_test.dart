import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/data/datasources/track_social_remote_datasource.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/engagement/data/models/paginated_engagers_model.dart';
import 'package:decibel/features/engagement/data/models/repost_history_model.dart';
import 'package:decibel/features/engagement/data/models/track_engager_model.dart';
import 'package:decibel/features/engagement/data/repositories/track_social_repository_impl.dart';
import 'package:decibel/features/library/data/models/artist_model.dart';
import 'package:decibel/features/library/data/models/paginated_tracks_model.dart';
import 'package:decibel/features/library/data/models/track_model.dart';
import 'package:decibel/features/library/data/models/track_status_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackSocialRemoteDatasource extends Mock
    implements TrackSocialRemoteDatasource {}

void main() {
  late MockTrackSocialRemoteDatasource mockDatasource;
  late TrackSocialRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockTrackSocialRemoteDatasource();
    repository = TrackSocialRepositoryImpl(mockDatasource);
  });

  TrackModel buildTrackModel(int id) {
    return TrackModel(
      id: id,
      title: 'Track $id',
      artist: const ArtistModel(id: 1, username: 'artist'),
      genre: 'House',
      tags: const [],
      state: TrackStatusModel.finished,
      releaseDate: DateTime(2026, 1, 1),
      createdAt: DateTime(2026, 1, 1),
    );
  }

  test('getLikedTracks maps datasource model to domain entity', () async {
    when(() => mockDatasource.getLikedTracks(page: 0, size: 20)).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [buildTrackModel(1)],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );

    final result = await repository.getLikedTracks(page: 0, size: 20);

    expect(result.content, hasLength(1));
    expect(result.content.first.id, 1);
    verify(() => mockDatasource.getLikedTracks(page: 0, size: 20)).called(1);
  });

  test('getRepostedTracks maps datasource model to domain entity', () async {
    when(() => mockDatasource.getRepostedTracks(page: 1, size: 10)).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [buildTrackModel(3)],
        pageNumber: 1,
        pageSize: 10,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );

    final result = await repository.getRepostedTracks(page: 1, size: 10);

    expect(result.content.single.id, 3);
    verify(() => mockDatasource.getRepostedTracks(page: 1, size: 10)).called(1);
  });

  test('fetchTrackLikers returns Right on success', () async {
    when(
      () => mockDatasource.fetchTrackLikers(trackId: 8, page: 0, size: 20),
    ).thenAnswer(
      (_) async => const PaginatedEngagersModel(
        content: [
          TrackEngagerModel(
            id: 10,
            username: 'liker',
            tier: 'FREE',
            isFollowing: false,
          ),
        ],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
      ),
    );

    final result = await repository.fetchTrackLikers(
      trackId: 8,
      page: 0,
      size: 20,
    );

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('Expected Right but got Left'),
      (value) => expect(value.content.single.username, 'liker'),
    );
  });

  test('getLikedTracks calls datasource with userId when provided', () async {
    when(() => mockDatasource.getLikedTracks(page: 0, size: 20, userId: 123)).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );

    await repository.getLikedTracks(page: 0, size: 20, userId: 123);

    verify(() => mockDatasource.getLikedTracks(page: 0, size: 20, userId: 123)).called(1);
  });

  test('getLikedTracks calls datasource with username when provided', () async {
    when(() => mockDatasource.getLikedTracks(page: 0, size: 20, username: 'user1')).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );

    await repository.getLikedTracks(page: 0, size: 20, username: 'user1');

    verify(() => mockDatasource.getLikedTracks(page: 0, size: 20, username: 'user1')).called(1);
  });

  test('getRepostedTracks calls datasource with userId when provided', () async {
    when(() => mockDatasource.getRepostedTracks(page: 0, size: 20, userId: 123)).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );

    await repository.getRepostedTracks(page: 0, size: 20, userId: 123);

    verify(() => mockDatasource.getRepostedTracks(page: 0, size: 20, userId: 123)).called(1);
  });

  test('getRepostedTracks calls datasource with username when provided', () async {
    when(() => mockDatasource.getRepostedTracks(page: 0, size: 20, username: 'user1')).thenAnswer(
      (_) async => PaginatedTracksModel(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );

    await repository.getRepostedTracks(page: 0, size: 20, username: 'user1');

    verify(() => mockDatasource.getRepostedTracks(page: 0, size: 20, username: 'user1')).called(1);
  });

  test('getRepostHistory calls datasource correctly', () async {
    when(() => mockDatasource.getRepostHistory(any(), page: any(named: 'page'), size: any(named: 'size'))).thenAnswer(
      (_) async => const PaginatedRepostHistoryModel(
        content: [],
        pageNumber: 0,
        pageSize: 20,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
      ),
    );

    await repository.getRepostHistory('user1', page: 0, size: 20);

    verify(() => mockDatasource.getRepostHistory('user1', page: 0, size: 20)).called(1);
  });

  test('getLikedTracks throws ServerException when datasource fails', () async {
    when(() => mockDatasource.getLikedTracks(page: 0, size: 20)).thenThrow(const ServerException('error'));
    expect(() => repository.getLikedTracks(page: 0, size: 20), throwsA(isA<ServerException>()));
  });

  test('likeTrack calls datasource', () async {
    when(() => mockDatasource.likeTrack(any())).thenAnswer((_) async {});
    await repository.likeTrack(1);
    verify(() => mockDatasource.likeTrack(1)).called(1);
  });

  test('unlikeTrack calls datasource', () async {
    when(() => mockDatasource.unlikeTrack(any())).thenAnswer((_) async {});
    await repository.unlikeTrack(1);
    verify(() => mockDatasource.unlikeTrack(1)).called(1);
  });

  test('repostTrack calls datasource', () async {
    when(() => mockDatasource.repostTrack(any())).thenAnswer((_) async {});
    await repository.repostTrack(1);
    verify(() => mockDatasource.repostTrack(1)).called(1);
  });

  test('unrepostTrack calls datasource', () async {
    when(() => mockDatasource.unrepostTrack(any())).thenAnswer((_) async {});
    await repository.unrepostTrack(1);
    verify(() => mockDatasource.unrepostTrack(1)).called(1);
  });

  test('reportTrack calls datasource', () async {
    when(() => mockDatasource.reportTrack(
          trackId: any(named: 'trackId'),
          reason: any(named: 'reason'),
          description: any(named: 'description'),
        )).thenAnswer((_) async {});
    await repository.reportTrack(trackId: 1, reason: 'spam', description: 'desc');
    verify(() => mockDatasource.reportTrack(trackId: 1, reason: 'spam', description: 'desc')).called(1);
  });

  group('fetchTrackLikers', () {
    test('returns NetworkFailure on NetworkException', () async {
      when(
        () => mockDatasource.fetchTrackLikers(trackId: 8, page: 0, size: 20),
      ).thenThrow(const NetworkException('No internet'));
      final result = await repository.fetchTrackLikers(trackId: 8, page: 0, size: 20);
      expect(result, equals(const Left<Failure, PaginatedEngagers>(NetworkFailure('No internet'))));
    });

    test('returns ServerFailure on AuthException (generic catch)', () async {
      when(
        () => mockDatasource.fetchTrackLikers(trackId: 8, page: 0, size: 20),
      ).thenThrow(const AuthException('Unauthorized'));
      final result = await repository.fetchTrackLikers(trackId: 8, page: 0, size: 20);
      expect(result, equals(const Left<Failure, PaginatedEngagers>(ServerFailure('Unauthorized'))));
    });
  });

  group('fetchTrackReposters', () {
    test('returns NetworkFailure on NetworkException', () async {
      when(
        () => mockDatasource.fetchTrackReposters(trackId: 8, page: 0, size: 20),
      ).thenThrow(const NetworkException('No internet'));
      final result = await repository.fetchTrackReposters(trackId: 8, page: 0, size: 20);
      expect(result, equals(const Left<Failure, PaginatedEngagers>(NetworkFailure('No internet'))));
    });
  });
}
