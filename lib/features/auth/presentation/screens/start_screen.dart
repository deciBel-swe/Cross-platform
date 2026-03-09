/// Decibel start/welcome screen — first screen users see.
///
/// Layers the geometric artwork background and the orange foreground panel,
/// with interactive auth buttons on top.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/route_paths.dart';

/// Entry-point screen presenting branding over layered artwork images
/// and primary auth actions on the orange panel.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: geometric artwork on black (full screen)
          Image.asset(AppAssets.startBg, fit: BoxFit.cover),

          // Layer 2: orange panel — clipped so only the orange section
          // (and decorative triangles) is visible, keeping the
          // background artwork exposed above.
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

          // Layer 3: interactive content pinned to the bottom,
          // sized to sit below the logo baked into the foreground image.
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
                    // Tagline
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

                    // Auth buttons
                    _AuthActions(
                      onCreateAccount: () => context.push(RoutePaths.register),
                      onLogIn: () => context.push(RoutePaths.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
