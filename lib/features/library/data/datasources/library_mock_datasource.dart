import '../models/paginated_tracks_model.dart';
import '../models/track_model.dart';
import '../models/track_peaks_model.dart';
import 'library_mock_fixtures.dart';

class LibraryMockDatasource {
  const LibraryMockDatasource();

  Future<TrackModel> fetchTrackById(int id) async {
    await Future.delayed(LibraryMockFixtures.mockDelay);

    final data = LibraryMockFixtures.trackMetaDataById[id];

    if (data == null) {
      throw Exception('Track not found');
    }

    return TrackModel.fromJson(data);
  }

  Future<PaginatedTracksModel> fetchTracks({
    required int page,
    required int size,
  }) async {
    await Future.delayed(LibraryMockFixtures.mockDelay);

    final allTracks =
        LibraryMockFixtures.mockTracksResponse['content'] as List<dynamic>;

    final startIndex = page * size;
    if (startIndex >= allTracks.length) {
      return PaginatedTracksModel.fromJson({
        'content': const [],
        'pageNumber': page,
        'pageSize': size,
        'totalElements': allTracks.length,
        'totalPages': (allTracks.length / size).ceil(),
        'isLast': true,
      });
    }

    final endIndex = (startIndex + size).clamp(0, allTracks.length);
    final pageItems = allTracks.sublist(startIndex, endIndex);

    final response = <String, dynamic>{
      'content': pageItems,
      'pageNumber': page,
      'pageSize': size,
      'totalElements': allTracks.length,
      'totalPages': (allTracks.length / size).ceil(),
      'isLast': endIndex >= allTracks.length,
    };

    return PaginatedTracksModel.fromJson(response);
  }

  Future<TrackPeaksModel> fetchTrackPeaks(int id) async {
    await Future.delayed(LibraryMockFixtures.mockDelay);

    final data = LibraryMockFixtures.trackPeaksById[id];

    if (data == null) {
      throw Exception('Track peaks not found');
    }

    return TrackPeaksModel.fromJson(data);
  }
}
