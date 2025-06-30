class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$')
        .hasMatch(password);
  }

  static bool hasLowerCase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  static bool hasNumber(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  static bool hasSpecialCharacter(String password) {
    return RegExp(r'[\W_]').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return password.length >= 8; // غيرت من 4 إلى 8 لتتوافق مع الشرط الأساسي
  }
}