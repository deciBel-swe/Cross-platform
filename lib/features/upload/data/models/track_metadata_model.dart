import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/track_upload_metadata.dart';

part 'track_metadata_model.freezed.dart';
part 'track_metadata_model.g.dart';

// DTO for sending metadata of the track to the backend
@freezed
class TrackMetadataModel with _$TrackMetadataModel {
  const factory TrackMetadataModel({
    required String title,
    required String genre,
    required bool isPrivate,
    String? description,
    String? releasedDate,
    List<String>? tags,
  }) = _TrackMetadataModel;

  factory TrackMetadataModel.fromJson(Map<String, dynamic> json) =>
    _$TrackMetadataModelFromJson(json);
}

extension TrackUploadMetadataX on TrackUploadMetadata {
  TrackMetadataModel toModel() => TrackMetadataModel(
        title: title,
        genre: genre,
        isPrivate: isPrivate,
        
        description: description.isEmpty? null : description,
        releasedDate: releasedDate?.toIso8601String(),
        tags: tags.isEmpty? null : tags,
      );
}