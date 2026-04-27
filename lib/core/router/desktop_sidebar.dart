/// SoundCloud-style desktop sidebar navigation.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Vertical sidebar rendered on desktop breakpoints.
///
/// Highlights the active route via [currentIndex] and calls [onTap]
/// when a navigation item is tapped.
class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.sidebarWidth,
      color: AppColors.surface,
      child: Column(
        children: [
          // ---- Logo ----
          const _SidebarLogo(),

          const SizedBox(height: AppDimensions.paddingMd),

          // ---- Primary nav ----
          _SidebarNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _SidebarNavItem(
            icon: Icons.dynamic_feed_outlined,
            activeIcon: Icons.dynamic_feed,
            label: 'Feed',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _SidebarNavItem(
            icon: Icons.search,
            activeIcon: Icons.search,
            label: 'Search',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _SidebarNavItem(
            icon: Icons.library_music_outlined,
            activeIcon: Icons.library_music,
            label: 'Library',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _SidebarNavItem(
            icon: Icons.mail_outline,
            activeIcon: Icons.mail,
            label: 'Messages',
            isSelected: currentIndex == 6,
            onTap: () => onTap(6),
          ),

          const Divider(
            color: AppColors.divider,
            height: 32,
            indent: AppDimensions.paddingMd,
            endIndent: AppDimensions.paddingMd,
          ),

          // ---- Secondary nav ----
          _SidebarNavItem(
            icon: Icons.upload_outlined,
            activeIcon: Icons.upload,
            label: 'Upload',
            isSelected: false,
            onTap: () {},
          ),

          const Spacer(),

          // ---- Upgrade ----
          _SidebarUpgradeItem(
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),

          const SizedBox(height: AppDimensions.paddingMd),
        ],
      ),
    );
  }
}

/// Decibel logo at the top of the sidebar.
class _SidebarLogo extends StatelessWidget {
  const _SidebarLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingLg,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icon/white_app_icon_trans.png',
            width: AppDimensions.sidebarLogoSize,
            height: AppDimensions.sidebarLogoSize,
          ),
          const SizedBox(width: AppDimensions.paddingSm),
          Text(
            'Decibel',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

/// A single sidebar navigation item with icon, label, and hover effect.
class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isSelected || _isHovered;
    final iconColor = widget.isSelected
        ? AppColors.primary
        : AppColors.textSecondary;
    final textColor = widget.isSelected
        ? Colors.white
        : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: 'Navigate to ${widget.label}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: AppDimensions.sidebarItemHeight,
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSm,
              vertical: 2,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSm,
            ),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.surfaceLight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected ? widget.activeIcon : widget.icon,
                  color: iconColor,
                  size: 22,
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                Text(
                  widget.label,
                  style: AppTextStyles.sidebarItem.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Upgrade item at the bottom of the sidebar with a gradient accent.
class _SidebarUpgradeItem extends StatefulWidget {
  const _SidebarUpgradeItem({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SidebarUpgradeItem> createState() => _SidebarUpgradeItemState();
}

class _SidebarUpgradeItemState extends State<_SidebarUpgradeItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: 'Navigate to Upgrade',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSm,
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingSm),
            decoration: BoxDecoration(
              gradient: (widget.isSelected || _isHovered)
                  ? const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  )
                  : null,
              color: (widget.isSelected || _isHovered)
                  ? null
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icon/white_app_icon_trans.png',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                Text(
                  'Upgrade',
                  style: AppTextStyles.sidebarItem.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
