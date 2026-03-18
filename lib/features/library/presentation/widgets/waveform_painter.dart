import 'package:flutter/material.dart';

/// Paints a mirrored waveform around the horizontal center line.
/// Played part is orange, unplayed part is light grey.
class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.peaks,
    required this.progress,
    required this.playedColor,
    required this.unplayedColor,
    required this.centerLineColor,
  });

  final List<double> peaks;
  final double progress;
  final Color playedColor;
  final Color unplayedColor;
  final Color centerLineColor;

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

    final centerLinePaint = Paint()
      ..color = centerLineColor
      ..strokeWidth = 1;

    final centerY = size.height / 2;
    final halfAvailableHeight = size.height / 2;

    final barSlotWidth = size.width / peaks.length;
    final barWidth = barSlotWidth * 0.62;
    final playedBars = (peaks.length * progress).floor();

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

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        index < playedBars ? playedPaint : unplayedPaint,
      );
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
