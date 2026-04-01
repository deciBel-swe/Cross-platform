/// Desktop bottom player bar wired to global track audio state.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../library/domain/entities/track.dart';
import '../../../library_profile/presentation/providers/track_audio_provider.dart';
import '../../../library_profile/presentation/providers/uploads_provider.dart';

/// Desktop player bar rendered at the bottom of the desktop layout.
class DesktopPlayerBar extends ConsumerWidget {
  const DesktopPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(trackAudioProvider);
    final audioNotifier = ref.read(trackAudioProvider.notifier);
    final track = _resolveCurrentTrack(
      tracks: ref.watch(uploadsProvider).valueOrNull,
      trackId: audioState.preparedTrackId,
    );

    final displayedProgress = audioState.isDragging
        ? (audioState.dragProgress ?? audioState.progress)
        : audioState.progress;
    final displayedPosition = audioState.isDragging
        ? (audioState.dragPosition ?? audioState.position)
        : audioState.position;

    return Container(
      height: AppDimensions.playerBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _TrackInfo(
              title: track?.title ?? 'No track playing',
              artist:
                  track?.artist.username ??
                  (audioState.isPrepared
                      ? 'Selected track'
                      : 'Select a track to start listening'),
            ),
          ),
          Expanded(
            flex: 4,
            child: _PlaybackControls(
              isPrepared: audioState.isPrepared,
              isPlaying: audioState.isPlaying,
              progress: displayedProgress,
              position: displayedPosition,
              duration: audioState.duration,
              onPlayPausePressed: () async {
                if (!audioState.isPrepared) {
                  return;
                }
                if (audioState.isPlaying) {
                  await audioNotifier.pause();
                } else {
                  await audioNotifier.play();
                }
              },
              onSeekStart: (_) => audioNotifier.onDragStart(),
              onSeekChanged: audioNotifier.onDragUpdate,
              onSeekEnd: audioNotifier.onDragEnd,
            ),
          ),
          const Expanded(flex: 3, child: _VolumeControls()),
        ],
      ),
    );
  }
}

Track? _resolveCurrentTrack({
  required List<Track>? tracks,
  required int? trackId,
}) {
  if (tracks == null || trackId == null) {
    return null;
  }

  for (final track in tracks) {
    if (track.id == trackId) {
      return track;
    }
  }

  return null;
}

class _TrackInfo extends StatelessWidget {
  const _TrackInfo({required this.title, required this.artist});

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
          ),
          child: const Icon(Icons.music_note, color: Colors.white70, size: 24),
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.cardTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                artist,
                style: AppTextStyles.cardSubtitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSm),
        const Icon(
          Icons.favorite_border,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({
    required this.isPrepared,
    required this.isPlaying,
    required this.progress,
    required this.position,
    required this.duration,
    required this.onPlayPausePressed,
    required this.onSeekStart,
    required this.onSeekChanged,
    required this.onSeekEnd,
  });

  final bool isPrepared;
  final bool isPlaying;
  final double progress;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPausePressed;
  final ValueChanged<double> onSeekStart;
  final ValueChanged<double> onSeekChanged;
  final ValueChanged<double> onSeekEnd;

  @override
  Widget build(BuildContext context) {
    final sliderValue = progress.clamp(0.0, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _ControlButton(icon: Icons.shuffle, size: 18),
            const SizedBox(width: AppDimensions.paddingMd),
            const _ControlButton(icon: Icons.skip_previous, size: 24),
            const SizedBox(width: AppDimensions.paddingSm),
            GestureDetector(
              onTap: isPrepared ? onPlayPausePressed : null,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPrepared ? Colors.white : AppColors.surfaceVariant,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isPrepared ? AppColors.background : AppColors.textHint,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            const _ControlButton(icon: Icons.skip_next, size: 24),
            const SizedBox(width: AppDimensions.paddingMd),
            const _ControlButton(icon: Icons.repeat, size: 18),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              _formatDuration(position),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.surfaceLight,
                  thumbColor: AppColors.primary,
                ),
                child: Slider(
                  value: sliderValue,
                  onChangeStart: isPrepared ? onSeekStart : null,
                  onChanged: isPrepared ? onSeekChanged : null,
                  onChangeEnd: isPrepared ? onSeekEnd : null,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            Text(
              _formatDuration(duration),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VolumeControls extends StatelessWidget {
  const _VolumeControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const _ControlButton(icon: Icons.queue_music, size: 20),
        const SizedBox(width: AppDimensions.paddingSm),
        const Icon(Icons.volume_up, size: 20, color: AppColors.textSecondary),
        SizedBox(
          width: 100,
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 3,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
              activeTrackColor: Colors.white,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: Colors.white,
            ),
            child: Slider(value: 0.7, onChanged: (_) {}),
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Icon(
        widget.icon,
        size: widget.size,
        color: _isHovered ? Colors.white : AppColors.textSecondary,
      ),
    );
  }
}

String _formatDuration(Duration value) {
  final totalSeconds = value.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
