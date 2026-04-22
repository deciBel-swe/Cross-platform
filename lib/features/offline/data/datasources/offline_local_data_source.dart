import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/network/dio_client.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/domain/entities/track.dart';

@lazySingleton
class OfflineLocalDataSource {
  OfflineLocalDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<String> downloadAndSave(Track track) async {
    final trackUrl = track.trackUrl;
    if (trackUrl == null || trackUrl.isEmpty) {
      throw Exception('Track URL is missing');
    }

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    // Save as data format without mp3 extension to prevent easy external access
    final savePath = '${directory.path}/tracks/track_${track.id}.dat';

    final file = File(savePath);
    if (await file.exists()) {
      return savePath; // Already downloaded
    }

    // Ensure directory exists
    await file.parent.create(recursive: true);

    // Save Metadata
    final metaPath = '${directory.path}/tracks/track_${track.id}.json';
    final metaFile = File(metaPath);
    if (!await metaFile.exists()) {
      // Modify URL of saved metadata so that `TrackModel` points to the local path.
      final localizedModel = TrackModelX.fromEntity(
        track,
      ).copyWith(trackUrl: savePath);
      await metaFile.writeAsString(jsonEncode(localizedModel.toJson()));
    }

    try {
      await _dioClient.download(
        trackUrl,
        savePath,
        options: Options(
          // Important: track url might contain redirects or require specific headers
          followRedirects: true,
        ),
      );
      return savePath;
    } catch (e) {
      // If download fails, delete the partial file
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }

  Future<List<Track>> getOfflineTracks() async {
    final directory = await getApplicationDocumentsDirectory();
    final tracksDir = Directory('${directory.path}/tracks');
    if (!await tracksDir.exists()) {
      return [];
    }

    final List<Track> tracks = [];
    final entities = tracksDir.listSync();

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final content = await entity.readAsString();
          final trackModel = TrackModel.fromJsonString(content);
          // Verify that the companion .dat file also exists before returning it
          final dataFile = File(entity.path.replaceAll('.json', '.dat'));
          if (await dataFile.exists()) {
            tracks.add(trackModel.toEntity());
          }
        } catch (e) {
          debugPrint('Failed to load JSON for $entity: $e');
        }
      }
    }

    // Sort by id descending
    tracks.sort((a, b) => b.id.compareTo(a.id));
    return tracks;
  }
}
