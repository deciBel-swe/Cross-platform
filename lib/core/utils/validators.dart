/// Reusable validators for authentication-related forms.
class Validators {
  Validators._();

  static bool isValidEmail(String email) {
    final String trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      return false;
    }

    return trimmedEmail.contains('@') && trimmedEmail.contains('.');
  }

  static String? validateEmail(String? email) {
    final String trimmedEmail = (email ?? '').trim();

    if (trimmedEmail.isEmpty) {
      return 'Email is required.';
    }

    if (!isValidEmail(trimmedEmail)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static bool isValidPassword(String password) {
    final String trimmedPassword = password.trim();
    return trimmedPassword.length >= 8;
  }

  static String? validatePassword(String? password) {
    final String trimmedPassword = (password ?? '').trim();

    if (trimmedPassword.isEmpty) {
      return 'Password is required.';
    }

    if (!isValidPassword(trimmedPassword)) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }
}
