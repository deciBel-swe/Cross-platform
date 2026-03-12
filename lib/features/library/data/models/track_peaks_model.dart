import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_peaks_model.freezed.dart';
part 'track_peaks_model.g.dart';

@freezed
class TrackPeaksModel with _$TrackPeaksModel {
  const factory TrackPeaksModel({
    required int trackId,
    required int duration,
    @Default(<int>[]) List<int> peaks,
  }) = _TrackPeaksModel;

  factory TrackPeaksModel.fromJson(Map<String, dynamic> json) =>
      _$TrackPeaksModelFromJson(json);
}
