/// Account creation screen with social login and email/date/gender form.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';

/// Register screen: OAuth buttons, divider, email + date of birth + gender
/// fields, and a white Continue button.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _selectedDateOfBirth = picked;
      _dateController.text =
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final city = _cityController.text.trim();
    final country = _countryController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username is required.')));
      return;
    }

    final emailValidation = AuthValidators.validateEmail(email);
    if (emailValidation != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(emailValidation)));
      return;
    }

    final passwordValidation = AuthValidators.validatePassword(password);
    if (passwordValidation != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(passwordValidation)));
      return;
    }

    if (_selectedDateOfBirth == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date of birth and gender are required.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authStateProvider.notifier)
          .registerWithEmailPassword(
            email: email,
            username: username,
            password: password,
            dateOfBirth: _selectedDateOfBirth!,
            gender: _selectedGender!,
            city: city.isEmpty ? null : city,
            country: country.isEmpty ? null : country,
            captchaToken: ApiConstants.recaptchaSiteKey,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully.')),
      );
      context.go(RoutePaths.login);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  InputDecoration _inputDecoration([String? hint]) {
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
    final authState = ref.watch(authStateProvider);
    final isAuthLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create account'),
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
                  isLoading: isAuthLoading,
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

                TextField(
                  controller: _usernameController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Username'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Password'),
                ),

                const SizedBox(height: 16),

                // ---- Date of birth field ----
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Date of birth').copyWith(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---- Gender dropdown ----
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  hint: const Text(
                    'Gender',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration(),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(
                      value: 'non_binary',
                      child: Text('Non-binary'),
                    ),
                    DropdownMenuItem(
                      value: 'prefer_not_to_say',
                      child: Text('Prefer not to say'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _cityController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('City (optional)'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _countryController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration('Country (optional)'),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Protected by reCAPTCHA.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // ---- Continue button (white) ----
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onPrimary,
                    foregroundColor: AppColors.onBackground,
                  ),
                  child: _isSubmitting
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
