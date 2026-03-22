import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/track.dart';

part 'track_dto.freezed.dart';
part 'track_dto.g.dart';

@freezed
class TrackDto with _$TrackDto {

  const factory TrackDto({
    required int id,
    required String title,
    required Map<String, dynamic> artist, 
    String? coverUrl,
    @Default(0) int playCount,
    @Default(0) int likeCount,
  }) = _TrackDto;
  const TrackDto._();

  factory TrackDto.fromJson(Map<String, dynamic> json) => _$TrackDtoFromJson(json);

  // Maps the DTO to the Domain Entity
  Track toEntity() {
    return Track(
      id: id,
      title: title,
      artistName: artist['username'] as String? ?? 'Unknown Artist',
      coverUrl: coverUrl,
      playCount: playCount,
      likeCount: likeCount,
      duration: const Duration(minutes: 3, seconds: 45), // Placeholder
    );
  }
}