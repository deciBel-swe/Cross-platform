import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_playlist_request.freezed.dart';
part 'create_playlist_request.g.dart';

@freezed
class CreatePlaylistRequest with _$CreatePlaylistRequest {
  const factory CreatePlaylistRequest({
    required String title,
    String? description,
    @Default('PLAYLIST') String type,
    @Default(true) bool isPrivate,
  }) = _CreatePlaylistRequest;

  factory CreatePlaylistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePlaylistRequestFromJson(json);
}
