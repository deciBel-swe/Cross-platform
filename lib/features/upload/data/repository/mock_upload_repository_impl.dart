import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/data/datasources/auth_mock_fixtures.dart';
import '../../../library/data/datasources/library_mock_fixtures.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/domain/entities/track.dart';
import '../../domain/entities/track_upload_metadata.dart';
import '../../domain/entities/track_upload_status.dart';
import '../../domain/repositories/i_upload_repository.dart';
import '../models/track_metadata_model.dart';

@Environment('mock')
@LazySingleton(as: IUploadRepository)
class MockUploadRepository implements IUploadRepository {
  const MockUploadRepository();

  List<int> _peaksFromWaveFormData(List<double> source) {
    if (source.isEmpty) return const <int>[];

    return source
        .map((value) {
          final normalized = value.isNaN ? 0.0 : value.abs();
          final clamped = normalized.clamp(0.0, 1.0);
          return (clamped * 50).round();
        })
        .toList(growable: false);
  }

  int _allocateTrackId() {
    final existingIds = <int>[
      ...LibraryMockFixtures.allTracks.map((t) => t['id'] as int),
      ...LibraryMockFixtures.trackMetaDataById.keys,
      ...LibraryMockFixtures.trackPeaksById.keys,
    ];

    if (existingIds.isEmpty) return 1;
    return existingIds.fold<int>(0, (prev, curr) => curr > prev ? curr : prev) +
        1;
  }

  @override
  Future<Either<Failure, Track>> uploadTrack(
    TrackUploadMetadata metadata,
  ) async {
    final audioFile = metadata.audioFile;
    if (audioFile == null) {
      return const Left(ServerFailure('Audio file is required'));
    }

    try {
      final model = metadata.toModel();
      final id = _allocateTrackId();
      final now = DateTime.now().toUtc().toIso8601String();

      final trackUrl = audioFile.path;

      // Simulate the logged-in user from AuthMockFixtures
      final mockUser =
          AuthMockFixtures.mockLoginResponse['user'] as Map<String, dynamic>;
      final artistId = mockUser['id'] as int;
      final username = mockUser['username'] as String;

      final trackJson = <String, dynamic>{
        'id': id,
        'title': model.title,
        'artist': <String, dynamic>{'id': artistId, 'username': username},
        'trackUrl': trackUrl,
        // Use local file path for coverUrl so UI can display it
        'coverUrl': metadata.coverImage?.path,
        'waveformUrl': trackUrl,
        'genre': model.genre,
        'tags': model.tags ?? const <String>[],
        'state': 'PROCESSING',
        'access': model.access,
        'releaseDate': model.releaseDate,
        'playCount': 0,
        'likeCount': 0,
        'repostCount': 0,
        'createdAt': now,
      };

      // Put newest first so it appears immediately in paginated mock lists.
      LibraryMockFixtures.allTracks.insert(0, trackJson);
      LibraryMockFixtures.trackMetaDataById[id] = trackJson;

      Future.delayed(const Duration(seconds: 5), () {
        // Update state in allTracks
        final index = LibraryMockFixtures.allTracks.indexWhere(
          (t) => t['id'] == id,
        );
        if (index != -1) {
          LibraryMockFixtures.allTracks[index]['state'] = 'FINISHED';
        }
        // Update state in trackMetaDataById
        if (LibraryMockFixtures.trackMetaDataById.containsKey(id)) {
          LibraryMockFixtures.trackMetaDataById[id]!['state'] = 'FINISHED';
        }
        if (kDebugMode) {
          debugPrint('[MockUploadRepository] Finished processing track id=$id');
        }
      });

      if (kDebugMode) {
        debugPrint(
          '[MockUploadRepository] inserted track id=$id, allTracks=${LibraryMockFixtures.allTracks.length}',
        );
      }

      final peaks = _peaksFromWaveFormData(model.waveFormData);

      // Store peaks if available
      if (peaks.isNotEmpty) {
        LibraryMockFixtures.trackPeaksById[id] = <String, dynamic>{
          'trackId': id, // Ensure ID matches
          'duration': 0,
          'peaks': peaks,
        };
      }

      if (kDebugMode) {
        debugPrint(
          '[MockUploadRepository] stored peaks for trackId=$id, peaks=${peaks.length}',
        );
      }

      final trackModel = TrackModel.fromJson(trackJson);
      return Right(trackModel.toEntity());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MockUploadRepository] error: $e');
      }
      return const Left(
        ServerFailure('An unexpected error occurred during file upload'),
      );
    }
  }

  @override
  Stream<TrackUploadStatus> watchUploadStatus(String uploadId) async* {
    // Simulate a network upload stream going from 0 to 100%
    for (int i = 0; i <= 100; i += 10) {
      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(milliseconds: 400));
      yield TrackUploadStatus(
        state: i >= 100
            ? TrackUploadState.finished
            : TrackUploadState.processing,
        progressPercentage: i,
        stepName: i >= 100 ? 'Ready' : 'Processing audio',
      );
    }
  }

  @override
  void cancelUploadStatusSubscription(String uploadId) {
    // No-op for the mock
    if (kDebugMode) {
      debugPrint('[MockUploadRepository] WebSocket progress cancelled');
    }
  }
}
