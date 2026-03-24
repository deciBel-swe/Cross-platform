/// Reusable list tile for Library items (playlists, albums, liked tracks).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single library item row — cover art, title, subtitle, and trailing action.
class LibraryListTile extends StatefulWidget {
  const LibraryListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradientColors,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final List<Color>? gradientColors;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  State<LibraryListTile> createState() => _LibraryListTileState();
}

class _LibraryListTileState extends State<LibraryListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [AppColors.surfaceLight, AppColors.surfaceContainer];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMd,
            vertical: AppDimensions.paddingSm,
          ),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.surfaceLight : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              // Cover art
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white38,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMd),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.cardSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
