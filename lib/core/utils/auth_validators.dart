class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  static final RegExp _socialLinkRegex = RegExp(
    r'^(https?:\/\/)([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/[^\s]*)?$',
  );

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email is required.';
    }

    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required.';
    }

    if (!_passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters and include letters and numbers.';
    }

    return null;
  }

  static String? validateSocialLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();

    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'Link must start with http:// or https://';
    }

    if (!_socialLinkRegex.hasMatch(trimmed)) {
      return 'Enter a valid link like https://example.com';
    }

    return null;
  }
}
