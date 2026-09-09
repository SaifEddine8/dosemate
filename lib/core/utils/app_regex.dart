class AppRegex {
  
  
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );



  static bool isEmailValid(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  static bool isPasswordValid(String password) {
    return _strongPasswordRegex.hasMatch(password);
  }
}