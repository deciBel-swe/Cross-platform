import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_action_data.freezed.dart';

@freezed
class TrackSocialData with _$TrackSocialData {
  const factory TrackSocialData({
    required bool isLiked,
    required int likeCount,
    required bool isReposted,
    required int repostCount,
  }) = _TrackSocialData;
}

// We also define an enum to make our Notifier methods reusable
enum SocialActionType { like, repost }
