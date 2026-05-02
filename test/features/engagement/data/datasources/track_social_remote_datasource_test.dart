import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/engagement/data/datasources/track_social_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late TrackSocialRemoteDatasource dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = TrackSocialRemoteDatasource(mockDioClient);
  });

  final tTrackData = {
    'id': 101,
    'title': 'Track 1',
    'artist': {'id': 1, 'username': 'artist1'},
    'state': 'FINISHED',
    'releaseDate': '2026-05-01T12:00:00Z',
    'createdAt': '2026-05-01T12:00:00Z',
  };

  group('like/unlike/repost/unrepost', () {
    test('likeTrack should perform a POST request', () async {
      when(() => mockDioClient.post<dynamic>(any()))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      await dataSource.likeTrack(1);
      verify(() => mockDioClient.post<dynamic>('/tracks/1/like')).called(1);
    });

    test('unlikeTrack should perform a DELETE request', () async {
      when(() => mockDioClient.delete<dynamic>(any()))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      await dataSource.unlikeTrack(1);
      verify(() => mockDioClient.delete<dynamic>('/tracks/1/like')).called(1);
    });

    test('repostTrack should perform a POST request', () async {
      when(() => mockDioClient.post<dynamic>(any()))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      await dataSource.repostTrack(1);
      verify(() => mockDioClient.post<dynamic>('/tracks/1/repost')).called(1);
    });

    test('unrepostTrack should perform a DELETE request', () async {
      when(() => mockDioClient.delete<dynamic>(any()))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      await dataSource.unrepostTrack(1);
      verify(() => mockDioClient.delete<dynamic>('/tracks/1/repost')).called(1);
    });
  });

  group('getLikedTracks', () {
    final tResponseData = {
      'content': [tTrackData],
      'number': 0,
      'size': 10,
      'totalElements': 1,
      'totalPages': 1,
      'last': true,
    };

    test('should try /users/me/liked-tracks when no userId or username provided', () async {
      when(() => mockDioClient.get<Map<String, dynamic>>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));

      await dataSource.getLikedTracks(page: 0, size: 10);

      verify(() => mockDioClient.get<Map<String, dynamic>>('/users/me/liked-tracks', queryParams: {'page': 0, 'size': 10})).called(1);
    });

    test('should try fallback when first endpoint fails with 404', () async {
      when(() => mockDioClient.get<Map<String, dynamic>>('/users/me/liked-tracks', queryParams: any(named: 'queryParams')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/users/me/liked-tracks'),
        response: Response(statusCode: 404, requestOptions: RequestOptions(path: '/users/me/liked-tracks')),
      ));

      when(() => mockDioClient.get<Map<String, dynamic>>('/users/me', queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: {'id': 123}, requestOptions: RequestOptions(path: '/users/me')));

      when(() => mockDioClient.get<Map<String, dynamic>>('/users/123/liked-tracks', queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '/users/123/liked-tracks')));

      await dataSource.getLikedTracks(page: 0, size: 10);

      verify(() => mockDioClient.get<Map<String, dynamic>>('/users/me/liked-tracks', queryParams: {'page': 0, 'size': 10})).called(1);
      verify(() => mockDioClient.get<Map<String, dynamic>>('/users/123/liked-tracks', queryParams: {'page': 0, 'size': 10})).called(1);
    });
  });

  group('fetchTrackLikers/Reposters', () {
    test('fetchTrackLikers should return PaginatedEngagersModel', () async {
      final tResponseData = {
        'content': [
          {'id': 1, 'username': 'user1', 'tier': 'FREE', 'profile': {'avatarUrl': 'url'}}
        ],
        'pageNumber': 0,
        'pageSize': 10,
        'totalElements': 1,
        'totalPages': 1,
        'isLast': true,
      };
      when(() => mockDioClient.get<Map<String, dynamic>>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));

      final result = await dataSource.fetchTrackLikers(trackId: 1, page: 0, size: 10);

      expect(result.content.first.username, 'user1');
      expect(result.totalElements, 1);
    });

    test('fetchTrackReposters should return PaginatedEngagersModel', () async {
      final tResponseData = {
        'content': [
          {'id': 2, 'username': 'user2', 'tier': 'PREMIUM'}
        ],
        'pageNumber': 0,
        'pageSize': 10,
        'totalElements': 1,
        'totalPages': 1,
        'isLast': true,
      };
      when(() => mockDioClient.get<Map<String, dynamic>>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));

      final result = await dataSource.fetchTrackReposters(trackId: 1, page: 0, size: 10);

      expect(result.content.first.username, 'user2');
    });
  });

  group('reportTrack', () {
    test('should perform a POST request with correct data', () async {
      when(() => mockDioClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      
      await dataSource.reportTrack(trackId: 1, reason: 'SPAM', description: 'Desc');
      
      verify(() => mockDioClient.post<dynamic>(
        '/tracks/1/report',
        data: {'reason': 'SPAM', 'description': 'Desc'},
      )).called(1);
    });
  });
}
