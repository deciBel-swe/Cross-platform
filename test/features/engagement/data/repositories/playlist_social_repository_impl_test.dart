import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/data/datasources/playlist_social_remote_datasource.dart';
import 'package:decibel/features/engagement/data/repositories/playlist_social_repository_impl.dart';
import 'package:decibel/features/playlists/data/models/owner_model.dart';
import 'package:decibel/features/playlists/data/models/playlist_model.dart';
import 'package:decibel/features/playlists/domain/entities/playlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlaylistSocialRemoteDatasource extends Mock implements PlaylistSocialRemoteDatasource {}

void main() {
  late PlaylistSocialRepositoryImpl repository;
  late MockPlaylistSocialRemoteDatasource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPlaylistSocialRemoteDatasource();
    repository = PlaylistSocialRepositoryImpl(mockRemoteDataSource);
  });

  const tPlaylistId = 1;
  const tUsername = 'testuser';
  final tPlaylistModel = PlaylistModel(
    id: 1,
    title: 'Test Playlist',
    description: 'Test Description',
    owner: const OwnerModel(id: 1, username: 'owner'),
    type: 'PLAYLIST',
    isPrivate: false,
    tracks: [],
    createdAt: DateTime(2026, 1, 1),
  );

  group('toggleLike', () {
    test('should return true when the call to remote data source is successful and isLiked is true', () async {
      // arrange
      when(() => mockRemoteDataSource.toggleLike(any(), isCurrentlyLiked: any(named: 'isCurrentlyLiked')))
          .thenAnswer((_) async => true);
      // act
      final result = await repository.toggleLike(tPlaylistId, false);
      // assert
      expect(result, const Right<Failure, bool>(true));
      verify(() => mockRemoteDataSource.toggleLike(tPlaylistId, isCurrentlyLiked: false));
    });

    test('should return ServerFailure when toggleLike throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.toggleLike(any(), isCurrentlyLiked: any(named: 'isCurrentlyLiked')))
          .thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.toggleLike(tPlaylistId, false);
      // assert
      expect(result, equals(const Left<Failure, bool>(ServerFailure('Server error'))));
    });

    test('should return AuthFailure when toggleLike throws AuthException', () async {
      // arrange
      when(() => mockRemoteDataSource.toggleLike(any(), isCurrentlyLiked: any(named: 'isCurrentlyLiked')))
          .thenThrow(const AuthException('Unauthorized'));
      // act
      final result = await repository.toggleLike(tPlaylistId, false);
      // assert
      expect(result, equals(const Left<Failure, bool>(AuthFailure('Unauthorized'))));
    });

    test('should return NetworkFailure when toggleLike throws NetworkException', () async {
      // arrange
      when(() => mockRemoteDataSource.toggleLike(any(), isCurrentlyLiked: any(named: 'isCurrentlyLiked')))
          .thenThrow(const NetworkException('No internet'));
      // act
      final result = await repository.toggleLike(tPlaylistId, false);
      // assert
      expect(result, equals(const Left<Failure, bool>(NetworkFailure('No internet'))));
    });
  });

  group('getLikedPlaylists', () {
    test('should return List<Playlist> when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getLikedPlaylists(any(), page: any(named: 'page'), size: any(named: 'size')))
          .thenAnswer((_) async => [tPlaylistModel]);
      // act
      final result = await repository.getLikedPlaylists(tUsername);
      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be Right'),
        (playlists) {
          expect(playlists, hasLength(1));
          expect(playlists.first.id, tPlaylistModel.id);
        },
      );
    });

    test('should return ServerFailure when getLikedPlaylists throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.getLikedPlaylists(any(), page: any(named: 'page'), size: any(named: 'size')))
          .thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.getLikedPlaylists(tUsername);
      // assert
      expect(result, equals(const Left<Failure, List<Playlist>>(ServerFailure('Server error'))));
    });

    test('should return AuthFailure when getLikedPlaylists throws AuthException', () async {
      // arrange
      when(() => mockRemoteDataSource.getLikedPlaylists(any(), page: any(named: 'page'), size: any(named: 'size')))
          .thenThrow(const AuthException('Unauthorized'));
      // act
      final result = await repository.getLikedPlaylists(tUsername);
      // assert
      expect(result, equals(const Left<Failure, List<Playlist>>(AuthFailure('Unauthorized'))));
    });

    test('should return NetworkFailure when getLikedPlaylists throws NetworkException', () async {
      // arrange
      when(() => mockRemoteDataSource.getLikedPlaylists(any(), page: any(named: 'page'), size: any(named: 'size')))
          .thenThrow(const NetworkException('No internet'));
      // act
      final result = await repository.getLikedPlaylists(tUsername);
      // assert
      expect(result, equals(const Left<Failure, List<Playlist>>(NetworkFailure('No internet'))));
    });

    test('should return ServerFailure when getLikedPlaylists throws an unknown exception', () async {
      // arrange
      when(() => mockRemoteDataSource.getLikedPlaylists(any(), page: any(named: 'page'), size: any(named: 'size')))
          .thenThrow(Exception('Unknown'));
      // act
      final result = await repository.getLikedPlaylists(tUsername);
      // assert
      expect(result, equals(const Left<Failure, List<Playlist>>(ServerFailure('Exception: Unknown'))));
    });
  });
}
