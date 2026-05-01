import 'dart:io';

import 'package:decibel/core/constants/api_constants.dart';
import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/playlists/data/datasources/playlist_remote_datasource.dart';
import 'package:decibel/features/playlists/data/models/create_playlist_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient dioClient;
  late PlaylistRemoteDatasource datasource;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dioClient = MockDioClient();
    datasource = PlaylistRemoteDatasource(dioClient);
  });

  group('PlaylistRemoteDatasource.getUserPlaylists', () {
    test('parses paginated playlists wrapped in data', () async {
      when(
        () => dioClient.get<dynamic>(
          ApiConstants.myPlaylists,
          queryParams: <String, dynamic>{'page': 0, 'size': 20},
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ApiConstants.myPlaylists),
          data: <String, Object?>{
            'data': <String, Object?>{
              'content': <Map<String, Object?>>[_playlistJson()],
              'pageNumber': 0,
              'pageSize': 20,
              'totalElements': 1,
              'totalPages': 1,
              'isLast': true,
            },
          },
        ),
      );

      final playlists = await datasource.getUserPlaylists();

      expect(playlists, hasLength(1));
      expect(playlists.single.id, 7);
      expect(playlists.single.title, 'Late Night Drafts');
      expect(playlists.single.trackCount, 12);
    });
  });

  group('PlaylistRemoteDatasource cover upload', () {
    test('createPlaylist sends cover image as multipart CoverArt', () async {
      final cover = await _temporaryImageFile();
      addTearDown(() {
        if (cover.existsSync()) {
          cover.deleteSync();
        }
      });

      when(
        () => dioClient.post<dynamic>(
          ApiConstants.playlists,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ApiConstants.playlists),
          data: _playlistJson(),
        ),
      );

      await datasource.createPlaylist(
        const CreatePlaylistRequest(title: 'Cover check'),
        cover,
      );

      final captured =
          verify(
                () => dioClient.post<dynamic>(
                  ApiConstants.playlists,
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;

      expect(captured.files.map((entry) => entry.key), contains('coverArt'));
    });

    test('updatePlaylist sends cover image as multipart CoverArt', () async {
      final cover = await _temporaryImageFile();
      addTearDown(() {
        if (cover.existsSync()) {
          cover.deleteSync();
        }
      });

      when(
        () => dioClient.patch<dynamic>(
          '${ApiConstants.playlists}/7',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: '${ApiConstants.playlists}/7'),
          data: _playlistJson(),
        ),
      );

      await datasource.updatePlaylist(
        7,
        const CreatePlaylistRequest(title: 'Cover check'),
        cover,
      );

      final captured =
          verify(
                () => dioClient.patch<dynamic>(
                  '${ApiConstants.playlists}/7',
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;

      expect(captured.files.map((entry) => entry.key), contains('coverArt'));
    });
  });
}

Map<String, Object?> _playlistJson() {
  return <String, Object?>{
    'id': 7,
    'title': 'Late Night Drafts',
    'type': 'PLAYLIST',
    'isLiked': false,
    'description': null,
    'isPrivate': false,
    'coverArtUrl': 'https://example.com/cover.jpg',
    'playlistSlug': 'late-night-drafts',
    'totalDurationSeconds': 3600,
    'trackCount': 12,
    'owner': <String, Object?>{
      'id': 3,
      'username': 'decibel',
      'displayName': 'Decibel',
      'avatarUrl': null,
    },
    'genres': <String>['Electronic'],
    'createdAt': '2026-04-25T10:00:00Z',
    'trackSummary': const <Map<String, Object?>>[],
    'firstTrackWaveformUrl': null,
  };
}

Future<File> _temporaryImageFile() async {
  final file = File(
    '${Directory.systemTemp.path}/decibel_playlist_cover_${DateTime.now().microsecondsSinceEpoch}.jpg',
  );
  return file.writeAsBytes(<int>[0, 1, 2, 3]);
}
