/// Decibel start/welcome screen — first screen users see.
///
/// Responsive: uses [AnimatedSwitcher] for a fluid crossfade between the
/// mobile (portrait artwork) and desktop (landscape artwork) layouts.
/// Both layouts share the same [_BrandingPanel] with the logo, tagline,
/// and auth actions.
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

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    super.key,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: geometric artwork on black (full screen)
        Image.asset(AppAssets.startBg, fit: BoxFit.cover),

        // Layer 2: orange panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: screenHeight * 0.416,
          child: Image.asset(
            AppAssets.startFg,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Layer 3: interactive content
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 35),
              child: _BrandingPanel(
                logoHeight: 80,
                taglineFontSize: 22,
                onCreateAccount: onCreateAccount,
                onLogIn: onLogIn,
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
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

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

        // Layer 3: branding + auth actions
        Positioned(
          left: -65,
          right: 0,
          top: screenHeight * 0.42,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _BrandingPanel(
                  logoHeight: 80,
                  taglineFontSize: 24,
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
// Shared branding panel — logo, tagline, auth buttons

/// Displays the Decibel logo, tagline, and auth action buttons.
///
/// Shared between mobile and desktop layouts. [logoHeight] and
/// [taglineFontSize] allow each layout to tune sizing.
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({
    required this.logoHeight,
    required this.taglineFontSize,
    required this.onCreateAccount,
    required this.onLogIn,
  });

  final double logoHeight;
  final double taglineFontSize;
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
            fontSize: taglineFontSize + 5,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 19),

        // Auth buttons
        _AuthActions(onCreateAccount: onCreateAccount, onLogIn: onLogIn),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared auth action buttons

/// "Create an account" and "Log in" buttons.
class _AuthActions extends StatelessWidget {
  const _AuthActions({required this.onCreateAccount, required this.onLogIn});

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
          ),
          child: const Text('Create an account'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onLogIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0x4DFFFFFF),
            foregroundColor: Colors.black,
          ),
          child: const Text('Log in'),
        ),
      ],
    );
  }
}
