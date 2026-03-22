import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/track_status.dart';

part 'track_status_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum TrackStatusModel {
  @JsonValue('PROCESSING')
  processing,

  @JsonValue('FINISHED')
  finished,
}

extension TrackStatusModelX on TrackStatusModel {
  TrackStatus toEntity() {
    switch (this) {
      case TrackStatusModel.processing:
        return TrackStatus.processing;
      case TrackStatusModel.finished:
        return TrackStatus.finished;
    }
  }
}
