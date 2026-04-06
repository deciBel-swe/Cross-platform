import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/track_action_data.dart';

part 'track_social_state.freezed.dart';

@freezed
class TrackSocialState with _$TrackSocialState {
  const factory TrackSocialState({
    @Default({}) Map<String, TrackSocialData> trackStates,
    @Default({}) Set<String> loadingKeys,
  }) = _TrackSocialState;
}
