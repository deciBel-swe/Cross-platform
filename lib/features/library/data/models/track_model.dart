import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/track.dart';
import 'artist_model.dart';
import 'track_status_model.dart';

part 'track_model.freezed.dart';
part 'track_model.g.dart';

@freezed
class TrackModel with _$TrackModel {
  const factory TrackModel({
    required int id,
    required String title,
    required ArtistModel artist,
    String? trackUrl,
    String? coverUrl,
    String? waveformUrl,
    @Default('') String genre,
    @Default(<String>[]) List<String> tags,
    required TrackStatusModel state,
    required DateTime releaseDate,
    @Default(0) int playCount,
    @Default(0) int likeCount,
    @Default(0) int repostCount,
    @Default(false) bool isLiked,
    @Default(false) bool isReposted,
    required DateTime createdAt,
  }) = _TrackModel;

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(_normalizeTrackJson(json));

  factory TrackModel.fromJsonString(String jsonString) =>
      TrackModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  static Map<String, dynamic> _normalizeTrackJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    final normalizedTrackUrl = (map['trackUrl'] as String?)?.trim();
    final rawState = (map['state'] ?? map['status'])
        ?.toString()
        .trim()
        .toUpperCase();

    // Key mappings
    if (!map.containsKey('createdAt') && map.containsKey('uploadDate')) {
      map['createdAt'] = map['uploadDate'];
    }

    final fallbackDate = DateTime.fromMillisecondsSinceEpoch(
      0,
    ).toIso8601String();

    map['releaseDate'] ??=
        map['createdAt'] ?? map['uploadDate'] ?? fallbackDate;
    map['createdAt'] ??=
        map['releaseDate'] ?? map['uploadDate'] ?? fallbackDate;

    // Waveform fallback
    if (!map.containsKey('waveformUrl') || map['waveformUrl'] == null) {
      map['waveformUrl'] = map['trackPreviewUrl'];
    }

    // state handling
    map['state'] = switch (rawState) {
      'UPLOADING' || 'PROCESSING' => 'PROCESSING',
      'FAILED' => 'FAILED',
      'FINISHED' => 'FINISHED',
      _ =>
        (normalizedTrackUrl == null || normalizedTrackUrl.isEmpty)
            ? 'PROCESSING'
            : 'FINISHED',
    };

    return map;
  }
}

extension TrackModelX on TrackModel {
  Track toEntity() {
    return Track(
      id: id,
      title: title,
      artist: artist.toEntity(),
      trackUrl: trackUrl,
      coverUrl: coverUrl,
      waveformUrl: waveformUrl,
      genre: genre,
      tags: tags,
      state: state.toEntity(),
      releaseDate: releaseDate,
      playCount: playCount,
      likeCount: likeCount,
      repostCount: repostCount,
      isLiked: isLiked,
      isReposted: isReposted,
      createdAt: createdAt,
    );
  }

  static TrackModel fromEntity(Track track) {
    return TrackModel(
      id: track.id,
      title: track.title,
      artist: ArtistModelX.fromEntity(track.artist),
      trackUrl: track.trackUrl,
      coverUrl: track.coverUrl,
      waveformUrl: track.waveformUrl,
      genre: track.genre,
      tags: track.tags,
      state: TrackStatusModelX.fromEntity(track.state),
      releaseDate: track.releaseDate,
      playCount: track.playCount,
      likeCount: track.likeCount,
      repostCount: track.repostCount,
      isLiked: track.isLiked,
      isReposted: track.isReposted,
      createdAt: track.createdAt,
    );
  }
}
