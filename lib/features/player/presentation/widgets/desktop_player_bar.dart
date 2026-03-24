/// Desktop bottom player bar — UI only, no playback logic.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Static player bar rendered at the bottom of the desktop layout.
///
/// All controls are placeholder-only — no audio playback wired yet.
class DesktopPlayerBar extends StatelessWidget {
  const DesktopPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.playerBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg),
      child: const Row(
        children: [
          // ---- Track info (left) ----
          Expanded(flex: 3, child: _TrackInfo()),

          // ---- Playback controls (center) ----
          Expanded(flex: 4, child: _PlaybackControls()),

          // ---- Volume & extras (right) ----
          Expanded(flex: 3, child: _VolumeControls()),
        ],
      ),
    );
  }
}

/// Left section: cover art, track title, artist.
class _TrackInfo extends StatelessWidget {
  const _TrackInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Cover art placeholder
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
        const Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No track playing',
                style: AppTextStyles.cardTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 2),
              Text(
                'Select a track to start listening',
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

/// Center section: skip, play/pause, progress bar.
class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ---- Control buttons ----
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(icon: Icons.shuffle, size: 18, onPressed: () {}),
            const SizedBox(width: AppDimensions.paddingMd),
            _ControlButton(
              icon: Icons.skip_previous,
              size: 24,
              onPressed: () {},
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            // Play button (larger, filled)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.background,
                size: 22,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            _ControlButton(icon: Icons.skip_next, size: 24, onPressed: () {}),
            const SizedBox(width: AppDimensions.paddingMd),
            _ControlButton(icon: Icons.repeat, size: 18, onPressed: () {}),
          ],
        ),
        const SizedBox(height: 4),
        // ---- Progress bar ----
        Row(
          children: [
            Text(
              '0:00',
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
                child: Slider(value: 0, onChanged: (_) {}),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            Text(
              '0:00',
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

/// Right section: volume slider, queue, full screen.
class _VolumeControls extends StatelessWidget {
  const _VolumeControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _ControlButton(icon: Icons.queue_music, size: 20, onPressed: () {}),
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

/// Small icon button used for playback controls.
class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  final IconData icon;
  final double size;
  final VoidCallback onPressed;

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
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Icon(
          widget.icon,
          size: widget.size,
          color: _isHovered ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
