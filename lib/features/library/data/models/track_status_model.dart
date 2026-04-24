import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/track_status.dart';

part 'track_status_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum TrackStatusModel {
  @JsonValue('PROCESSING')
  processing,

  @JsonValue('FINISHED')
  finished,

  @JsonValue('FAILED')
  failed,
}

extension TrackStatusModelX on TrackStatusModel {
  TrackStatus toEntity() {
    switch (this) {
      case TrackStatusModel.processing:
        return TrackStatus.processing;
      case TrackStatusModel.finished:
        return TrackStatus.finished;
      case TrackStatusModel.failed:
        return TrackStatus.failed;
    }
  }

  static TrackStatusModel fromEntity(TrackStatus status) {
    switch (status) {
      case TrackStatus.processing:
        return TrackStatusModel.processing;
      case TrackStatus.finished:
        return TrackStatusModel.finished;
      case TrackStatus.failed:
        return TrackStatusModel.failed;
    }
  }
}
