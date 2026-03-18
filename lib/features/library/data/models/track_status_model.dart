import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/track_status.dart';

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
}
