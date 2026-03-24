import 'package:flutter/material.dart';

/// Handles full-screen tap to play/pause.
/// Shows the center play icon only when paused.
/// Does not blur anything; blur is handled by the background widget.
class TrackPreviewPlaybackOverlay extends StatelessWidget {
  const TrackPreviewPlaybackOverlay({
    super.key,
    required this.child,
    required this.onToggle,
    this.showPlayIcon = false,
  });

  final Widget child;
  final VoidCallback onToggle;
  final bool showPlayIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,

          if (showPlayIcon)
            const IgnorePointer(child: Center(child: _CenterPlayButton())),
        ],
      ),
    );
  }
}

class _CenterPlayButton extends StatelessWidget {
  const _CenterPlayButton();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.45),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
      ),
    );
  }
}
