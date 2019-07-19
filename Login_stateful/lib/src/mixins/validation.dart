class ValidationMixin {
  String validateEmail(String value) {
    // return null if valide
    // otherwise string (error messanges) with invalide
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 4) return 'Password must be at least 4 characters';
    return null;
  }
}
