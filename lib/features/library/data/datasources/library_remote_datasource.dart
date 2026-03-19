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
      queryParams: <String, dynamic>{'page': page, 'size': size},
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
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/api/tracks/$id/peaks',
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }

    return TrackPeaksModel.fromJson(data);
  }
}
