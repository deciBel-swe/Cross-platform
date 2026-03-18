import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../../domain/repositories/track_repository.dart';
import '../notifiers/track_preview_notifier.dart';

final selectedTrackIdProvider = StateProvider<int?>((ref) => null);

final trackRepositoryProvider = Provider<TrackRepository>((ref) {
  return getIt<TrackRepository>();
});

final trackPreviewProvider =
    AsyncNotifierProvider<
      TrackPreviewNotifier,
      ({Track track, TrackPeaks? trackPeaks})
    >(TrackPreviewNotifier.new);
