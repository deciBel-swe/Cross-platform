import 'package:decibel/core/errors/exceptions.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/engagement/data/datasources/playlist_social_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late PlaylistSocialRemoteDatasource dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = PlaylistSocialRemoteDatasource(mockDioClient);
  });

  final tTrackData = {
    'id': 101,
    'title': 'Track 1',
    'artist': {'id': 1, 'username': 'artist1'},
    'state': 'FINISHED',
    'releaseDate': '2026-05-01T12:00:00Z',
    'createdAt': '2026-05-01T12:00:00Z',
  };

  group('toggleLike', () {
    const tPlaylistId = 1;

    test('should perform a DELETE request when isCurrentlyLiked is true', () async {
      // arrange
        when(() => mockDioClient.delete<dynamic>(any()))
          .thenAnswer((_) async => Response(data: <String, dynamic>{}, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.toggleLike(tPlaylistId, isCurrentlyLiked: true);
      // assert
      expect(result, isFalse);
      verify(() => mockDioClient.delete<dynamic>('/playlists/$tPlaylistId/like'));
    });

    test('should perform a POST request when isCurrentlyLiked is false', () async {
      // arrange
      when(() => mockDioClient.post<dynamic>(any()))
          .thenAnswer((_) async => Response(data: {'isLiked': true}, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.toggleLike(tPlaylistId, isCurrentlyLiked: false);
      // assert
      expect(result, isTrue);
      verify(() => mockDioClient.post<dynamic>('/playlists/$tPlaylistId/like'));
    });

    test('should throw NetworkException on connection error', () async {
      // arrange
      when(() => mockDioClient.post<dynamic>(any()))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ));
      // act & assert
      expect(() => dataSource.toggleLike(tPlaylistId, isCurrentlyLiked: false), throwsA(isA<NetworkException>()));
    });
  });

  group('getLikedPlaylists', () {
    const tUsername = 'testuser';

    test('should return List<PlaylistModel> when successful', () async {
      // arrange
      final tResponseData = {
        'content': [
          {
            'id': 1,
            'title': 'Liked Playlist',
            'type': 'PLAYLIST',
            'isPrivate': false,
            'owner': {'id': 1, 'username': 'owner'},
            'createdAt': '2026-05-01T12:00:00Z',
            'updatedAt': '2026-05-01T12:00:00Z',
          }
        ]
      };
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getLikedPlaylists(tUsername);
      // assert
      expect(result, hasLength(1));
      expect(result.first.title, 'Liked Playlist');
    });

    test('should return empty list when data is null', () async {
      // arrange
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: null, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getLikedPlaylists(tUsername);
      // assert
      expect(result, isEmpty);
    });

    test('should handle paginatedTrackResponse normalization', () async {
      // arrange
      final tResponseData = [
        {
          'id': 1,
          'title': 'Liked Playlist',
          'type': 'PLAYLIST',
          'paginatedTrackResponse': {
            'content': [tTrackData]
          }
        }
      ];
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenAnswer((_) async => Response(data: tResponseData, requestOptions: RequestOptions(path: '')));
      // act
      final result = await dataSource.getLikedPlaylists(tUsername);
      // assert
      expect(result.first.tracks, hasLength(1));
      expect(result.first.tracks.first.id, 101);
    });

    test('should throw ServerException on bad response', () async {
      // arrange
      when(() => mockDioClient.get<dynamic>(any(), queryParams: any(named: 'queryParams')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          data: {'message': 'Error'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      ));
      // act & assert
      expect(() => dataSource.getLikedPlaylists(tUsername), throwsA(isA<ServerException>()));
    });
  });
}
