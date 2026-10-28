class EmailValidator {
  const EmailValidator._();

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String? validate(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }
}
