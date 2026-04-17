import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/models/track_action_data.dart';
import '../../domain/repositories/track_social_repository.dart';
import '../notifiers/track_action_notifier.dart';

/// Bridges [ITrackSocialRepository] from GetIt into Riverpod.
final trackSocialRepositoryProvider = Provider<ITrackSocialRepository>(
  (ref) => getIt<ITrackSocialRepository>(),
);

/// Global provider for track like/repost state across the entire app.
///
/// All [LikeButton], [RepostButton], and [TrackTile] widgets watch this family
/// provider to ensure consistent engagement state. It is proactive and syncs
/// with the server in the background.
final trackSocialProvider =
    AsyncNotifierProvider.family<TrackSocialNotifier, TrackSocialData, int>(
      TrackSocialNotifier.new,
    );
