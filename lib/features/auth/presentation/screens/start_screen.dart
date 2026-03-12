/// Decibel start/welcome screen — first screen users see.
///
/// Responsive: uses [AnimatedSwitcher] for a fluid crossfade between the
/// mobile (portrait artwork) and desktop (landscape artwork) layouts.
/// Both layouts share the same [_BrandingPanel] with the logo, tagline,
/// and auth actions.
///
/// Font sizes, logo height, and button dimensions scale proportionally with
/// the available screen dimensions, clamped to sensible min/max bounds.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/route_paths.dart';

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
                    constraints: constraints,
                    onCreateAccount: goToRegister,
                    onLogIn: goToLogin,
                  )
                : _MobileLayout(
                    key: const ValueKey('mobile'),
                    constraints: constraints,
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

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    super.key,
    required this.constraints,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final BoxConstraints constraints;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  /// Fraction of total height the foreground IMAGE occupies.
  static const double _fgFraction = 0.416;

  /// The visible orange area starts roughly 40% down the foreground image,
  /// so the usable content area is about 60% of fgHeight.
  static const double _orangeUsableFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    final screenHeight = constraints.maxHeight;
    final fgHeight = screenHeight * _fgFraction;
    final contentHeight = fgHeight * _orangeUsableFraction;

    // Derive ALL sizes from the content area height so they scale in
    // lockstep with the foreground image.
    final logoHeight = (contentHeight * 0.22).clamp(24.0, 70.0);
    final taglineFontSize = (contentHeight * 0.10).clamp(12.0, 24.0);
    final buttonFontSize = (contentHeight * 0.065).clamp(11.0, 15.0);
    final horizontalPadding = (contentHeight * 0.14).clamp(16.0, 40.0);
    final bottomPadding = (contentHeight * 0.10).clamp(8.0, 30.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: geometric artwork on black (full screen)
        Image.asset(AppAssets.startBg, fit: BoxFit.cover),

        // Layer 2: orange panel image
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: fgHeight,
          child: Image.asset(
            AppAssets.startFg,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Layer 3: content — confined to the visible orange portion only
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: contentHeight,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                contentHeight * 0.08,
                horizontalPadding,
                bottomPadding,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: _BrandingPanel(
                  logoHeight: logoHeight,
                  taglineFontSize: taglineFontSize,
                  buttonFontSize: buttonFontSize,
                  onCreateAccount: onCreateAccount,
                  onLogIn: onLogIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop layout

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    super.key,
    required this.constraints,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final BoxConstraints constraints;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final screenHeight = constraints.maxHeight;
    final screenWidth = constraints.maxWidth;

    // The desktop foreground blob is roughly the bottom 50% of the screen.
    // Fit the content into the centre of that area.
    final contentHeight = screenHeight * 0.5;

    // Derive sizes from available content height.
    final logoHeight = (contentHeight * 0.18).clamp(24.0, 70.0);
    final taglineFontSize = (contentHeight * 0.075).clamp(12.0, 24.0);
    final buttonFontSize = (contentHeight * 0.05).clamp(11.0, 15.0);
    final panelMaxWidth = (screenWidth * 0.35).clamp(250.0, 420.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: desktop geometric artwork (full screen)
        Image.asset(AppAssets.desktopStartBg, fit: BoxFit.cover),

        // Layer 2: desktop orange foreground
        Positioned.fill(
          child: Image.asset(
            AppAssets.desktopStartFg,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Layer 3: branding + auth actions — top of the bottom portion
        Positioned(
          left: -65,
          right: 0,
          bottom: 0,
          height: contentHeight,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: contentHeight * 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: panelMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _BrandingPanel(
                    logoHeight: logoHeight,
                    taglineFontSize: taglineFontSize,
                    buttonFontSize: buttonFontSize,
                    onCreateAccount: onCreateAccount,
                    onLogIn: onLogIn,
                  ),
                ),
              ),
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
/// Shared between mobile and desktop layouts. [logoHeight],
/// [taglineFontSize], and [buttonFontSize] allow each layout to tune sizing
/// proportionally to the available screen space.
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({
    required this.logoHeight,
    required this.taglineFontSize,
    required this.buttonFontSize,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final double logoHeight;
  final double taglineFontSize;
  final double buttonFontSize;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        Image.asset(AppAssets.blackLogo, height: logoHeight),
        const SizedBox(height: 0),

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
        SizedBox(height: taglineFontSize * 0.85),

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
    final verticalPad = (buttonFontSize * 0.7).clamp(8.0, 18.0);
    final horizontalPad = (buttonFontSize * 1.5).clamp(16.0, 36.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onCreateAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              vertical: verticalPad,
              horizontal: horizontalPad,
            ),
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: const Text('Create an account'),
        ),
        SizedBox(height: buttonFontSize * 0.75),
        ElevatedButton(
          onPressed: onLogIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x4DFFFFFF),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              vertical: verticalPad,
              horizontal: horizontalPad,
            ),
            textStyle: TextStyle(fontSize: buttonFontSize),
          ),
          child: const Text('Log in'),
        ),
      ],
    );
  }
}
