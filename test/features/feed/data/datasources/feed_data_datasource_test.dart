import 'package:decibel/core/constants/api_constants.dart';
import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/feed/data/datasources/feed_data_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient dioClient;
  late FeedRemoteDatasource datasource;

  setUp(() {
    dioClient = MockDioClient();
    datasource = FeedRemoteDatasource(dioClient);
  });

  test('getDiscoverFeed uses artist station endpoint with pagination', () async {
    when(
      () => dioClient.get<dynamic>(
        ApiConstants.artistStationEndpoint,
        queryParams: <String, Object?>{'page': 0, 'size': 20},
      ),
    ).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: ApiConstants.artistStationEndpoint),
        data: <String, Object?>{
          'content': <Map<String, Object?>>[
            <String, Object?>{
              'id': 7,
              'title': 'Similar Signal',
              'trackSlug': 'similar-signal',
              'coverUrl': null,
              'trackUrl': 'https://example.com/track.mp3',
              'trackPreviewUrl': null,
              'artist': <String, Object?>{
                'id': 4,
                'username': 'nightdrive',
                'displayName': 'Night Drive',
                'avatarUrl': null,
              },
              'playCount': 20,
              'likeCount': 5,
              'repostCount': 1,
              'commentCount': 0,
              'isLiked': false,
              'isReposted': false,
              'secretToken': 'secret',
              'access': 'PLAYABLE',
            },
          ],
          'pageNumber': 0,
          'pageSize': 20,
          'totalElements': 1,
          'totalPages': 1,
          'isLast': true,
        },
      ),
    );

    final result = await datasource.getDiscoverFeed(page: 0, size: 20);

    expect(result.content.single.id, 7);
    expect(result.content.single.artist['username'], 'nightdrive');
    expect(result.pageSize, 20);
    verify(
      () => dioClient.get<dynamic>(
        ApiConstants.artistStationEndpoint,
        queryParams: <String, Object?>{'page': 0, 'size': 20},
      ),
    ).called(1);
  });

  test('getFeed calls /feed with correct parameters', () async {
    when(
      () => dioClient.get<dynamic>(
        '/feed',
        queryParams: <String, Object?>{'page': 1, 'size': 10},
      ),
    ).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: '/feed'),
        data: <String, Object?>{
          'content': [],
          'pageNumber': 1,
          'pageSize': 10,
          'totalElements': 0,
          'totalPages': 0,
          'isLast': true,
        },
      ),
    );

    final result = await datasource.getFeed(page: 1, size: 10);

    expect(result.pageNumber, 1);
    expect(result.pageSize, 10);
    verify(
      () => dioClient.get<dynamic>(
        '/feed',
        queryParams: <String, Object?>{'page': 1, 'size': 10},
      ),
    ).called(1);
  });

  test('should throw NetworkException on Dio connection error', () async {
    when(
      () => dioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/feed'),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(
      () => datasource.getFeed(page: 0, size: 20),
      throwsA(isA<NetworkException>()),
    );
  });
}
