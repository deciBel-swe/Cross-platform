import 'dart:convert';

import 'package:decibel/features/library/data/models/artist_model.dart';
import 'package:decibel/features/library/data/models/track_status_model.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
