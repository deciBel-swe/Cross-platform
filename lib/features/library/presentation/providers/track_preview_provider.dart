import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track.dart';
import '../../domain/entities/track_peaks.dart';
import '../notifiers/track_preview_notifier.dart';

typedef TrackPreviewData = ({Track track, TrackPeaks? trackPeaks});

final selectedTrackIdProvider = StateProvider<int?>((ref) => null);

final trackPreviewProvider =
    AsyncNotifierProvider<TrackPreviewNotifier, TrackPreviewData>(
      TrackPreviewNotifier.new,
    );
