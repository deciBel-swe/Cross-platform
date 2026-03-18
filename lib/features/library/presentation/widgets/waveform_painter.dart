import 'package:flutter/material.dart';

/// Paints a mirrored waveform around the horizontal center line.
/// Played part is orange, unplayed part is light grey.
class WaveformPainter extends CustomPainter {
  WaveformPainter({required this.peaks, required this.progress});

  final List<double> peaks;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (peaks.isEmpty) {
      return;
    }

    final playedPaint = Paint()
      ..color = const Color(0xFFFF7A00)
      ..style = PaintingStyle.fill;

    final unplayedPaint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..style = PaintingStyle.fill;

    final centerLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
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
