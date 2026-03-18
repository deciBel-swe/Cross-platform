import 'package:flutter/material.dart';

class TrackWaveformCenterMarkers extends StatelessWidget {
  const TrackWaveformCenterMarkers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        _CenterProgressLine(),
        Positioned.fill(child: IgnorePointer(child: _CenterGuideLine())),
      ],
    );
  }
}

class _CenterProgressLine extends StatelessWidget {
  const _CenterProgressLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _CenterGuideLine extends StatelessWidget {
  const _CenterGuideLine();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1.4,
        margin: const EdgeInsets.symmetric(vertical: 18),
        color: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }
}
