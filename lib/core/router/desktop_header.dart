/// Desktop top header bar with search, upload, notifications, and avatar.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// Top header bar rendered above the content area on desktop.
class DesktopHeader extends StatelessWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // ---- Search field ----
          const Expanded(child: _SearchField()),

          const SizedBox(width: AppDimensions.paddingMd),

          // ---- Upload button ----
          _HeaderIconButton(
            icon: Icons.upload_outlined,
            tooltip: 'Upload',
            onPressed: () {},
          ),

          const SizedBox(width: AppDimensions.paddingXs),

          // ---- Notifications ----
          _HeaderIconButton(
            icon: Icons.notifications_none,
            tooltip: 'Notifications',
            onPressed: () {},
          ),

          const SizedBox(width: AppDimensions.paddingSm),

          // ---- User avatar ----
          const _UserAvatar(),
        ],
      ),
    );
  }
}

/// Styled search input field.
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: SizedBox(
        height: 36,
        child: TextField(
          style: const TextStyle(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for artists, tracks, albums...',
            hintStyle: TextStyle(fontSize: 13, color: Colors.white38),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: Colors.white38,
            ),
            filled: true,
            fillColor: AppColors.surfaceLight,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon button used in the header bar.
class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.surfaceLight : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(
              widget.icon,
              size: 22,
              color: _isHovered ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder circular user avatar.
class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.surfaceLight,
      child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
    );
  }
}
