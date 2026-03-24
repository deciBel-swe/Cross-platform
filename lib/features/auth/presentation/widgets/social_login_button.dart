/// Full-width social login button with a leading icon and label.
///
/// Used on the start, login, and register screens for OAuth providers.
library;

import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    this.isLoading = false,
    this.onPressed,
  });

  /// Display text, e.g. "Continue with Google".
  final String label;

  /// Leading icon widget.
  final Widget icon;

  /// Tap callback; `null` disables the button.
  final VoidCallback? onPressed;

  /// Whether the button is currently in a loading state.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else ...[
              SizedBox(width: 24, height: 24, child: icon),
              const SizedBox(width: 12),
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ],
        ),
      ),
    );
  }
}
