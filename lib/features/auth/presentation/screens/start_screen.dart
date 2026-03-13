/// Decibel start/welcome screen — first screen users see.
///
/// Responsive: background images always fill the screen via [BoxFit.cover].
/// The content (logo, tagline, buttons) is wrapped in [ResponsiveScaledBox]
/// so it scales uniformly from a fixed reference width.
/// Switches between a mobile artwork layout and a desktop artwork layout
/// at the 800 px breakpoint with a crossfade animation.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';

/// Entry-point screen presenting branding over layered artwork images
/// and primary auth actions on the orange panel.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  /// Width at which the layout switches from mobile stack to desktop panels.
  static const double _desktopBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          void goToRegister() => context.push(RoutePaths.register);
          void goToLogin() => context.push(RoutePaths.login);

          final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

          // AnimatedSwitcher crossfades between layouts
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: isDesktop
                ? _DesktopLayout(
                    key: const ValueKey('desktop'),
                    onCreateAccount: goToRegister,
                    onLogIn: goToLogin,
                  )
                : _MobileLayout(
                    key: const ValueKey('mobile'),
                    onCreateAccount: goToRegister,
                    onLogIn: goToLogin,
                  ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile layout — stacked artwork design
//
// Background images fill the entire screen (outside ResponsiveScaledBox).
// Only the content layer is wrapped in ResponsiveScaledBox for uniform scaling.

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    super.key,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  /// Reference width the mobile content is designed for.
  static const double _referenceWidth = 450;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: background artwork — always fills the entire screen
        Image.asset(AppAssets.startBg, fit: BoxFit.cover),

        // Layer 2: foreground orange panel — fills width, anchored to bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Image.asset(
            AppAssets.startFg,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Layer 3: content — scaled uniformly via ResponsiveScaledBox
        Positioned.fill(
          child: ResponsiveScaledBox(
            width: _referenceWidth,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
                      child: _BrandingPanel(
                        logoHeight: 65,
                        taglineFontSize: 30,
                        buttonFontSize: 16,
                        buttonTopSpacing: 55,
                        onCreateAccount: onCreateAccount,
                        onLogIn: onLogIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop layout
//
// Background images fill the entire screen (outside ResponsiveScaledBox).
// Only the content layer is wrapped in ResponsiveScaledBox for uniform scaling.

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    super.key,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  /// Reference width the desktop content is designed for.
  static const double _referenceWidth = 1200;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: background artwork — always fills the entire screen
        Image.asset(AppAssets.desktopStartBg, fit: BoxFit.cover),

        // Layer 2: foreground orange shape — fills width, anchored to bottom
        Positioned.fill(
          child: Image.asset(
            AppAssets.desktopStartFg,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Layer 3: content — scaled uniformly via ResponsiveScaledBox
        Positioned.fill(
          child: ResponsiveScaledBox(
            width: _referenceWidth,
            child: Stack(
              children: [
                Positioned(
                  left: -50,
                  right: 0,
                  bottom: 110,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _BrandingPanel(
                          logoHeight: 65,
                          taglineFontSize: 24,
                          buttonFontSize: 14,
                          buttonTopSpacing: 75,
                          onCreateAccount: onCreateAccount,
                          onLogIn: onLogIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared branding panel — logo, tagline, auth buttons

/// Displays the Decibel logo, tagline, and auth action buttons.
///
/// Uses fixed pixel sizes because [ResponsiveScaledBox] handles all scaling.
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({
    required this.logoHeight,
    required this.taglineFontSize,
    required this.buttonFontSize,
    this.buttonTopSpacing = 19,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final double logoHeight;
  final double taglineFontSize;
  final double buttonFontSize;
  final double buttonTopSpacing;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        Image.asset(AppAssets.blackLogo, height: logoHeight),

        // Tagline
        Text(
          'Where artists & fans\nconnect.',
          style: TextStyle(
            fontSize: taglineFontSize,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: buttonTopSpacing),

        // Auth buttons
        _AuthActions(
          buttonFontSize: buttonFontSize,
          onCreateAccount: onCreateAccount,
          onLogIn: onLogIn,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared auth action buttons

/// "Create an account" and "Log in" buttons.
class _AuthActions extends StatelessWidget {
  const _AuthActions({
    required this.buttonFontSize,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final double buttonFontSize;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onCreateAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: const Text('Create an account'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onLogIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x4DFFFFFF),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: const Text('Log in'),
        ),
      ],
    );
  }
}
