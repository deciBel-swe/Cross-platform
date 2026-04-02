import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

@freezed
class Track with _$Track {
  const factory Track({
    required int id,
    required String title,
    required String artistName,
    String? coverUrl,
    @Default(0) int playCount,
    @Default(0) int likeCount,
    @Default(Duration.zero) Duration duration,
  }) = _Track;
}
