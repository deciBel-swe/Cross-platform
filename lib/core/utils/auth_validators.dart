class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

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
}
