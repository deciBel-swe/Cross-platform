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

/// Screen-level suppression for immersive mobile experiences such as Discover.
/// This is separate from [miniPlayerVisibleProvider], which is used by sheets.
final mobileMiniPlayerSuppressedProvider = StateProvider<bool>((ref) => false);
