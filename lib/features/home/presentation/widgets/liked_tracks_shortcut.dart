import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';

const BorderRadius _likedTracksShortcutRadius = BorderRadius.all(
  Radius.circular(8),
);

class LikedTracksShortcut extends StatelessWidget {
  const LikedTracksShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: _likedTracksShortcutRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.push(RoutePaths.libraryLikes);
          },
          borderRadius: _likedTracksShortcutRadius,
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF431000),
                  Color(0xFF2A1E18),
                  Color(0xFF1E1E1E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: <double>[0, 0.55, 1],
              ),
              borderRadius: _likedTracksShortcutRadius,
            ),
            child: const SizedBox(
              height: 64,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -6,
                    top: 5,
                    bottom: 1,
                    child: CustomPaint(
                      size: Size(64, 58),
                      painter: _LikedHeartsPainter(),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(left: 58, right: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Your likes',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _ShuffleBadge(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShuffleBadge extends StatelessWidget {
  const _ShuffleBadge();

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      message: 'Shuffle',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0x75000000),
          shape: BoxShape.circle,
          border: Border.fromBorderSide(BorderSide(color: Color(0x0FFFFFFF))),
        ),
        child: SizedBox.square(
          dimension: 34,
          child: Icon(
            Icons.shuffle_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _LikedHeartsPainter extends CustomPainter {
  const _LikedHeartsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Setup the stroke paint for the outlines
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          1.5 // Slightly thicker to match the image
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path heart = _heartPath(size);

    // 2. Draw the trailing hearts first (indexes 5 down to 1)
    for (int index = 5; index >= 1; index -= 1) {
      final double alpha = 0.42 + ((5 - index) * 0.08);
      strokePaint.color = AppColors.primary.withValues(alpha: alpha);

      canvas.save();
      // Translating down and to the left
      canvas.translate(-index * 2, index * 3);
      canvas.drawPath(heart, strokePaint);
      canvas.restore();
    }

    // 3. Draw the top-most front heart
    // Fill it with a dark color to hide the strokes behind it
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      // Using a dark color that matches the right side of your container's gradient
      ..color = const Color(0xFF1E1E1E);

    canvas.drawPath(heart, fillPaint);

    // 4. Draw the bright outline for the front heart
    strokePaint.color = AppColors.primary;
    canvas.drawPath(heart, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _LikedHeartsPainter oldDelegate) => false;

  Path _heartPath(Size size) {
    final double width = size.width;
    final double height = size.height;

    return Path()
      ..moveTo(width * 0.52, height * 0.17)
      ..cubicTo(
        width * 0.44,
        height * 0.02,
        width * 0.19,
        height * 0.06,
        width * 0.17,
        height * 0.31,
      )
      ..cubicTo(
        width * 0.14,
        height * 0.52,
        width * 0.45,
        height * 0.69,
        width * 0.52,
        height * 0.91,
      )
      ..cubicTo(
        width * 0.6,
        height * 0.69,
        width * 0.91,
        height * 0.52,
        width * 0.87,
        height * 0.31,
      )
      ..cubicTo(
        width * 0.84,
        height * 0.06,
        width * 0.6,
        height * 0.02,
        width * 0.52,
        height * 0.17,
      );
  }
}
