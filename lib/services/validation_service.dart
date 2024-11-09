class ValidationService {
  static String? validateName(String name) {
    if (name.isEmpty) {
      return "Kullanıcı adı boş olamaz.";
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "E-posta boş olamaz.";
    }
    // Burada isterseniz e-posta formatı doğrulaması yapabilirsiniz
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Şifre boş olamaz.";
    } else if (password.length < 6) {
      return "Şifre en az 6 karakter olmalı.";
    }
    return null;
  }
}
