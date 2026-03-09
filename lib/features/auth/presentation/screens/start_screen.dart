/// Decibel start/welcome screen — first screen users see.
///
/// Responsive: mobile uses the layered background/foreground artwork stack;
/// desktop mirrors the same layered approach with landscape-oriented artwork.
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          void goToRegister() => context.push(RoutePaths.register);
          void goToLogin() => context.push(RoutePaths.login);

          if (constraints.maxWidth >= _desktopBreakpoint) {
            return _DesktopLayout(
              onCreateAccount: goToRegister,
              onLogIn: goToLogin,
            );
          }

          return _MobileLayout(
            onCreateAccount: goToRegister,
            onLogIn: goToLogin,
          );
        },
      ),
    );
  }
}

// Mobile layout — stacked artwork design

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.onCreateAccount, required this.onLogIn});

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: geometric artwork on black (full screen)
        Image.asset(AppAssets.startBg, fit: BoxFit.cover),

        // orange panel
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
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Where artists & fans\nconnect.',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  _AuthActions(
                    onCreateAccount: onCreateAccount,
                    onLogIn: onLogIn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Desktop layout

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.onCreateAccount, required this.onLogIn});

  final VoidCallback onCreateAccount;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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

        // positioned below the logo
        Positioned(
          left: 0,
          right: 0,
          top: screenHeight * 0.52,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tagline
                  const Text(
                    'Where artists & fans\nconnect.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Auth buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _AuthActions(
                      onCreateAccount: onCreateAccount,
                      onLogIn: onLogIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
