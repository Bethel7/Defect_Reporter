class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? validateEmployeeId(String? value) {
    if (value == null || value.isEmpty) return 'Employee ID is required';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';

    // Require at least one uppercase, one lowercase, and one number
    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'[0-9]');
    if (!upper.hasMatch(value))
      return 'Password must contain an uppercase letter';
    if (!lower.hasMatch(value))
      return 'Password must contain a lowercase letter';
    if (!digit.hasMatch(value)) return 'Password must contain a number';
    if (value.contains(' ')) return 'Password cannot contain spaces';
    
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title is required';
    if (value.length > 100) return 'Title is too long';
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) return 'Location is required';
    return null;
  }

  static String? validateImagePath(String? value) {
    if (value == null || value.isEmpty) return 'Image is required';
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Description is required';
    if (value.length > 500) return 'Description is too long';
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != newPassword) return 'Passwords do not match';
    return null;
  }
}
