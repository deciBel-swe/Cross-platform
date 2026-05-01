import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';


import '../../../../core/network/dio_client.dart';
import '../../../library/data/datasources/library_remote_datasource.dart';
import '../../../library/data/models/track_model.dart';
import '../../../library/data/models/track_peaks_model.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library/domain/entities/track_peaks.dart';

/// Lightweight metadata saved alongside a downloaded playlist or station.
class OfflineCollectionInfo {
  const OfflineCollectionInfo({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.trackIds,
    this.isStation = false,
  });

  factory OfflineCollectionInfo.fromJson(Map<String, dynamic> json) {
    return OfflineCollectionInfo(
      id: json['id'] as int,
      title: json['title'] as String,
      coverUrl: json['coverUrl'] as String?,
      trackIds:
          (json['trackIds'] as List<dynamic>).map((e) => e as int).toList(),
      isStation: json['isStation'] as bool? ?? false,
    );
  }

  final int id;
  final String title;
  final String? coverUrl;
  final List<int> trackIds;
  final bool isStation;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverUrl': coverUrl,
        'trackIds': trackIds,
        'isStation': isStation,
      };

  OfflineCollectionInfo copyWith({
    int? id,
    String? title,
    String? coverUrl,
    List<int>? trackIds,
    bool? isStation,
  }) {
    return OfflineCollectionInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      trackIds: trackIds ?? this.trackIds,
      isStation: isStation ?? this.isStation,
    );
  }
}

@lazySingleton
class OfflineLocalDataSource {
  OfflineLocalDataSource(this._dioClient, this._libraryRemoteDatasource);

  final DioClient _dioClient;
  final LibraryRemoteDatasource _libraryRemoteDatasource;

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
      final localizedModel = TrackModelX.fromEntity(track).copyWith(trackUrl: savePath);
      await metaFile.writeAsString(jsonEncode(localizedModel.toJson()));
    }

    // Fetch and save peaks
    try {
      final peaksModel = await _libraryRemoteDatasource.fetchTrackPeaks(
        track.id,
        waveformUrl: track.waveformUrl,
      );
      final peaksPath = '${directory.path}/tracks/peaks_${track.id}.json';
      final peaksFile = File(peaksPath);
      await peaksFile.writeAsString(jsonEncode(peaksModel.toJson()));
    } catch (e) {
      debugPrint('Failed to download peaks for track ${track.id}: $e');
      // Non-fatal, we continue to download the audio
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
      if (entity is File && entity.path.endsWith('.json') && !entity.path.contains('peaks_')) {
        try {
          final content = await entity.readAsString();
          final trackModel = TrackModel.fromJsonString(content);
          // Verify that the companion .dat file also exists before returning it
          final dataFile = File(entity.path.replaceAll('.json', '.dat'));
          if (await dataFile.exists()) {
            tracks.add(trackModel.toEntity());
          }
        } catch (e) {
      // Ignore wrapper exception
    }
      }
    }

    // Sort by id descending
    tracks.sort((a, b) => b.id.compareTo(a.id));
    return tracks;
  }

  Future<Track?> getOfflineTrackById(int id) async {
    final directory = await getApplicationDocumentsDirectory();
    final metaPath = '${directory.path}/tracks/track_$id.json';
    final metaFile = File(metaPath);
    
    if (await metaFile.exists()) {
      try {
        final content = await metaFile.readAsString();
        final trackModel = TrackModel.fromJsonString(content);
        
        final dataFile = File(metaPath.replaceAll('.json', '.dat'));
        if (await dataFile.exists()) {
          return trackModel.toEntity();
        }
      } catch (e) {
        debugPrint('Failed to load JSON for $metaPath: $e');
      }
    }
    return null;
  }

  Future<TrackPeaks?> getOfflineTrackPeaksById(int id) async {
    final directory = await getApplicationDocumentsDirectory();
    final peaksPath = '${directory.path}/tracks/peaks_$id.json';
    final peaksFile = File(peaksPath);
    
    if (await peaksFile.exists()) {
      try {
        final content = await peaksFile.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(content) as Map<String, dynamic>;
        final peaksModel = TrackPeaksModel.fromJson(jsonMap);
        return peaksModel.toEntity();
      } catch (e) {
        debugPrint('Failed to load peaks JSON for $peaksPath: $e');
      }
    }
    return null;
  }

  // ── Collection (playlist / station) metadata ─────────────────────────────

  Future<String> _collectionsDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/collections';
    await Directory(path).create(recursive: true);
    return path;
  }

  /// Persists [info] so the Downloads screen can reconstruct the playlist view.
  Future<void> saveCollectionMetadata(OfflineCollectionInfo info) async {
    final dir = await _collectionsDir();
    final file = File('$dir/collection_${info.id}.json');
    await file.writeAsString(jsonEncode(info.toJson()));
  }

  /// Returns all saved [OfflineCollectionInfo] objects, only including those
  /// whose track IDs have at least one corresponding downloaded `.dat` file.
  Future<List<OfflineCollectionInfo>> getOfflineCollections() async {
    final dir = await _collectionsDir();
    final docsDir = await getApplicationDocumentsDirectory();
    final results = <OfflineCollectionInfo>[];

    for (final entity in Directory(dir).listSync()) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final raw = jsonDecode(await entity.readAsString())
              as Map<String, dynamic>;
          final info = OfflineCollectionInfo.fromJson(raw);

          // Keep only collections that have at least one downloaded track.
          final hasAnyTrack = info.trackIds.any((id) =>
              File('${docsDir.path}/tracks/track_$id.dat').existsSync());
          if (hasAnyTrack) {
            results.add(info);
          }
        } catch (e) {
          debugPrint('Failed to read collection metadata ${entity.path}: $e');
        }
      }
    }

    return results;
  }

  /// Deletes the collection metadata for [id]. Individual track files are
  /// not removed — call [clearAll] or delete tracks individually.
  Future<void> deleteCollectionMetadata(int id) async {
    final dir = await _collectionsDir();
    final file = File('$dir/collection_$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Updates the collection metadata for [id] with new [info].
  Future<void> updateCollectionMetadata(OfflineCollectionInfo info) async {
    final dir = await _collectionsDir();
    final file = File('$dir/collection_${info.id}.json');
    await file.writeAsString(jsonEncode(info.toJson()));
  }

  /// Removes a track with [trackId] from the collection with [collectionId].
  Future<void> removeTrackFromCollection(int collectionId, int trackId) async {
    final dir = await _collectionsDir();
    final file = File('$dir/collection_$collectionId.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final jsonMap = jsonDecode(content) as Map<String, dynamic>;
      final info = OfflineCollectionInfo.fromJson(jsonMap);
      final updatedTrackIds = info.trackIds.where((id) => id != trackId).toList();
      final updatedInfo = info.copyWith(trackIds: updatedTrackIds);
      await file.writeAsString(jsonEncode(updatedInfo.toJson()));
    }
  }

  Future<void> clearAll() async {
    final directory = await getApplicationDocumentsDirectory();
    final tracksDir = Directory('${directory.path}/tracks');
    if (await tracksDir.exists()) {
      await tracksDir.delete(recursive: true);
    }
    final collectionsDir = Directory('${directory.path}/collections');
    if (await collectionsDir.exists()) {
      await collectionsDir.delete(recursive: true);
    }
  }
}
