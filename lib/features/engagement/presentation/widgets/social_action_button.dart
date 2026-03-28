import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class SocialActionButton extends StatefulWidget {
  const SocialActionButton({
    super.key,
    required this.isActive,
    required this.count,
    required this.isLoading,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.activeColor,
    required this.onToggle,
    this.iconSize = AppConstants.iconSizeMedium,
    this.fontSize = AppConstants.fontSizeRegular,
  });
  final bool isActive;
  final int count;
  final bool isLoading;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final VoidCallback onToggle;
  final double iconSize;
  final double fontSize;

  @override
  State<SocialActionButton> createState() => _SocialActionButtonState();
}

class _SocialActionButtonState extends State<SocialActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Icon(
                widget.isActive ? widget.activeIcon : widget.inactiveIcon,
                key: ValueKey<bool>(widget.isActive),
                color: widget.isActive
                    ? widget.activeColor
                    : AppColors.onPrimary,
                size: widget.iconSize,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '${widget.count}',
              key: ValueKey<int>(widget.count),
              style: TextStyle(
                color: widget.isLoading
                    ? AppColors.primary
                    : AppColors.onPrimary,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
