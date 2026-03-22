/// Sign-in screen with social login and email/password form.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';
import '../../../../core/router/route_paths.dart';
import '../../domain/entities/auth_state.dart';

/// Sign-in screen: OAuth buttons, divider, email + password fields,
/// and a white Continue button.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch for the current authentication state to show loading indicators
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    // Listen for errors and show a SnackBar
    ref.listen<AsyncValue<AuthState>>(authStateProvider, (previous, next) {
      if (!next.isLoading && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString().replaceAll('Exception: ', '')),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // ---- Social login buttons ----
                SocialLoginButton(
                  label: 'Continue with Google',
                  icon: const Icon(
                    Icons.g_mobiledata,
                    color: AppColors.google,
                    size: 24,
                  ),
                  isLoading: isLoading,
                  onPressed: () {
                    ref.read(authStateProvider.notifier).loginWithGoogle();
                  },
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  label: 'Continue with Facebook',
                  icon: const Icon(
                    Icons.facebook,
                    color: AppColors.facebook,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO(auth): implement Facebook sign-in
                  },
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  label: 'Continue with Apple',
                  icon: const Icon(
                    Icons.apple,
                    color: AppColors.apple,
                    size: 24,
                  ),
                  onPressed: () {
                    // TODO(auth): implement Apple sign-in
                  },
                ),

                const SizedBox(height: 28),

                // ---- Divider ----
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or', style: theme.textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 28),

                // ---- Email field ----
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Email'),
                ),

                const SizedBox(height: 16),

                // ---- Password field ----
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Password'),
                ),

                const SizedBox(height: 32),

                // ---- Continue button (white) ----
                ElevatedButton(
                  onPressed: () {
                    // TODO(auth): implement email sign-in
                    context.go(RoutePaths.loginCreateAccount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onPrimary,
                    foregroundColor: AppColors.onBackground,
                  ),
                  child: const Text('Continue'),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
