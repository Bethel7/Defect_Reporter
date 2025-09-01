class Validators {
  /// Generic required field validator
  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? validateEmployeeId(String? value) =>
      requiredValidator(value, 'Employee ID');

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';

    // Require at least one uppercase, one lowercase, and one number
    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'[0-9]');
    if (!upper.hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }
    if (!lower.hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }
    if (!digit.hasMatch(value)) return 'Password must contain a number';
    if (value.contains(' ')) return 'Password cannot contain spaces';
    return null;
  }

  static String? validateTitle(String? value) {
    final required = requiredValidator(value, 'Title');
    if (required != null) return required;
    if (value!.length > 100) return 'Title is too long';
    return null;
  }

  static String? validateLocation(String? value) =>
      requiredValidator(value, 'Location');

  static String? validateImagePath(String? path) {
    if (path == null || path.trim().isEmpty) {
      return 'Please upload an image';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    final required = requiredValidator(value, 'Description');
    if (required != null) return required;
    if (value!.length > 500) return 'Description is too long';
    return null;
  }

  static String? validateLocationId(String? locationId) {
    if (locationId == null || locationId.trim().isEmpty) {
      return 'Please select a location';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value.trim() != newPassword.trim()) return 'Passwords do not match';
    return null;
  }
}
