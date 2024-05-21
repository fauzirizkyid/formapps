String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  // Email validation regex pattern
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }

  return null; // Email is valid
}
