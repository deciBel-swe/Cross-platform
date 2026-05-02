import 'dart:math' as math;

import 'package:flutter/material.dart';

class AutoScrollingText extends StatefulWidget {
  const AutoScrollingText({
    super.key,
    required this.text,
    required this.style,
    this.gap = 40,
    this.pixelsPerSecond = 28,
  });

  final String text;
  final TextStyle style;
  final double gap;
  final double pixelsPerSecond;

  @override
  State<AutoScrollingText> createState() => _AutoScrollingTextState();
}

class _AutoScrollingTextState extends State<AutoScrollingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double? _lastDistance;
  Duration? _lastDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant AutoScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _lastDistance = null;
      _lastDuration = null;
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) {
          return Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          );
        }

        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout();

        final textWidth = textPainter.width;
        final availableWidth = constraints.maxWidth;
        final overflow = textWidth - availableWidth;
        if (overflow <= 0) {
          _controller.stop();
          return Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: widget.style,
          );
        }

        final distance = textWidth + widget.gap;
        final seconds = math.max(distance / widget.pixelsPerSecond, 4.0);
        final duration = Duration(
          milliseconds: (seconds * 1000).round(),
        );
        _startScrolling(distance: distance, duration: duration);

        return ClipRect(
          child: SizedBox(
            height: textPainter.height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-_controller.value * distance, 0),
                  child: child,
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: _MarqueeTextCopy(
                      text: widget.text,
                      width: textWidth,
                      style: widget.style,
                    ),
                  ),
                  Positioned(
                    left: textWidth + widget.gap,
                    top: 0,
                    child: _MarqueeTextCopy(
                      text: widget.text,
                      width: textWidth,
                      style: widget.style,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _startScrolling({
    required double distance,
    required Duration duration,
  }) {
    if (_controller.isAnimating &&
        _lastDistance == distance &&
        _lastDuration == duration) {
      return;
    }

    _lastDistance = distance;
    _lastDuration = duration;
    _controller
      ..stop()
      ..duration = duration
      ..value = 0
      ..repeat();
  }
}

class _MarqueeTextCopy extends StatelessWidget {
  const _MarqueeTextCopy({
    required this.text,
    required this.width,
    required this.style,
  });

  final String text;
  final double width;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.visible,
        softWrap: false,
        style: style,
      ),
    );
  }
}
