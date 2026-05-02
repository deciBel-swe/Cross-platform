import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/engagement/data/datasources/follow_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late FollowRemoteDataSource dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = FollowRemoteDataSource(mockDioClient);
  });

  group('getPublicProfile', () {
    const tUserIdentifier = '123';

    test('should return PublicProfileModel when successful', () async {
      // arrange
      final tResponseData = {
        'id': 123,
        'username': 'testuser',
        'tier': 'FREE',
        'profile': {
          'bio': 'bio',
          'city': 'City',
          'country': 'Country',
          'profilePic': 'avatar',
          'coverPic': 'cover',
        },
        'stats': {
          'followersCount': 10,
          'followingCount': 5,
          'trackCount': 3,
        },
        'isFollowed': true,
      };
      when(() => mockDioClient.get<dynamic>(any()))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getPublicProfile(tUserIdentifier);
      // assert
      expect(result.id, 123);
      expect(result.username, 'testuser');
      expect(result.isFollowing, true);
      expect(result.profile!.location, 'City, Country');
    });

    test('should handle nested data and profile in getPublicProfile', () async {
      // arrange
      final tResponseData = {
        'data': {
          'profile': {
            'id': 123,
            'username': 'testuser',
            'DisplayName': 'Test User',
            'socialLinksDto': {'instagram': 'insta'},
          },
          'relationship': {
            'isFollowing': true,
            'isFollowedBy': false,
          }
        }
      };
      when(() => mockDioClient.get<dynamic>(any()))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getPublicProfile(tUserIdentifier);
      // assert
      expect(result.id, 123);
      expect(result.displayName, 'Test User');
      expect(result.isFollowing, true);
      expect(result.socialLinks?.instagram, 'insta');
    });

    test('should throw AuthException on 401', () async {
      // arrange
      when(() => mockDioClient.get<dynamic>(any()))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(statusCode: 401, requestOptions: RequestOptions(path: '')),
      ));
      // act & assert
      expect(() => dataSource.getPublicProfile(tUserIdentifier), throwsA(isA<AuthException>()));
    });
  });

  group('followUser', () {
    const tUserId = 1;

    test('should return FollowResponseModel when successful', () async {
      // arrange
      when(() => mockDioClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(data: {'isFollowing': true, 'message': 'Followed'}, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.followUser(tUserId);
      // assert
      expect(result.isFollowing, true);
    });

    test('should throw ServerException on bad response', () async {
      // arrange
      when(() => mockDioClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(statusCode: 500, requestOptions: RequestOptions(path: '')),
      ));
      // act & assert
      expect(() => dataSource.followUser(tUserId), throwsA(isA<ServerException>()));
    });
  });

  group('unfollowUser', () {
    const tUserId = 1;

    test('should return FollowResponseModel when successful', () async {
      // arrange
      when(() => mockDioClient.delete<dynamic>(any()))
          .thenAnswer((_) async => Response(data: {'isFollowing': false, 'message': 'Unfollowed'}, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.unfollowUser(tUserId);
      // assert
      expect(result.isFollowing, false);
    });
  });

  group('getFollowers', () {
    test('should return PaginatedEngagersModel when successful', () async {
      // arrange
      final tResponseData = {
        'content': [
          {'id': 1, 'username': 'user1'}
        ],
        'pageNumber': 0,
        'pageSize': 10,
        'totalElements': 1,
        'totalPages': 1,
        'isLast': true,
      };
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getFollowers(userId: 1, page: 0, size: 10);
      // assert
      expect(result.content, hasLength(1));
    });
  });

  group('getFollowing', () {
    test('should return PaginatedEngagersModel when successful', () async {
      // arrange
      final tResponseData = {
        'items': [
          {'id': 1, 'username': 'user1'}
        ],
        'page': 0,
        'size': 10,
        'total': 1,
      };
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getFollowing(userId: 1, page: 0, size: 10);
      // assert
      expect(result.content, hasLength(1));
    });
  });

  group('getFriends', () {
    test('should return PaginatedEngagersModel when successful', () async {
      // arrange
      final tResponseData = {
        'users': [
          {'id': 1, 'userName': 'friend'}
        ],
        'page': 0,
        'size': 10,
        'total': 1,
      };
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getFriends(page: 0, size: 10);
      // assert
      expect(result.content, hasLength(1));
      expect(result.content.first.username, 'friend');
    });
  });

  group('getSuggestedUsers', () {
    test('should handle List response', () async {
      // arrange
      final tResponseData = [
        {'id': 1, 'username': 'user1'}
      ];
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getSuggestedUsers(page: 0, size: 10);
      // assert
      expect(result.content, hasLength(1));
      expect(result.totalElements, 1);
    });
  });

  group('_normalizeUserItem', () {
    test('should handle nested profile in user item', () async {
      // arrange
      final tResponseData = {
        'content': [
          {
            'id': 1,
            'profile': {
              'username': 'user1',
              'avatarUrl': 'url1',
              'tier': {'name': 'PREMIUM'}
            },
            'isFollowingByCurrentUser': true
          }
        ]
      };
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getFollowers(userId: 1, page: 0, size: 10);
      // assert
      expect(result.content.first.username, 'user1');
      expect(result.content.first.tier, 'PREMIUM');
      expect(result.content.first.isFollowing, true);
    });
  });
}
