import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../waveform_painter.dart';

class TrackWaveformCanvas extends StatelessWidget {
  const TrackWaveformCanvas({
    super.key,
    required this.peaks,
    required this.progress,
    this.dragProgress,
  });

  final List<double> peaks;
  final double progress;
  final double? dragProgress;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final darkerOrange =
        Color.lerp(primaryColor, AppColors.borderDark, 0.5) ?? primaryColor;

    final computedDragColor = (dragProgress != null && dragProgress! > progress)
        ? darkerOrange
        : Colors.grey;

    return CustomPaint(
      painter: WaveformPainter(
        peaks: peaks,
        progress: progress,
        dragProgress: dragProgress,
        playedColor: Theme.of(context).colorScheme.primary,
        dragColor: computedDragColor,
        unplayedColor: Theme.of(context).colorScheme.outlineVariant,
        centerLineColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
      ),
    );
  }
}
