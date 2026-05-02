import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../library/data/models/track_model.dart';
import 'owner_model.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

class PlaylistTracksConverter
    implements JsonConverter<List<TrackModel>, dynamic> {
  const PlaylistTracksConverter();

  @override
  List<TrackModel> fromJson(Object? json) {
    if (json == null) return [];

    List<dynamic> list = [];
    if (json is Map) {
      if (json.containsKey('content')) {
        list = json['content'] as List<dynamic>? ?? [];
      } else if (json.containsKey('trackSummary')) {
        list = json['trackSummary'] as List<dynamic>? ?? [];
      } else if (json.containsKey('trackSummaryDto')) {
        list = json['trackSummaryDto'] as List<dynamic>? ?? [];
      }
    } else if (json is List) {
      list = json;
    }

    return list
        .where((e) => e != null)
        .map((e) => TrackModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  dynamic toJson(List<TrackModel> object) =>
      object.map((e) => e.toJson()).toList();
}

@freezed
class PlaylistModel with _$PlaylistModel {
  const factory PlaylistModel({
    required int id,
    required String title,
    String? description,
    required String type,
    @Default(false) bool isPrivate,
    @Default(false) bool isLiked,
    @Default(false) bool isReposted,
    @JsonKey(name: 'coverArtUrl') String? coverArt,
    OwnerModel? owner,
    @JsonKey(name: 'trackSummaryDto')
    @PlaylistTracksConverter()
    @Default([])
    List<TrackModel> tracks,
    @Default(0) int totalDurationSeconds,
    @Default(0) int trackCount,
    String? playlistSlug,
    String? firstTrackWaveformUrl,
    String? secretToken,
    String? access,
    List<String>? genres,
    DateTime? createdAt,
  }) = _PlaylistModel;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(_normalizePlaylistJson(json));

  static Map<String, dynamic> _normalizePlaylistJson(
    Map<String, dynamic> json,
  ) {
    final map = Map<String, dynamic>.from(json);

    if (map['trackSummaryDto'] == null) {
      final paginatedTracks = map['paginatedTrackResponse'];
      if (map['trackSummary'] != null) {
        map['trackSummaryDto'] = map['trackSummary'];
      } else if (paginatedTracks is Map<Object?, Object?>) {
        final content = paginatedTracks['content'];
        if (content != null) {
          map['trackSummaryDto'] = content;
        }
      }
    }

    return map;
  }
}
