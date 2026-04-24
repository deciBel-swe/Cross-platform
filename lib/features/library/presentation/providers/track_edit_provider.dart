import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/track_edit_notifier.dart';
import '../state/track_edit_state.dart';

final trackEditProvider = AsyncNotifierProvider.autoDispose
    .family<TrackEditNotifier, TrackEditState, int>(TrackEditNotifier.new);
