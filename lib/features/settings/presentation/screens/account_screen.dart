import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../../../library_profile/presentation/providers/user_profile_provider.dart';
import '../notifiers/change_email_notifier.dart';
import '../providers/change_email_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _isEditingEmail = false;
  late TextEditingController _emailController;
  String _originalEmail = '';
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _startEditing(String currentEmail) {
    ref.read(changeEmailProvider.notifier).reset();
    setState(() {
      _isEditingEmail = true;
      _originalEmail = currentEmail;
      _emailController.text = currentEmail;
      _emailError = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditingEmail = false;
      _emailController.text = _originalEmail;
      _emailError = null;
    });
  }

  void _onEmailChanged(String value) {
    setState(() {
      _emailError = AuthValidators.validateEmail(value);
    });
  }

  void _confirmEditing() {
    final error = AuthValidators.validateEmail(_emailController.text);
    if (error != null) {
      setState(() {
        _emailError = error;
      });
      return;
    }
    _showChangeEmailDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);

    // Listen for success / error results from the notifier.
    ref.listen<ChangeEmailState>(changeEmailProvider, (previous, next) {
      if (next.hasSuccess) {
        setState(() => _isEditingEmail = false);
        // Refresh the displayed email.
        ref.invalidate(userProfileProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.errors,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: userProfileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text(
            'Error loading profile',
            style: TextStyle(color: AppColors.onPrimary),
          ),
        ),
        data: (eitherUser) => eitherUser.fold(
          (failure) => Center(
            child: Text(
              failure.message,
              style: const TextStyle(color: AppColors.onPrimary),
            ),
          ),
          (user) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _isEditingEmail
                  ? _EditableAccountInfoTile(
                      label: 'Email',
                      controller: _emailController,
                      errorText: _emailError,
                      onChanged: _onEmailChanged,
                      onCancel: _cancelEditing,
                      onConfirm: _confirmEditing,
                    )
                  : _AccountInfoTile(
                      label: 'Email',
                      value: user.email,
                      onEdit: () => _startEditing(user.email),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    final newEmail = _emailController.text;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, watchRef, _) {
            final changeEmailState = watchRef.watch(changeEmailProvider);

            return AlertDialog(
              backgroundColor: const Color(0xFF2B2B2B),
              title: const Text(
                'Change Email',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: changeEmailState.isLoading
                  ? const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const Text(
                      'Are you sure you want to change your email? This will update your account email address.',
                      style: TextStyle(color: AppColors.onPrimary, height: 1.5),
                    ),
              actions: changeEmailState.isLoading
                  ? null
                  : [
                      TextButton(
                        onPressed: () => dialogContext.pop(),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(color: AppColors.onPrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Dispatch before popping so ref.listen can react.
                          ref
                              .read(changeEmailProvider.notifier)
                              .changeEmail(newEmail);
                          dialogContext.pop();
                        },
                        child: const Text(
                          'CONFIRM',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}

class _AccountInfoTile extends StatelessWidget {
  const _AccountInfoTile({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          label,
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          onPressed: onEdit,
        ),
      ),
    );
  }
}

class _EditableAccountInfoTile extends StatelessWidget {
  const _EditableAccountInfoTile({
    required this.label,
    required this.controller,
    required this.onCancel,
    required this.onConfirm,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 14,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    onChanged: onChanged,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      errorText: errorText,
                      errorStyle: const TextStyle(
                        color: AppColors.errors,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.errors),
                  onPressed: onCancel,
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: AppColors.success),
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
