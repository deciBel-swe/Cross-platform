import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/data/datasources/track_social_remote_datasource.dart';
import 'package:decibel/features/engagement/data/models/paginated_engagers_model.dart';
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

  test('fetchTrackReposters returns Left on exception', () async {
    when(
      () => mockDatasource.fetchTrackReposters(trackId: 9, page: 0, size: 20),
    ).thenThrow(Exception('boom'));

    final result = await repository.fetchTrackReposters(
      trackId: 9,
      page: 0,
      size: 20,
    );

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Expected Left but got Right'),
    );
  });
}
