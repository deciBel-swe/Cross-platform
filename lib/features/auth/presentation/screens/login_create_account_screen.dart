import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../providers/auth_provider.dart';
import '../utils/webview_auth_config.dart';
import 'webview_auth_screen.dart';

class LoginCreateAccountScreen extends ConsumerWidget {
  const LoginCreateAccountScreen({super.key});

  Future<void> _handleTokens(
    BuildContext context,
    WidgetRef ref, {
    required String token,
    required String refreshToken,
  }) async {
    await ref.read(authStateProvider.notifier).handleWebViewLoginSuccess(
          accessToken: token,
          refreshToken: refreshToken,
        );

    if (context.mounted) {
      context.go(RoutePaths.home);
    }
  }

  void _openWebView(
    BuildContext context,
    WidgetRef ref,
    AuthWebViewMode mode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewAuthScreen(
          mode: mode,
          onTokensReceived: ({
            required String token,
            required String refreshToken,
          }) async {
            await _handleTokens(
              context,
              ref,
              token: token,
              refreshToken: refreshToken,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start_screen_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA366),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.graphic_eq,
                    size: 48,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Where artists & fans\nconnect.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openWebView(
                        context,
                        ref,
                        AuthWebViewMode.register,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Create an account'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openWebView(
                        context,
                        ref,
                        AuthWebViewMode.login,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7BE97),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Log in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}