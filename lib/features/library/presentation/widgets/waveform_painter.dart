import 'package:flutter/material.dart';

/// Paints a mirrored waveform around the horizontal center line.
/// Played part is orange, unplayed part is grey .
class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.peaks,
    required this.progress,
    this.dragProgress,
    required this.playedColor,
    required this.dragColor,
    required this.unplayedColor,
    required this.centerLineColor,
  });

  final List<double> peaks;
  final double progress;
  final double? dragProgress;
  final Color playedColor;
  final Color dragColor;
  final Color unplayedColor;
  final Color centerLineColor;

  static const double _completeThreshold = 0.9995;

  double _normalizeProgress(double value) {
    final clamped = value.clamp(0.0, 1.0);
    return clamped >= _completeThreshold ? 1.0 : clamped;
  }

  int _barsForProgress(double value) {
    final normalized = _normalizeProgress(value);
    final bars = (peaks.length * normalized).floor();
    return bars.clamp(0, peaks.length);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (peaks.isEmpty) {
      return;
    }

    final playedPaint = Paint()
      ..color = playedColor
      ..style = PaintingStyle.fill;

    final unplayedPaint = Paint()
      ..color = unplayedColor
      ..style = PaintingStyle.fill;

    final dragPaint = Paint()
      ..color = dragColor
      ..style = PaintingStyle.fill;

    final centerLinePaint = Paint()
      ..color = centerLineColor
      ..strokeWidth = 1;

    final centerY = size.height / 2;
    final halfAvailableHeight = size.height / 2;

    final barSlotWidth = size.width / peaks.length;
    final barWidth = barSlotWidth * 0.62;
    var playedBars = _barsForProgress(progress);
    final dragBars = dragProgress == null
        ? null
        : _barsForProgress(dragProgress!);

    final minBars = dragBars == null
        ? null
        : (playedBars < dragBars ? playedBars : dragBars);
    final maxBars = dragBars == null
        ? null
        : (playedBars > dragBars ? playedBars : dragBars);
    // Players rarely report a position exactly equal to duration due to
    // rounding and scheduling, which can leave the last bar uncolored.
    if (progress >= 0.999) {
      playedBars = peaks.length;
    }
    if (playedBars < 0) {
      playedBars = 0;
    } else if (playedBars > peaks.length) {
      playedBars = peaks.length;
    }

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      centerLinePaint,
    );

    for (int index = 0; index < peaks.length; index++) {
      final normalizedPeak = peaks[index].clamp(0.0, 1.0);

      final halfBarHeight = _minBarHeight(
        normalizedPeak * (halfAvailableHeight - 6),
      );

      final left = index * barSlotWidth + (barSlotWidth - barWidth) / 2;

      final rect = Rect.fromLTWH(
        left,
        centerY - halfBarHeight,
        barWidth,
        halfBarHeight * 2,
      );

      final radius = Radius.circular(barWidth);

      final Paint paint;
      if (dragBars == null) {
        paint = index < playedBars ? playedPaint : unplayedPaint;
      } else {
        if (index < minBars!) {
          paint = playedPaint;
        } else if (index < maxBars!) {
          paint = dragPaint;
        } else {
          paint = unplayedPaint;
        }
      }

      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }
  }

  double _minBarHeight(double value) {
    return value < 3 ? 3 : value;
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.peaks != peaks;
  }
}
