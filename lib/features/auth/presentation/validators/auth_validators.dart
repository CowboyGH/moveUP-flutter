/// Shared validators for auth presentation forms.
abstract final class AuthValidators {
  static final RegExp _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~%-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
  );
  static final RegExp _allowedPasswordCharsPattern = RegExp(r'^[A-Za-z0-9]+$');
  static final RegExp _passwordHasLetterPattern = RegExp(r'[A-Za-z]');
  static final RegExp _passwordHasDigitPattern = RegExp(r'\d');
  static final RegExp _otpCodePattern = RegExp(r'^\d{6}$');

  /// Validates a user name value.
  static String? name(String? value) {
    final normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return 'Введите имя';
    }
    if (normalizedValue.length > 20) {
      return 'Длина имени должна быть не более 20 символов';
    }
    return null;
  }

  /// Validates an email value.
  static String? email(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return 'Введите email';
    }

    if (!_emailPattern.hasMatch(trimmedValue)) {
      return 'Неверный формат email';
    }
    return null;
  }

  /// Validates a password value by current auth policy.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }

    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    if (value.length > 64) {
      return 'Пароль должен быть не длиннее 64 символов';
    }

    if (!_allowedPasswordCharsPattern.hasMatch(value)) {
      return 'Пароль должен содержать только латинские буквы и цифры';
    }

    final hasLetter = _passwordHasLetterPattern.hasMatch(value);
    final hasDigit = _passwordHasDigitPattern.hasMatch(value);
    if (!hasLetter || !hasDigit) {
      return 'Пароль должен содержать буквы и цифры';
    }

    return null;
  }

  /// Validates OTP verification code.
  static String? otpCode(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return 'Введите код';
    }
    if (!_otpCodePattern.hasMatch(trimmedValue)) {
      return 'Код должен состоять из 6 цифр';
    }
    return null;
  }
}
