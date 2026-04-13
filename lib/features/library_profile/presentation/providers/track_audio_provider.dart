import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../library/presentation/notifiers/track_audio_notifier.dart';
import '../../../library/presentation/state/track_audio_state.dart';

final trackAudioProvider =
    NotifierProvider<TrackAudioNotifier, TrackAudioState>(
      TrackAudioNotifier.new,
    );

/// Set to `false` while any bottom sheet that would overlap the mini player is
/// open. The [MobileMiniPlayer] in [_MobileShell] respects this flag so it
/// slides out of sight until the sheet is dismissed.
final miniPlayerVisibleProvider = StateProvider<bool>((ref) => true);
