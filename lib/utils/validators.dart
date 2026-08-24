class Validators {
  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Name is required';
    if (!RegExp(r"^[A-Za-z ]+$").hasMatch(v)) {
      return 'Only alphabets and spaces are allowed';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@(gmail)\.(com|in)$')
        .hasMatch(v)) {
      return 'Use a valid @gmail.com or @gmail.in email';
    }
    return null;
  }

  static String? phone(String? value) {
    final v = value?.trim() ?? '';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.length < 8) return 'Minimum 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add a number';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(v)) {
      return 'Add a special character';
    }
    return null;
  }
}
