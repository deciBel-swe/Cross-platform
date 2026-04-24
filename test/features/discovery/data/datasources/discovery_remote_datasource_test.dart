import 'package:decibel/core/constants/api_constants.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/discovery/data/datasources/discovery_remote_datasource.dart';
import 'package:decibel/features/discovery/domain/entities/discovery_search_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late DiscoveryRemoteDataSource dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = DiscoveryRemoteDataSourceImpl(mockDioClient);
  });

  group('DiscoveryRemoteDataSource', () {
    test('getTrendingTracks parses paginated responses', () async {
      when(
        () => mockDioClient.get<dynamic>(
          ApiConstants.trendingTracksEndpoint,
          queryParams: <String, Object?>{'limit': 6},
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(
            path: ApiConstants.trendingTracksEndpoint,
          ),
          data: <String, Object?>{
            'content': <Map<String, Object?>>[
              <String, Object?>{
                'id': 11,
                'title': 'City Lights',
                'artist': <String, Object?>{
                  'id': 4,
                  'username': 'nightdrive',
                  'avatarUrl': 'https://example.com/avatar.png',
                },
                'genre': 'Electronic',
                'playCount': 1200,
                'likeCount': 340,
              },
            ],
            'pageNumber': 0,
            'pageSize': 6,
            'totalElements': 1,
            'totalPages': 1,
            'isLast': true,
          },
        ),
      );

      final result = await dataSource.getTrendingTracks(limit: 6);

      expect(result.content, hasLength(1));
      expect(result.content.first.id, 11);
      expect(result.content.first.artist.username, 'nightdrive');
      expect(result.pageSize, 6);
      expect(result.isLast, isTrue);
    });

    test('search parses resource-based responses', () async {
      when(
        () => mockDioClient.get<dynamic>(
          ApiConstants.globalSearchEndpoint,
          queryParams: <String, Object?>{
            'q': 'lofi',
            'type': DiscoverySearchType.all.queryValue,
            'page': 0,
            'size': 20,
          },
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ApiConstants.globalSearchEndpoint),
          data: <String, Object?>{
            'content': <Map<String, Object?>>[
              <String, Object?>{
                'resourceType': 'USER',
                'resourceId': 7,
                'user': <String, Object?>{'id': 7, 'username': 'sunsetloops'},
              },
              <String, Object?>{
                'resourceType': 'TRACK',
                'resourceId': 8,
                'track': <String, Object?>{
                  'id': 8,
                  'title': 'Tape Hiss',
                  'artist': <String, Object?>{'id': 7, 'username': 'sunsetloops'},
                },
              },
              <String, Object?>{
                'resourceType': 'PLAYLIST',
                'resourceId': 9,
                'playlist': <String, Object?>{
                  'id': 9,
                  'title': 'Late Study',
                  'owner': <String, Object?>{'id': 7, 'username': 'sunsetloops'},
                },
              },
            ],
            'pageNumber': 0,
            'pageSize': 20,
            'totalElements': 3,
            'totalPages': 1,
            'isLast': true,
          },
        ),
      );

      final result = await dataSource.search(
        query: 'lofi',
        type: DiscoverySearchType.all,
        page: 0,
        size: 20,
      );

      expect(result.users.single.id, 7);
      expect(result.tracks.single.artist.username, 'sunsetloops');
      expect(result.playlists.single.owner.username, 'sunsetloops');
    });

    test('getGenreStation treats no-results responses as empty content', () async {
      when(
        () => mockDioClient.get<dynamic>(
          ApiConstants.genreStationEndpoint,
          queryParams: <String, Object?>{
            'genre': 'Electronic',
            'page': 0,
            'size': 6,
          },
        ),
      ).thenAnswer(
        (_) async => throw DioException(
          requestOptions: RequestOptions(path: ApiConstants.genreStationEndpoint),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: ApiConstants.genreStationEndpoint),
            statusCode: 404,
            data: <String, Object?>{
              'status': 204,
              'error': 'No Results',
              'message': 'No tracks found for this station.',
            },
          ),
        ),
      );

      final result = await dataSource.getGenreStation(
        genre: 'Electronic',
        page: 0,
        size: 6,
      );

      expect(result.content, isEmpty);
      expect(result.totalElements, 0);
    });
  });
}
