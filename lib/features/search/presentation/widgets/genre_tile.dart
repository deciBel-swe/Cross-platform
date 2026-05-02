/// Colored genre tile for the search browse grid.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A colored tile displaying a genre/mood name.
class GenreTile extends StatefulWidget {
  const GenreTile({
    super.key,
    required this.label,
    required this.gradientColors,
    this.onTap,
  });

  final String label;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  @override
  State<GenreTile> createState() => _GenreTileState();
}

class _GenreTileState extends State<GenreTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: AppDimensions.genreTileHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradientColors,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            child: Text(
              widget.label,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
