import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/paginated_tracks_model.dart';
import '../models/track_model.dart';
import '../models/track_peaks_model.dart';

/// Remote datasource for the Library feature.
@lazySingleton
class LibraryRemoteDatasource {
  LibraryRemoteDatasource(this._dioClient);

  final DioClient _dioClient;
  bool _supportsTrackByIdEndpoint = true;

  Future<PaginatedTracksModel> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/$userId/tracks',
      queryParams: <String, Object?>{'page': page, 'size': size},
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    final normalizedData = Map<String, dynamic>.from(data);
    final content = normalizedData['content'];
    if (content is List) {
      normalizedData['content'] = content
          .whereType<Map<String, dynamic>>()
          .map(_normalizeTrackJson)
          .toList();
    }

    return PaginatedTracksModel.fromJson(normalizedData);
  }

  Future<TrackModel> fetchTrackById(int id) async {
    // Some runtime environments do not support GET /tracks/{id}; use list fallback when known.
    if (!_supportsTrackByIdEndpoint) {
      return _fetchTrackByIdFallbackFromUserTracks(id);
    }

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/tracks/$id',
      );

      final data = response.data;
      if (data == null) {
        throw Exception('Empty response');
      }

      return TrackModel.fromJson(_normalizeTrackJson(data));
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 405) {
        // Cache unsupported route result to avoid repeated failing calls.
        _supportsTrackByIdEndpoint = false;
      }
      return _fetchTrackByIdFallbackFromUserTracks(id);
    }
  }

  Future<String> fetchTrackStatusById(int id) async {
    // Backend-driven processing state source used by uploads polling.
    final response = await _dioClient.get<Object?>('/tracks/$id/status');
    final normalized = _normalizeTrackStatus(response.data);
    if (normalized == null) {
      throw Exception('Invalid track status response');
    }
    return normalized;
  }

  Future<TrackPeaksModel> fetchTrackPeaks(int id) async {
    final response = await _dioClient.get<Object?>('/tracks/$id/waveform-url');

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    final waveformUrl = _extractWaveformUrl(data);
    if (waveformUrl == null || waveformUrl.trim().isEmpty) {
      throw Exception('Empty waveformUrl');
    }

    final peaksResponse = await _dioClient.get<Object?>(waveformUrl);
    final peaksData = peaksResponse.data;
    if (peaksData == null) {
      throw Exception('Empty waveform payload');
    }

    if (peaksData is! Map<String, dynamic>) {
      throw Exception('Invalid waveform payload');
    }

    return TrackPeaksModel.fromJson(peaksData);
  }

  String? _extractWaveformUrl(Object? payload) {
    if (payload is Map<String, dynamic>) {
      final url = payload['waveformUrl'];
      if (url is String && url.trim().isNotEmpty) return url;
    }

    return null;
  }

  String? _normalizeTrackStatus(Object? payload) {
    // Accept both raw-string and object status shapes from backend variants.
    final raw = switch (payload) {
      String value => value,
      Map<String, dynamic> map =>
        map['status']?.toString() ?? map['state']?.toString(),
      _ => null,
    };

    final normalized = raw?.trim().toUpperCase();
    return switch (normalized) {
      'UPLOADING' => 'UPLOADING',
      'PROCESSING' => 'PROCESSING',
      'FINISHED' => 'FINISHED',
      'FAILED' => 'FAILED',
      _ => null,
    };
  }

  Future<TrackModel> _fetchTrackByIdFallbackFromUserTracks(int trackId) async {
    final meResponse = await _dioClient.get<Map<String, dynamic>>('/users/me');
    final meData = meResponse.data;
    final userId = (meData?['id'] as num?)?.toInt();
    if (userId == null) {
      throw Exception('Unable to resolve current user id for track fallback');
    }

    final tracksResponse = await _dioClient.get<Map<String, dynamic>>(
      '/users/$userId/tracks',
      queryParams: <String, Object?>{'page': 0, 'size': 100},
    );

    final tracksData = tracksResponse.data;
    if (tracksData == null) {
      throw Exception('Empty tracks response in fallback');
    }

    final content = tracksData['content'];
    if (content is! List) {
      throw Exception('Invalid tracks content in fallback');
    }

    final trackJson = content.whereType<Map<String, dynamic>>().firstWhere(
      (item) => (item['id'] as num?)?.toInt() == trackId,
      orElse: () => <String, dynamic>{},
    );

    if (trackJson.isEmpty) {
      throw Exception('Track $trackId not found in fallback list');
    }

    final normalized = _normalizeTrackJson(trackJson, fallbackUserId: userId);

    return TrackModel.fromJson(normalized);
  }

  Map<String, dynamic> _normalizeTrackJson(
    Map<String, dynamic> trackJson, {
    int? fallbackUserId,
  }) {
    // Normalize payload differences so strict model parsing stays stable.
    final nowIso = DateTime.now().toIso8601String();
    final rawState = (trackJson['state'] ?? trackJson['status'])
        ?.toString()
        .toUpperCase();
    final waveformUrl = trackJson['waveformUrl'] as String?;
    final hasWaveformUrl = waveformUrl != null && waveformUrl.trim().isNotEmpty;

    final normalizedState = switch (rawState) {
      'FINISHED' => 'FINISHED',
      'PROCESSING' || 'UPLOADING' => 'PROCESSING',
      _ => hasWaveformUrl ? 'FINISHED' : 'PROCESSING',
    };

    final normalized = <String, dynamic>{
      ...trackJson,
      'state': normalizedState,
      'createdAt': trackJson['createdAt'] ?? trackJson['uploadDate'] ?? nowIso,
      'releaseDate': trackJson['releaseDate'] ?? nowIso,
      'tags': trackJson['tags'] ?? const <String>[],
      'genre': trackJson['genre'] ?? 'Unknown',
    };

    final artist = trackJson['artist'];
    if (artist is! Map<String, dynamic>) {
      normalized['artist'] = {'id': fallbackUserId ?? 0, 'username': 'Unknown'};
    }

    return normalized;
  }
}
