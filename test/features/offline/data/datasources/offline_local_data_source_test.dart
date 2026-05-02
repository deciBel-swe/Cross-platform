import 'dart:convert';
import 'dart:io';

import 'package:decibel/core/network/dio_client.dart';
import 'package:decibel/features/library/data/datasources/library_remote_datasource.dart';
import 'package:decibel/features/library/data/models/track_model.dart';
import 'package:decibel/features/library/data/models/track_peaks_model.dart';
import 'package:decibel/features/library/domain/entities/artist.dart';
import 'package:decibel/features/library/domain/entities/track.dart';
import 'package:decibel/features/library/domain/entities/track_status.dart';
import 'package:decibel/features/offline/data/datasources/offline_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockDioClient extends Mock implements DioClient {}

class MockLibraryRemoteDatasource extends Mock
    implements LibraryRemoteDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OfflineLocalDataSource dataSource;
  late MockDioClient mockDioClient;
  late MockLibraryRemoteDatasource mockLibraryRemoteDatasource;
  late Directory tempDir;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('offline_test');
    
    // Mock path_provider
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    mockDioClient = MockDioClient();
    mockLibraryRemoteDatasource = MockLibraryRemoteDatasource();
    dataSource = OfflineLocalDataSource(
      mockDioClient,
      mockLibraryRemoteDatasource,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  final tTrack = Track(
    id: 1,
    title: 'Test Track',
    artist: const Artist(id: 1, username: 'artist'),
    trackUrl: 'https://example.com/audio.mp3',
    waveformUrl: 'https://example.com/peaks.json',
    genre: 'Pop',
    tags: const [],
    state: TrackStatus.finished,
    releaseDate: DateTime(2024),
    playCount: 10,
    likeCount: 5,
    repostCount: 2,
    isLiked: false,
    isReposted: false,
    createdAt: DateTime(2024),
    trackDurationSeconds: 180,
  );

  final tPeaksModel = TrackPeaksModel(
    trackId: 1,
    duration: 180,
    peaks: [10, 50, 90],
  );

  group('downloadAndSave', () {
    test('should download audio, metadata and peaks successfully', () async {
      // arrange
      when(() => mockLibraryRemoteDatasource.fetchTrackPeaks(any(),
              waveformUrl: any(named: 'waveformUrl')))
          .thenAnswer((_) async => tPeaksModel);
      when(() => mockDioClient.download(any(), any(),
              options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
              ));

      // act
      final result = await dataSource.downloadAndSave(tTrack);

      // assert
      final expectedDataPath = p.join(tempDir.path, 'tracks', 'track_1.dat');
      final expectedMetaPath = p.join(tempDir.path, 'tracks', 'track_1.json');
      final expectedPeaksPath = p.join(tempDir.path, 'tracks', 'peaks_1.json');

      expect(p.canonicalize(result), p.canonicalize(expectedDataPath));
      expect(File(expectedMetaPath).existsSync(), true);
      expect(File(expectedPeaksPath).existsSync(), true);

      final metaContent = File(expectedMetaPath).readAsStringSync();
      final metaJson = jsonDecode(metaContent);
      expect(p.canonicalize(metaJson['trackUrl']), p.canonicalize(expectedDataPath));
    });

    test('should continue if peaks fetch fails', () async {
      // arrange
      when(() => mockLibraryRemoteDatasource.fetchTrackPeaks(any(),
              waveformUrl: any(named: 'waveformUrl')))
          .thenThrow(Exception('Peaks failed'));
      when(() => mockDioClient.download(any(), any(),
              options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
              ));

      // act
      await dataSource.downloadAndSave(tTrack);

      // assert
      final expectedPeaksPath = p.join(tempDir.path, 'tracks', 'peaks_1.json');
      expect(File(expectedPeaksPath).existsSync(), false);
    });

    test('should delete partial file if audio download fails', () async {
      // arrange
      when(() => mockLibraryRemoteDatasource.fetchTrackPeaks(any(),
              waveformUrl: any(named: 'waveformUrl')))
          .thenAnswer((_) async => tPeaksModel);
      
      final dataPath = p.join(tempDir.path, 'tracks', 'track_1.dat');

      // Stub download to create a file then throw
      when(() => mockDioClient.download(any(), any(),
              options: any(named: 'options')))
          .thenAnswer((invocation) async {
            // invocation.positionalArguments[1] is savePath
            await Directory(p.dirname(dataPath)).create(recursive: true);
            await File(dataPath).writeAsString('partial');
            throw DioException(requestOptions: RequestOptions(path: ''));
          });

      // act & assert
      await expectLater(
        () => dataSource.downloadAndSave(tTrack),
        throwsA(isA<DioException>()),
      );

      expect(File(dataPath).existsSync(), false);
    });

    test('should skip download if file already exists', () async {
      // arrange
      final dataPath = p.join(tempDir.path, 'tracks', 'track_1.dat');
      await Directory(p.dirname(dataPath)).create(recursive: true);
      await File(dataPath).writeAsString('existing');

      // act
      final result = await dataSource.downloadAndSave(tTrack);

      // assert
      expect(p.canonicalize(result), p.canonicalize(dataPath));
      verifyNever(() => mockDioClient.download(any(), any(), options: any(named: 'options')));
    });
  });

  group('getOfflineTracks', () {
    test('should return list of tracks with existing .dat files', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);

      // Track 1: metadata + dat (Good)
      final meta1 = TrackModelX.fromEntity(tTrack).copyWith(id: 1);
      await File(p.join(tracksPath, 'track_1.json'))
          .writeAsString(jsonEncode(meta1.toJson()));
      await File(p.join(tracksPath, 'track_1.dat')).writeAsString('audio1');

      // Track 2: metadata only (Bad)
      final meta2 = TrackModelX.fromEntity(tTrack).copyWith(id: 2);
      await File(p.join(tracksPath, 'track_2.json'))
          .writeAsString(jsonEncode(meta2.toJson()));

      // act
      final result = await dataSource.getOfflineTracks();

      // assert
      expect(result.length, 1);
      expect(result[0].id, 1);
    });

    test('should sort tracks by id descending', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);

      for (int i = 1; i <= 3; i++) {
        final meta = TrackModelX.fromEntity(tTrack).copyWith(id: i);
        await File(p.join(tracksPath, 'track_$i.json'))
            .writeAsString(jsonEncode(meta.toJson()));
        await File(p.join(tracksPath, 'track_$i.dat')).writeAsString('audio');
      }

      // act
      final result = await dataSource.getOfflineTracks();

      // assert
      expect(result.map((e) => e.id).toList(), [3, 2, 1]);
    });
  });

  group('getOfflineTrackById', () {
    test('should return track when both metadata and .dat exist', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);
      final meta = TrackModelX.fromEntity(tTrack).copyWith(id: 1);
      await File(p.join(tracksPath, 'track_1.json'))
          .writeAsString(jsonEncode(meta.toJson()));
      await File(p.join(tracksPath, 'track_1.dat')).writeAsString('audio');

      // act
      final result = await dataSource.getOfflineTrackById(1);

      // assert
      expect(result, isNotNull);
      expect(result!.id, 1);
    });

    test('should return null when .dat is missing', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);
      final meta = TrackModelX.fromEntity(tTrack).copyWith(id: 1);
      await File(p.join(tracksPath, 'track_1.json'))
          .writeAsString(jsonEncode(meta.toJson()));

      // act
      final result = await dataSource.getOfflineTrackById(1);

      // assert
      expect(result, isNull);
    });
  });

  group('getOfflineTrackPeaksById', () {
    test('should return peaks when file exists', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);
      await File(p.join(tracksPath, 'peaks_1.json'))
          .writeAsString(jsonEncode(tPeaksModel.toJson()));

      // act
      final result = await dataSource.getOfflineTrackPeaksById(1);

      // assert
      expect(result, isNotNull);
      expect(result!.trackId, 1);
      expect(result!.peaks, tPeaksModel.peaks);
    });

    test('should return null when file does not exist', () async {
      // act
      final result = await dataSource.getOfflineTrackPeaksById(1);

      // assert
      expect(result, isNull);
    });
  });

  group('Collection Metadata', () {
    const tInfo = OfflineCollectionInfo(
      id: 10,
      title: 'Offline Playlist',
      coverUrl: 'cover.jpg',
      trackIds: [1, 2, 3],
    );

    test('should save and retrieve collection metadata', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      await Directory(tracksPath).create(recursive: true);
      await File(p.join(tracksPath, 'track_1.dat')).writeAsString('audio');

      // act
      await dataSource.saveCollectionMetadata(tInfo);
      final result = await dataSource.getOfflineCollections();

      // assert
      expect(result.length, 1);
      expect(result[0].title, 'Offline Playlist');
      expect(result[0].trackIds, [1, 2, 3]);
    });

    test('should filter out collections with no downloaded tracks', () async {
      // arrange
      await dataSource.saveCollectionMetadata(tInfo);

      // act
      final result = await dataSource.getOfflineCollections();

      // assert
      expect(result, isEmpty);
    });

    test('should remove track from collection', () async {
      // arrange
      await dataSource.saveCollectionMetadata(tInfo);

      // act
      await dataSource.removeTrackFromCollection(10, 2);
      
      final dir = p.join(tempDir.path, 'collections');
      final content = await File('$dir/collection_10.json').readAsString();
      final json = jsonDecode(content);
      
      // assert
      expect(json['trackIds'], [1, 3]);
    });

    test('should update collection metadata', () async {
      // arrange
      await dataSource.saveCollectionMetadata(tInfo);
      final updatedInfo = tInfo.copyWith(title: 'Updated Title');

      // act
      await dataSource.updateCollectionMetadata(updatedInfo);
      
      final dir = p.join(tempDir.path, 'collections');
      final content = await File('$dir/collection_10.json').readAsString();
      final json = jsonDecode(content);
      
      // assert
      expect(json['title'], 'Updated Title');
    });

    test('should delete collection metadata', () async {
      // arrange
      await dataSource.saveCollectionMetadata(tInfo);
      final dir = p.join(tempDir.path, 'collections');
      final filePath = '$dir/collection_10.json';
      expect(File(filePath).existsSync(), true);

      // act
      await dataSource.deleteCollectionMetadata(10);

      // assert
      expect(File(filePath).existsSync(), false);
    });
  });

  group('clearAll', () {
    test('should delete tracks and collections directories', () async {
      // arrange
      final tracksPath = p.join(tempDir.path, 'tracks');
      final collectionsPath = p.join(tempDir.path, 'collections');
      await Directory(tracksPath).create(recursive: true);
      await Directory(collectionsPath).create(recursive: true);

      expect(Directory(tracksPath).existsSync(), true);
      expect(Directory(collectionsPath).existsSync(), true);

      // act
      await dataSource.clearAll();

      // assert
      expect(Directory(tracksPath).existsSync(), false);
      expect(Directory(collectionsPath).existsSync(), false);
    });
  });
}
