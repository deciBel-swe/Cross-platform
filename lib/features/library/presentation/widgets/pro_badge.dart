import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// A beautifully crafted Artist Pro badge matching the provided design specs.
class ProBadge extends StatelessWidget {
  const ProBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.badgePaddingHorizontal,
        vertical: AppConstants.badgePaddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _GoldScallopedStar(),
          SizedBox(width: AppConstants.badgeGapIconToText),
          Text(
            'PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppConstants.badgeFontSize,
              letterSpacing: AppConstants.badgeLetterSpacing,
            ),
          ),
          SizedBox(width: AppConstants.badgeTrailingBuffer),
        ],
      ),
    );
  }
}

/// The custom golden seal with the star cutout.
class _GoldScallopedStar extends StatelessWidget {
  const _GoldScallopedStar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.badgeSealSize,
      height: AppConstants.badgeSealSize,
      child: CustomPaint(
        painter: _ScallopedBadgePainter(
          badgeColor: AppColors.proBadge,
        ),
        child: Center(
          // Optical Nudge applied here
          child: Transform.translate(
            offset: const Offset(0, AppConstants.badgeIconNudgeY),
            child: const Icon(
              Icons.star_rounded,
              color: AppColors.borderDark,
              size: AppConstants.badgeIconSize,
            ),
          ),
        ),
      ),
    );
  }
}

/// A CustomPainter that draws a scalloped seal (rosette).
class _ScallopedBadgePainter extends CustomPainter {
  _ScallopedBadgePainter({required this.badgeColor});
  
  final Color badgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = badgeColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * AppConstants.badgeInnerRadiusRatio; 

    final path = Path();
    const angleStep = (math.pi * 2) / (AppConstants.badgeSealPoints * 2);

    for (int i = 0; i < AppConstants.badgeSealPoints * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * angleStep) - (math.pi / 2);

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ScallopedBadgePainter oldDelegate) {
    return oldDelegate.badgeColor != badgeColor;
  }
}