class StringValidator {
  static final RegExp _singleSpaceLettersRegex = RegExp(
    r'^[a-zA-Z]+(?:\s[a-zA-Z]+)*$',
  );

  static bool isValidLettersAndSingleSpace(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    return _singleSpaceLettersRegex.hasMatch(value);
  }
}
