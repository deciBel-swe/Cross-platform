import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
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

  Future<PaginatedTracksModel> fetchMyTracks({
    required int page,
    required int size,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/me/tracks',
      queryParams: <String, Object?>{'page': page, 'size': size},
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    final normalizedData = _normalizePaginatedTracksPayload(data);

    return PaginatedTracksModel.fromJson(normalizedData);
  }

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

    final normalizedData = _normalizePaginatedTracksPayload(data);

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

  Future<int> resolveTrackIdentifier(String trackIdentifier) async {
    final trimmed = trackIdentifier.trim();
    if (trimmed.isEmpty) {
      throw Exception('Track identifier is empty');
    }

    final parsedId = int.tryParse(trimmed);
    if (parsedId != null) {
      return parsedId;
    }

    final encodedSlug = Uri.encodeComponent(trimmed);
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.resolveTrackBySlug(encodedSlug),
    );

    final payload = response.data;
    if (payload == null) {
      throw Exception('Empty track resolve response');
    }

    final body = payload['data'] is Map<String, dynamic>
        ? payload['data'] as Map<String, dynamic>
        : payload;

    final rawId = body['id'];
    final resolvedId = switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    if (resolvedId == null) {
      throw Exception('Invalid track resolve response payload');
    }

    return resolvedId;
  }

  Future<TrackModel> updateTrackMetadata({
    required int trackId,
    required String title,
    required String genre,
    required String description,
    required List<String> tags,
    required DateTime? releaseDate,
    required bool isPrivate,
    required String access,
    File? coverImage,
  }) async {
    final releaseDateValue = releaseDate?.toIso8601String().split('T').first;

    final patchMap = <String, dynamic>{
      'title': title,
      'genre': genre,
      'description': description,
      'tags': jsonEncode(tags),
      'isPrivate': isPrivate,
      'access': access,
      ...?releaseDateValue == null
          ? null
          : <String, dynamic>{'releaseDate': releaseDateValue},
    };

    final patchFormData = FormData.fromMap(patchMap);
    if (coverImage != null) {
      final imageName = coverImage.path.split('/').last;
      patchFormData.files.add(
        MapEntry(
          'coverImage',
          await MultipartFile.fromFile(coverImage.path, filename: imageName),
        ),
      );
    }

    try {
      final patchResponse = await _dioClient.patch<Map<String, dynamic>>(
        '/tracks/$trackId',
        data: patchFormData,
      );

      final patchData = patchResponse.data;
      if (patchData == null) {
        throw Exception('Empty update response');
      }

      return TrackModel.fromJson(_normalizeTrackJson(patchData));
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != 404 && statusCode != 405) {
        rethrow;
      }

      final putPayload = <String, dynamic>{
        'title': title,
        'genre': genre,
        'description': description,
        'tags': tags,
        'isPrivate': isPrivate,
        'access': access,
        ...?releaseDateValue == null
            ? null
            : <String, dynamic>{'releaseDate': releaseDateValue},
      };

      final putResponse = await _dioClient.put<Map<String, dynamic>>(
        '/tracks/$trackId',
        data: putPayload,
      );

      final putData = putResponse.data;
      if (putData == null) {
        throw Exception('Empty update response');
      }

      return TrackModel.fromJson(_normalizeTrackJson(putData));
    }
  }

  Future<void> deleteTrackCover(int trackId) async {
    await _dioClient.delete<dynamic>('/tracks/$trackId/cover');
  }

  Future<void> deleteTrack(int trackId) async {
    await _dioClient.delete<dynamic>('${ApiConstants.tracks}/$trackId');
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

  Future<TrackPeaksModel> fetchTrackPeaks(int id, {String? waveformUrl}) async {
    waveformUrl ??= await _resolveWaveformUrl(id);
    if (waveformUrl == null || waveformUrl.trim().isEmpty) {
      throw Exception('Empty waveformUrl');
    }

    final peaksResponse = await _dioClient.get<Object?>(waveformUrl);
    final peaksData = peaksResponse.data;
    if (peaksData == null) {
      throw Exception('Empty waveform payload');
    }
    final normalizedPayload = _normalizeTrackPeaksPayload(
      trackId: id,
      payload: peaksData,
    );

    if (normalizedPayload == null) {
      throw Exception('Invalid waveform payload');
    }

    return TrackPeaksModel.fromJson(normalizedPayload);
  }

  Future<String?> _resolveWaveformUrl(int id) async {
    try {
      final response = await _dioClient.get<Object?>(
        '/tracks/$id/waveform-url',
      );
      final data = response.data;
      final extracted = data == null ? null : _extractWaveformUrl(data);
      if (extracted != null && extracted.trim().isNotEmpty) {
        return extracted;
      }
    } catch (_) {}

    try {
      final track = await fetchTrackById(id);
      final fallback = track.waveformUrl;
      if (fallback != null && fallback.trim().isNotEmpty) {
        return fallback;
      }
    } catch (_) {
      // Ignore wrapper exception
    }

    return null;
  }

  Map<String, dynamic>? _normalizeTrackPeaksPayload({
    required int trackId,
    required Object payload,
  }) {
    if (payload is String) {
      final decoded = _tryDecodeJson(payload);
      if (decoded == null) return null;
      return _normalizeTrackPeaksPayload(trackId: trackId, payload: decoded);
    }

    if (payload is List) {
      final values = _extractNumericValues(payload);
      if (values.isEmpty) return null;

      return {
        'trackId': trackId,
        'duration': 0,
        'peaks': _toModelPeaks(values),
      };
    }

    if (payload is! Map<String, dynamic>) {
      return null;
    }

    final values = _extractPeaksValues(payload);
    if (values == null || values.isEmpty) {
      return null;
    }

    final normalizedTrackId = (payload['trackId'] as num?)?.toInt() ?? trackId;
    final normalizedDuration =
        (payload['duration'] as num?)?.toInt() ??
        (payload['durationSeconds'] as num?)?.toInt() ??
        0;

    return {
      'trackId': normalizedTrackId,
      'duration': normalizedDuration,
      'peaks': _toModelPeaks(values),
    };
  }

  List<double>? _extractPeaksValues(Map<String, dynamic> payload) {
    final directKeys = <String>['peaks', 'waveformData', 'waveform', 'samples'];
    for (final key in directKeys) {
      final value = payload[key];
      if (value is List) {
        final parsed = _extractNumericValues(value);
        if (parsed.isNotEmpty) return parsed;
      }
    }

    final nestedData = payload['data'];
    if (nestedData is List) {
      final parsed = _extractNumericValues(nestedData);
      if (parsed.isNotEmpty) return parsed;
    }

    return null;
  }

  List<double> _extractNumericValues(List<dynamic> source) {
    return source
        .whereType<num>()
        .map((value) => value.toDouble())
        .where((value) => value.isFinite)
        .toList(growable: false);
  }

  List<int> _toModelPeaks(List<double> source) {
    if (source.isEmpty) return const <int>[];

    final maxPeak = source.reduce((a, b) => a > b ? a : b);
    if (maxPeak <= 1.0) {
      // Preserve sub-1.0 detail because model currently stores integer peaks.
      return source
          .map((value) => (value * 1000).round())
          .toList(growable: false);
    }

    return source.map((value) => value.round()).toList(growable: false);
  }

  String? _extractWaveformUrl(Object? payload) {
    if (payload is String) {
      final trimmed = payload.trim();
      if (trimmed.isEmpty) return null;

      if (_looksLikeJson(trimmed)) {
        final decoded = _tryDecodeJson(trimmed);
        if (decoded == null) return null;
        return _extractWaveformUrl(decoded);
      }

      final unquoted = _stripWrappingQuotes(trimmed);
      if (unquoted.isNotEmpty) {
        return unquoted;
      }
      return null;
    }

    if (payload is Map<String, dynamic>) {
      final direct = payload['waveformUrl'] ?? payload['url'];
      if (direct is String && direct.trim().isNotEmpty) return direct;

      final nested = payload['data'];
      if (nested is Map<String, dynamic>) {
        final nestedUrl = nested['waveformUrl'] ?? nested['url'];
        if (nestedUrl is String && nestedUrl.trim().isNotEmpty) {
          return nestedUrl;
        }
      }
    }

    return null;
  }

  Object? _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return null;
    }
  }

  bool _looksLikeJson(String value) {
    if (value.isEmpty) return false;
    final first = value[0];
    return first == '[' || first == '{' || first == '"';
  }

  String _stripWrappingQuotes(String value) {
    if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1).trim();
    }
    return value;
  }

  String? _normalizeTrackStatus(Object? payload) {
    // Accept both raw-string and object status shapes from backend variants.
    final raw = switch (payload) {
      String value => value,
      Map<String, dynamic> map =>
        map['trackState']?.toString() ??
            map['status']?.toString() ??
            map['state']?.toString(),
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
    final responseData = meData == null ? null : meData['data'];
    final payload = responseData is Map<String, dynamic>
        ? responseData
        : meData;
    final profilePayload = payload == null ? null : payload['profile'];
    final profileMap = profilePayload is Map<String, dynamic>
        ? profilePayload
        : const <String, dynamic>{};

    final userId =
        (payload == null ? null : payload['id'] as num?)?.toInt() ??
        (profileMap['id'] as num?)?.toInt();
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
    final normalizedTrackUrl = (trackJson['trackUrl'] as String?)?.trim();
    final rawState = (trackJson['state'] ?? trackJson['status'])
        ?.toString()
        .toUpperCase();

    final normalizedState = switch (rawState) {
      'FAILED' => 'FAILED',
      'FINISHED' => 'FINISHED',
      'PROCESSING' || 'UPLOADING' => 'PROCESSING',
      _ =>
        (normalizedTrackUrl == null || normalizedTrackUrl.isEmpty)
            ? 'PROCESSING'
            : 'FINISHED',
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

  Map<String, dynamic> _normalizePaginatedTracksPayload(
    Map<String, dynamic> data,
  ) {
    final nestedData = data['data'];
    final source = nestedData is Map<String, dynamic> ? nestedData : data;
    final normalizedData = Map<String, dynamic>.from(source);
    final content = normalizedData['content'];

    if (content is List) {
      normalizedData['content'] = content
          .whereType<Map<String, dynamic>>()
          .map(_normalizeTrackJson)
          .toList();
    }

    normalizedData['pageNumber'] ??= normalizedData['number'] ?? 0;
    normalizedData['pageSize'] ??= normalizedData['size'] ?? 0;
    normalizedData['totalElements'] ??=
        (normalizedData['content'] as List?)?.length ?? 0;
    normalizedData['totalPages'] ??= 1;
    normalizedData['isLast'] ??= normalizedData['last'] ?? true;

    return normalizedData;
  }
}
