/// Sign-in screen with social login and email/password form.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';

enum AuthLoadingType { none, email, google, facebook, apple }

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
  bool _obscurePassword = true;
  AuthLoadingType _loadingType = AuthLoadingType.none;

  bool get _isAnyLoading => _loadingType != AuthLoadingType.none;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailValidation = AuthValidators.validateEmail(email);
    if (emailValidation != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(emailValidation)));
      return;
    }

    final passwordValidation = AuthValidators.validatePassword(password);
    if (passwordValidation != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(passwordValidation)));
      return;
    }

    setState(() => _loadingType = AuthLoadingType.email);
    try {
      await ref
          .read(authStateProvider.notifier)
          .loginWithEmailPassword(email: email, password: password);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingType = AuthLoadingType.none);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _loadingType = AuthLoadingType.google);
    try {
      await ref.read(authStateProvider.notifier).loginWithGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingType = AuthLoadingType.none);
      }
    }
  }

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
                  isLoading: _loadingType == AuthLoadingType.google,
                  onPressed: _isAnyLoading ? null : _handleGoogleLogin,
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
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email,
                  ],
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
                  obscureText: _obscurePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _handleLogin(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ---- Continue button (white) ----
                ElevatedButton(
                  onPressed: _isAnyLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onPrimary,
                    foregroundColor: AppColors.onBackground,
                  ),
                  child: _loadingType == AuthLoadingType.email
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
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
