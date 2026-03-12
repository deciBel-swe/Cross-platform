import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum TrackStatusModel {
  @JsonValue('PROCESSING')
  processing,

  @JsonValue('FINISHED')
  finished,

  @JsonValue('FAILED')
  failed,
}
