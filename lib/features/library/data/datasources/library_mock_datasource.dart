import 'package:decibel/features/library/data/datasources/library_mock_fixtures.dart';
import 'package:decibel/features/library/data/models/paginated_tracks_model.dart';
import 'package:decibel/features/library/data/models/track_model.dart';
import 'package:decibel/features/library/data/models/track_peaks_model.dart';

class LibraryMockDatasource {
  Future<TrackModel> fetchTrackById(int id) async {
    await Future.delayed(LibraryMockFixtures.mockDelay);

    final data = LibraryMockFixtures.trackMetaDataById[id];

    if (data == null) {
      throw Exception('Track not found');
    }

    return TrackModel.fromJson(data);
  }

  Future<PaginatedTracksModel> fetchTracks() async {
    await Future.delayed(LibraryMockFixtures.mockDelay);

    final data = LibraryMockFixtures.mockTracksResponse;

    final tracksJson = data;

    return PaginatedTracksModel.fromJson(tracksJson);
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
