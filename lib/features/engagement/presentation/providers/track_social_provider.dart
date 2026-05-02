import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../notifiers/track_action_notifier.dart';
import '../states/track_social_state.dart';

/// Bridges [ITrackSocialRepository] from GetIt into Riverpod.
final trackSocialRepositoryProvider = Provider<ITrackSocialRepository>(
  (ref) => getIt<ITrackSocialRepository>(),
);

/// Global provider for track like/repost state across the entire app.
///
/// All [LikeButton] and [RepostButton] widgets watch this provider to ensure
/// consistent engagement state regardless of which screen the user is on.
final trackSocialProvider =
    NotifierProvider<TrackSocialNotifier, TrackSocialState>(
      () => TrackSocialNotifier(),
    );
