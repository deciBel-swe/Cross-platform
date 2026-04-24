import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_response_model.freezed.dart';
part 'follow_response_model.g.dart';

/// DTO for the `FollowResponse` schema returned by:
/// - `POST /users/{userId}/follow`  (follow)
/// - `DELETE /users/{userId}/follow` (unfollow)
///
/// Contains the server-confirmed follow state after the operation.
@freezed
class FollowResponseModel with _$FollowResponseModel {
  const factory FollowResponseModel({
    /// Human-readable message from the server (e.g. "Followed successfully").
    required String message,

    /// Whether the current user is now following the target user.
    required bool isFollowing,
  }) = _FollowResponseModel;

  factory FollowResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FollowResponseModelFromJson(json);
}
