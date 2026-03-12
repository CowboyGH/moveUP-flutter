import '../../../../core/constants/app_strings.dart';

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
      return AppStrings.authNameRequired;
    }
    if (normalizedValue.length > 20) {
      return AppStrings.authNameMaxLength;
    }
    return null;
  }

  /// Validates an email value.
  static String? email(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return AppStrings.authEmailRequired;
    }

    if (!_emailPattern.hasMatch(trimmedValue)) {
      return AppStrings.authEmailFormat;
    }
    return null;
  }

  /// Validates a password value by current auth policy.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.authPasswordRequired;
    }

    if (value.length < 8) {
      return AppStrings.authPasswordMinLength;
    }
    if (value.length > 64) {
      return AppStrings.authPasswordMaxLength;
    }

    if (!_allowedPasswordCharsPattern.hasMatch(value)) {
      return AppStrings.authPasswordAllowedChars;
    }

    final hasLetter = _passwordHasLetterPattern.hasMatch(value);
    final hasDigit = _passwordHasDigitPattern.hasMatch(value);
    if (!hasLetter || !hasDigit) {
      return AppStrings.authPasswordLetterAndDigit;
    }

    return null;
  }

  /// Validates OTP verification code.
  static String? otpCode(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return AppStrings.authOtpCodeRequired;
    }
    if (!_otpCodePattern.hasMatch(trimmedValue)) {
      return AppStrings.authOtpCodeFormat;
    }
    return null;
  }
}
