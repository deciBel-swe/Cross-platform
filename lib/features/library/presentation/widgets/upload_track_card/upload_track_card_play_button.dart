import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/track.dart';
import '../../providers/track_audio_provider.dart';

class UploadTrackCardPlayButton extends ConsumerWidget {
  const UploadTrackCardPlayButton({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);

    final isCurrentTrack = audioState.preparedTrackId == track.id;
    final isPreparingCurrent = audioState.isPreparing && isCurrentTrack;
    final isPlayingCurrent = audioState.isPlaying && isCurrentTrack;

    return IconButton(
      icon: Icon(
        isPreparingCurrent
            ? Icons.hourglass_top_rounded
            : (isPlayingCurrent
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled),
      ),
      color: theme.colorScheme.primary,
      iconSize: 36,
      onPressed: isPreparingCurrent
          ? null
          : () async {
              final trackUrl = track.trackUrl;
              if (trackUrl == null || trackUrl.isEmpty) {
                return;
              }

              if (isCurrentTrack) {
                if (audioState.isPlaying) {
                  await audioNotifier.pause();
                } else {
                  await audioNotifier.play();
                }
                return;
              }

              await audioNotifier.initializeForTrack(
                trackId: track.id,
                trackUrl: trackUrl,
                autoPlay: true,
              );
            },
    );
  }
}
