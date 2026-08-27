class EmailValidator {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static bool isEmailValid(String email) {
    if (email.isEmpty) {
      return false;
    }
    return _emailRegExp.hasMatch(email);
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de e-mail é obrigatório.';
    }
    if (!isEmailValid(value)) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  }
}