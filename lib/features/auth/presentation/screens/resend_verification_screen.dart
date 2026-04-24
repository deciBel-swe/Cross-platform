import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_primary_button.dart';

class ResendVerificationArgs {
  const ResendVerificationArgs({this.email, this.showSentMessage = false});

  final String? email;
  final bool showSentMessage;
}

class ResendVerificationScreen extends ConsumerStatefulWidget {
  const ResendVerificationScreen({
    super.key,
    this.initialEmail,
    this.showSentMessage = false,
  });

  final String? initialEmail;
  final bool showSentMessage;

  @override
  ConsumerState<ResendVerificationScreen> createState() =>
      _ResendVerificationScreenState();
}

class _ResendVerificationScreenState
    extends ConsumerState<ResendVerificationScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get _hasInitialEmail => widget.initialEmail?.trim().isNotEmpty ?? false;

  bool get _usesInitialEmail => widget.showSentMessage && _hasInitialEmail;

  String get _resendEmail => _usesInitialEmail
      ? widget.initialEmail!.trim()
      : _emailController.text.trim();

  @override
  void initState() {
    super.initState();
    _syncInitialEmail();
  }

  @override
  void didUpdateWidget(covariant ResendVerificationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEmail != widget.initialEmail) {
      _syncInitialEmail();
    }
  }

  void _syncInitialEmail() {
    final email = widget.initialEmail?.trim();
    if (email != null && email.isNotEmpty) {
      _emailController.text = email;
    }
  }

  Future<void> _handleResend() async {
    if (!_usesInitialEmail && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final (message, coolDown) = await ref
          .read(authStateProvider.notifier)
          .resendVerificationCode(email: _resendEmail);

      if (!mounted) {
        return;
      }

      ref.read(resendTimerProvider.notifier).startTimer(seconds: coolDown);

      if (!_usesInitialEmail) {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RoutePaths.login);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resendTimer = ref.watch(resendTimerProvider);
    final isSentState = _usesInitialEmail;
    final buttonLabel = resendTimer > 0
        ? 'Resend in ${resendTimer}s'
        : isSentState
        ? 'Resend code'
        : 'Send Code';

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: isSentState
              ? 'Email verification sent screen'
              : 'Resend verification screen',
          child: Text(
            isSentState ? 'Verify your email' : 'Resend Verification',
          ),
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isSentState ? 'Check your email' : 'Forgot your code?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isSentState) ...[
                    const Text(
                      'We have sent a verification code to',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _resendEmail,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Open your inbox to finish verifying your account. You can resend the code if it does not arrive.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ] else ...[
                    const Text(
                      'Enter the email address associated with your account and we\'ll send you a new verification code.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    Semantics(
                      textField: true,
                      label: 'Email address for verification code',
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'name@example.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        validator: AuthValidators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => _handleResend(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  AuthPrimaryButton(
                    label: buttonLabel,
                    semanticsLabel: resendTimer > 0
                        ? 'Resend verification code in $resendTimer seconds'
                        : 'Resend verification code',
                    isLoading: _isLoading,
                    onPressed: resendTimer > 0 ? null : _handleResend,
                  ),
                  if (resendTimer > 0) ...[
                    const SizedBox(height: 12),
                    Semantics(
                      liveRegion: true,
                      label: 'Resend available in $resendTimer seconds',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'You can resend in ${resendTimer}s',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isSentState) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(RoutePaths.login),
                        child: const Text('Back to sign in'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
