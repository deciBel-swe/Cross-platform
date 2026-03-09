/// Sign-in screen with social login and email/password form.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/social_login_button.dart';

/// Sign-in screen: OAuth buttons, divider, email + password fields,
/// and a white Continue button.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
              onPressed: () {
                // TODO(auth): implement Google sign-in
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
              icon: const Icon(Icons.apple, color: AppColors.apple, size: 24),
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Continue'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
