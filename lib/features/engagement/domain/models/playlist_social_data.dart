import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_social_data.freezed.dart';

@freezed
class PlaylistSocialData with _$PlaylistSocialData {
  const factory PlaylistSocialData({
    required bool isLiked,
    required bool isReposted,
  }) = _PlaylistSocialData;
}
