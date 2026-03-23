import 'package:injectable/injectable.dart';

import '../../../../core/constants/mock_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/paginated_tracks_model.dart';
import '../models/track_model.dart';
import '../models/track_peaks_model.dart';

/// Remote datasource for the Library feature.

/// NOTE: While backend is not ready, this datasource must not hit the network
/// when [MockConfig.useMockData] is true.
@lazySingleton
class LibraryRemoteDatasource {
  const LibraryRemoteDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<PaginatedTracksModel> fetchTracks({
    required int userId,
    required int page,
    required int size,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/api/users/$userId/tracks',
      queryParams: <String, Object?>{'page': page, 'size': size},
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    return PaginatedTracksModel.fromJson(data);
  }

  Future<TrackModel> fetchTrackById(int id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/api/tracks/$id',
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    return TrackModel.fromJson(data);
  }

  Future<TrackPeaksModel> fetchTrackPeaks(int id) async {
    final response = await _dioClient.get<Object?>(
      '/api/tracks/$id/waveform-url',
    );

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
}
