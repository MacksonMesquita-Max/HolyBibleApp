class FullNameValidator {
  const FullNameValidator._();

  static final RegExp _fullNameRegex = RegExp(
    r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?:['’-][A-Za-zÀ-ÖØ-öø-ÿ]+)*(?:\s+[A-Za-zÀ-ÖØ-öø-ÿ]+(?:['’-][A-Za-zÀ-ÖØ-öø-ÿ]+)*)+$",
  );

  static String? validate(String? value) {
    final fullName = value?.trim() ?? '';

    if (fullName.isEmpty || fullName.split(RegExp(r'\s+')).length < 2) {
      return 'Informe seu nome e sobrenome.';
    }

    if (!_fullNameRegex.hasMatch(fullName)) {
      return 'Informe um nome e sobrenome válidos.';
    }

    return null;
  }
}
