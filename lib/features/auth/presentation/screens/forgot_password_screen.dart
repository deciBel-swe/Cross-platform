library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../providers/forgot_password_provider.dart';

/// Screen for requesting a password recovery email.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _autoValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'Your email address',
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.onPrimary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.errors, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.errors, width: 1),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _autoValidate = true;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await ref
        .read(forgotPasswordProvider.notifier)
        .submit(_emailController.text.trim());
  }

  void _returnToLogin() {
    context.go(RoutePaths.login);
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordState state = ref.watch(forgotPasswordProvider);
    final bool isLoading = state is ForgotPasswordLoading;
    final bool isSuccess = state is ForgotPasswordSuccess;
    final String successMessage = state is ForgotPasswordSuccess
        ? state.message
        : "Check your inbox. We've sent a reset link.";
    final String? errorMessage = state is ForgotPasswordError
        ? state.message
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: _handleBack,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
        title: const Text(
          'Reset password',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isSuccess
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    successMessage,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _returnToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onPrimary,
                        foregroundColor: AppColors.onBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      validator: AuthValidators.validateEmail,
                      onChanged: (_) {
                        ref.read(forgotPasswordProvider.notifier).clearError();
                      },
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'If the email address is in our database, we will send you an email to reset your password. Need help? ',
                          ),
                          TextSpan(
                            text: 'visit our Help Center.',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: AppColors.errors,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onPrimary,
                          foregroundColor: AppColors.onBackground,
                          disabledBackgroundColor: AppColors.onPrimary,
                          disabledForegroundColor: AppColors.onBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Send reset link',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
