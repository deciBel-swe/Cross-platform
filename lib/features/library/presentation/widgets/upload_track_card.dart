import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/track.dart';
import '../../domain/entities/track_status.dart';
import '../providers/track_audio_provider.dart';

class UploadTrackCard extends ConsumerWidget {
  const UploadTrackCard({super.key, required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isProcessing = track.state == TrackStatus.processing;
    final canPlay = !isProcessing;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CoverArt(url: track.coverUrl, isProcessing: isProcessing),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(state: track.state),
                  ],
                ),
              ),
              if (canPlay) _TrackPlayButton(track: track),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackPlayButton extends ConsumerWidget {
  const _TrackPlayButton({required this.track});

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
                trackUrl: track.trackUrl,
                autoPlay: true,
              );
            },
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({this.url, required this.isProcessing});

  final String? url;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        image: url != null && !isProcessing
            ? DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)
            : null,
      ),
      child: isProcessing
          ? const Center(child: CircularProgressIndicator())
          : (url == null ? const Icon(Icons.music_note) : null),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.state});

  final TrackStatus state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = state == TrackStatus.processing;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isProcessing
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isProcessing ? 'PROCESSING' : 'FINISHED',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isProcessing
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
