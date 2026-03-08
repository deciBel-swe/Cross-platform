/// Decibel start/welcome screen — first screen users see.
///
/// Presents branding, primary auth actions, social login options,
/// and legal links.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/social_login_button.dart';

/// Entry-point screen presenting branding, primary auth actions,
/// social login options, and legal links.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _LogoSection(),
              const Spacer(flex: 3),
              _AuthActions(
                onCreateAccount: () => context.go(RoutePaths.register),
                onSignIn: () => context.go(RoutePaths.login),
              ),
              const SizedBox(height: 28),
              const _OrDivider(),
              const SizedBox(height: 28),
              const _SocialLoginSection(),
              const Spacer(flex: 2),
              const _LegalFooter(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// App logo, name, and tagline.
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.whiteLogo,
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 20),
        Text(
          AppConstants.appName,
          style: theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Discover, stream, and share music',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Primary Create Account and Sign In buttons.
class _AuthActions extends StatelessWidget {
  const _AuthActions({
    required this.onCreateAccount,
    required this.onSignIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onCreateAccount,
          child: const Text('Create account'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onSignIn,
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}

/// Horizontal "or continue with" divider.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// Social login option buttons (Google, Facebook, Apple).
class _SocialLoginSection extends StatelessWidget {
  const _SocialLoginSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialLoginButton(
          label: 'Continue with Google',
          icon: const Icon(Icons.g_mobiledata, color: AppColors.google, size: 24),
          onPressed: () {
            // TODO(auth): implement Google sign-in
          },
        ),
        const SizedBox(height: 12),
        SocialLoginButton(
          label: 'Continue with Facebook',
          icon: const Icon(Icons.facebook, color: AppColors.facebook, size: 24),
          onPressed: () {
            // TODO(auth): implement Facebook sign-in
          },
        ),
        const SizedBox(height: 12),
        SocialLoginButton(
          label: 'Continue with Apple',
          icon: const Icon(Icons.apple, color: AppColors.apple, size: 24),
          onPressed: () {
            // TODO(auth): implement Apple sign-in
          },
        ),
      ],
    );
  }
}

/// Terms of Use and Privacy Policy footer text.
class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        style: theme.textTheme.bodySmall,
        children: const [
          TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
