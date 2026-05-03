import 'package:dartz/dartz.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/errors/failures.dart';
import 'package:decibel/features/engagement/data/datasources/follow_remote_data_source.dart';
import 'package:decibel/features/engagement/data/models/follow_response_model.dart';
import 'package:decibel/features/engagement/data/models/paginated_engagers_model.dart';
import 'package:decibel/features/engagement/data/models/track_engager_model.dart';
import 'package:decibel/features/engagement/data/repositories/follow_repository_impl.dart';
import 'package:decibel/features/engagement/domain/entities/paginated_engagers.dart';
import 'package:decibel/features/library_profile/data/models/public_profile_model.dart';
import 'package:decibel/features/library_profile/data/models/user_profile_model.dart';
import 'package:decibel/features/library_profile/domain/entities/public_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFollowRemoteDataSource extends Mock implements IFollowRemoteDataSource {}

void main() {
  late FollowRepositoryImpl repository;
  late MockFollowRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockFollowRemoteDataSource();
    repository = FollowRepositoryImpl(mockRemoteDataSource);
  });

  const tUserId = 1;
  const tUserIdentifier = 'testuser';
  const tFollowResponseModel = FollowResponseModel(
    message: 'Followed successfully',
    isFollowing: true,
  );
  const tUnfollowResponseModel = FollowResponseModel(
    message: 'Unfollowed successfully',
    isFollowing: false,
  );

  const tPublicProfileModel = PublicProfileModel(
    id: 1,
    username: 'testuser',
    displayName: 'Test User',
    tier: 'FREE',
    profile: PublicProfileDetailsModel(
      bio: 'Test bio',
      location: 'Test location',
      avatarUrl: 'https://example.com/avatar.jpg',
      coverPhotoUrl: 'https://example.com/cover.jpg',
      favoriteGenres: [],
    ),
    stats: PublicStatsModel(
      followersCount: 10,
      followingCount: 5,
      trackCount: 3,
    ),
    isFollowing: false,
    isFollowedBy: false,
    isBlocked: false,
    socialLinks: SocialLinksModel(),
  );

  const tPaginatedEngagersModel = PaginatedEngagersModel(
    content: [
      TrackEngagerModel(
        id: 1,
        username: 'engager',
        tier: 'FREE',
        isFollowing: false,
      ),
    ],
    pageNumber: 0,
    pageSize: 20,
    totalElements: 1,
    totalPages: 1,
    isLast: true,
  );

  group('getPublicProfile', () {
    test('should return PublicProfile when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenAnswer((_) async => tPublicProfileModel);
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be Right'),
        (profile) => expect(profile.id, tPublicProfileModel.id),
      );
      verify(() => mockRemoteDataSource.getPublicProfile(tUserIdentifier));
    });

    test('should return NotFoundFailure when the call to remote data source throws NotFoundException', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenThrow(const NotFoundException('User not found.'));
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result, equals(const Left<Failure, PublicProfile>(NotFoundFailure('User not found.'))));
    });

    test('should return AuthFailure when the call to remote data source throws AuthException', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenThrow(const AuthException('Unauthorized'));
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result, equals(const Left<Failure, PublicProfile>(AuthFailure('Unauthorized'))));
    });

    test('should return NetworkFailure when the call to remote data source throws NetworkException', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenThrow(const NetworkException('No internet'));
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result, equals(const Left<Failure, PublicProfile>(NetworkFailure('No internet'))));
    });

    test('should return ServerFailure when the call to remote data source throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result, equals(const Left<Failure, PublicProfile>(ServerFailure('Server error'))));
    });

    test('should return ServerFailure when the call to remote data source throws an unknown exception', () async {
      // arrange
      when(() => mockRemoteDataSource.getPublicProfile(any()))
          .thenThrow(Exception('Unknown'));
      // act
      final result = await repository.getPublicProfile(tUserIdentifier);
      // assert
      expect(result, equals(const Left<Failure, PublicProfile>(ServerFailure('Exception: Unknown'))));
    });
  });

  group('followUser', () {
    test('should return true when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.followUser(any()))
          .thenAnswer((_) async => tFollowResponseModel);
      // act
      final result = await repository.followUser(tUserId);
      // assert
      expect(result, const Right<Failure, bool>(true));
      verify(() => mockRemoteDataSource.followUser(tUserId));
    });

    test('should return AuthFailure when followUser throws AuthException', () async {
      // arrange
      when(() => mockRemoteDataSource.followUser(any()))
          .thenThrow(const AuthException('Unauthorized'));
      // act
      final result = await repository.followUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(AuthFailure('Unauthorized'))));
    });

    test('should return NetworkFailure when followUser throws NetworkException', () async {
      // arrange
      when(() => mockRemoteDataSource.followUser(any()))
          .thenThrow(const NetworkException('No internet'));
      // act
      final result = await repository.followUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(NetworkFailure('No internet'))));
    });

    test('should return ServerFailure when followUser throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.followUser(any()))
          .thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.followUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(ServerFailure('Server error'))));
    });

    test('should return ServerFailure when followUser throws an unknown exception', () async {
      // arrange
      when(() => mockRemoteDataSource.followUser(any()))
          .thenThrow(Exception('Unknown'));
      // act
      final result = await repository.followUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(ServerFailure('Exception: Unknown'))));
    });
  });

  group('unfollowUser', () {
    test('should return false when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.unfollowUser(any()))
          .thenAnswer((_) async => tUnfollowResponseModel);
      // act
      final result = await repository.unfollowUser(tUserId);
      // assert
      expect(result, const Right<Failure, bool>(false));
      verify(() => mockRemoteDataSource.unfollowUser(tUserId));
    });

    test('should return AuthFailure when unfollowUser throws AuthException', () async {
      // arrange
      when(() => mockRemoteDataSource.unfollowUser(any()))
          .thenThrow(const AuthException('Unauthorized'));
      // act
      final result = await repository.unfollowUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(AuthFailure('Unauthorized'))));
    });

    test('should return NetworkFailure when unfollowUser throws NetworkException', () async {
      // arrange
      when(() => mockRemoteDataSource.unfollowUser(any()))
          .thenThrow(const NetworkException('No internet'));
      // act
      final result = await repository.unfollowUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(NetworkFailure('No internet'))));
    });

    test('should return ServerFailure when unfollowUser throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.unfollowUser(any()))
          .thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.unfollowUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(ServerFailure('Server error'))));
    });

    test('should return ServerFailure when unfollowUser throws an unknown exception', () async {
      // arrange
      when(() => mockRemoteDataSource.unfollowUser(any()))
          .thenThrow(Exception('Unknown'));
      // act
      final result = await repository.unfollowUser(tUserId);
      // assert
      expect(result, equals(const Left<Failure, bool>(ServerFailure('Exception: Unknown'))));
    });
  });

  group('getFollowers', () {
    test('should return PaginatedEngagers when successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getFollowers(
        userId: any(named: 'userId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenAnswer((_) async => tPaginatedEngagersModel);
      // act
      final result = await repository.getFollowers(userId: tUserId);
      // assert
      expect(result.isRight(), isTrue);
    });

    test('should return NotFoundFailure when getFollowers throws NotFoundException', () async {
      // arrange
      when(() => mockRemoteDataSource.getFollowers(
        userId: any(named: 'userId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenThrow(const NotFoundException('Not found'));
      // act
      final result = await repository.getFollowers(userId: tUserId);
      // assert
      expect(result, equals(const Left<Failure, PaginatedEngagers>(NotFoundFailure('Not found'))));
    });

    test('should return ServerFailure when getFollowers throws ServerException', () async {
      // arrange
      when(() => mockRemoteDataSource.getFollowers(
        userId: any(named: 'userId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenThrow(const ServerException('Server error'));
      // act
      final result = await repository.getFollowers(userId: tUserId);
      // assert
      expect(result, equals(const Left<Failure, PaginatedEngagers>(ServerFailure('Server error'))));
    });
  });

  group('getFollowing', () {
    test('should return PaginatedEngagers when successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getFollowing(
        userId: any(named: 'userId'),
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenAnswer((_) async => tPaginatedEngagersModel);
      // act
      final result = await repository.getFollowing(userId: tUserId);
      // assert
      expect(result.isRight(), isTrue);
    });
  });

  group('getSuggestedUsers', () {
    test('should return PaginatedEngagers when successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getSuggestedUsers(
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenAnswer((_) async => tPaginatedEngagersModel);
      // act
      final result = await repository.getSuggestedUsers();
      // assert
      expect(result.isRight(), isTrue);
    });
  });

  group('getFriends', () {
    test('should return PaginatedEngagers when successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getFriends(
        page: any(named: 'page'),
        size: any(named: 'size'),
      )).thenAnswer((_) async => tPaginatedEngagersModel);
      // act
      final result = await repository.getFriends();
      // assert
      expect(result.isRight(), isTrue);
    });
  });
}
