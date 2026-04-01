import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/follow_state_provider.dart';

/// A self-contained follow/unfollow button that globally syncs state.
class FollowButton extends ConsumerStatefulWidget {
  const FollowButton({
    super.key,
    required this.userId,
    required this.isFollowedBy,
  });

  final int userId;
  final bool isFollowedBy;

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final followAsync = ref.watch(followStateProvider(widget.userId));

    return followAsync.when(
      loading: () => _buildButton(
        label: '',
        isLoading: true,
        filled: false,
        onPressed: null,
      ),
      error: (_, _) => _buildButton(
        label: 'Follow',
        filled: false,
        onPressed: _handleTap,
      ),
      data: (isFollowing) {
        if (isFollowing) {
          return _buildFollowingButton();
        }
        return _buildNotFollowingButton();
      },
    );
  }

  Widget _buildNotFollowingButton() {
    final label = widget.isFollowedBy ? 'Follow Back' : 'Follow';
    return _buildButton(
      label: label,
      filled: false,
      onPressed: _handleTap,
    );
  }

  Widget _buildFollowingButton() {
    final showUnfollow = _isHovering || _isPressed;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: _buildButton(
          label: showUnfollow ? 'Unfollow' : 'Following',
          filled: true,
          isUnfollow: showUnfollow,
          onPressed: _handleTap,
        ),
      ),
    );
  }

  void _handleTap() {
    ref.read(followStateProvider(widget.userId).notifier).toggleFollow();
  }

  Widget _buildButton({
    required String label,
    required bool filled,
    bool isUnfollow = false,
    bool isLoading = false,
    VoidCallback? onPressed,
  }) {
    final Color backgroundColor;
    final Color foregroundColor;
    final Color borderColor;

    if (isUnfollow) {
      backgroundColor = Colors.red.withOpacity(0.15);
      foregroundColor = Colors.redAccent;
      borderColor = Colors.redAccent;
    } else if (filled) {
      backgroundColor = AppColors.primary;
      foregroundColor = AppColors.onPrimary;
      borderColor = AppColors.primary;
    } else {
      backgroundColor = (_isHovering || _isPressed)
          ? AppColors.onPrimary.withOpacity(0.05)
          : AppColors.transparent;
      foregroundColor = AppColors.onPrimary;
      borderColor = AppColors.borderLight;
    }

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
        ),
      ),
    );
  }
}
