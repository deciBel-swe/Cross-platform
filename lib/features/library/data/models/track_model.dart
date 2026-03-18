import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    required String trackUrl,
    String? coverUrl,
    String? waveformUrl,
    required String genre,
    @Default(<String>[]) List<String> tags,
    required TrackStatusModel state,
    required DateTime releaseDate,
    @Default(0) int playCount,
    @Default(0) int likeCount,
    @Default(0) int repostCount,
    required DateTime createdAt,
  }) = _TrackModel;

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  factory TrackModel.fromJsonString(String jsonString) =>
      TrackModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
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
      createdAt: createdAt,
    );
  }
}
