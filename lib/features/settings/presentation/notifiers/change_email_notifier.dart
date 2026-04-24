import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../providers/change_email_provider.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class ChangeEmailState {
  const ChangeEmailState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;

  ChangeEmailState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChangeEmailState(
      isLoading: isLoading ?? this.isLoading,
      // FIX: Added '?? this.errorMessage' to prevent accidental erasure of state
      errorMessage: errorMessage ?? this.errorMessage,
      // FIX: Added '?? this.successMessage' to prevent accidental erasure of state
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ChangeEmailNotifier extends Notifier<ChangeEmailState> {
  @override
  ChangeEmailState build() => const ChangeEmailState();

  Future<void> changeEmail(String newEmail) async {
    if (state.isLoading) return;

    // By instantiating a completely new ChangeEmailState instead of using copyWith,
    // we effectively clear out any old error or success messages for the new request.
    state = const ChangeEmailState(isLoading: true);

    try {
      final message = await ref
          .read(changeEmailRepositoryProvider)
          .changeEmail(newEmail: newEmail);

      state = ChangeEmailState(successMessage: _getSuccessMessage(message));
    } catch (e) {
      state = ChangeEmailState(errorMessage: _getErrorMessage(e));
    }
  }

  String _getSuccessMessage(String apiMessage) {
    return apiMessage.isNotEmpty
        ? apiMessage
        : 'verification code sent please verify';
  }

  String _getErrorMessage(Object e) {
    String? message;

    if (e is DioException) {
      message = _extractMessageFromResponse(e.response?.data);
    } else if (e is AppException) {
      message = e.message;
    }

    // Map specific technical errors to user-friendly messages
    if (message == 'One or more fields are invalid.') {
      return 'email field is invalid re-enter it';
    }

    return message ?? 'Failed to update email. Please try again.';
  }

  String? _extractMessageFromResponse(Object? data) {
    // FIX: Tightened type check to Map<String, dynamic> for better type safety
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) return data['message'].toString();
      if (data['data'] is Map<String, dynamic> &&
          (data['data'] as Map<String, dynamic>)['message'] != null) {
        return (data['data'] as Map<String, dynamic>)['message'].toString();
      }
    }
    if (data is String) return data.toString();
    return null;
  }

  /// Reset to idle so the next edit starts fresh.
  void reset() => state = const ChangeEmailState();
}