import '../../../../core/constants/app_strings.dart';

/// Shared validators for saved card form fields.
abstract final class CardFormValidators {
  static const _hiddenValidationError = 'invalid';
  static const _maxFutureYears = 20;
  static final _cardHolderPattern = RegExp(r'^[A-Z ]+$');

  /// Validates a card number.
  static String? cardNumber(String? value) {
    final digits = _digitsOnly(value);
    if (digits.isEmpty) {
      return AppStrings.subscriptionsPaymentCardNumberRequired;
    }
    if (digits.length != 16) {
      return AppStrings.subscriptionsPaymentCardNumberInvalid;
    }
    return null;
  }

  /// Validates a card holder.
  static String? cardHolder(String? value) {
    final trimmed = _trimmed(value).toUpperCase();
    if (trimmed.isEmpty) {
      return AppStrings.subscriptionsPaymentCardHolderRequired;
    }
    if (!_cardHolderPattern.hasMatch(trimmed)) {
      return AppStrings.subscriptionsPaymentCardHolderInvalid;
    }
    return null;
  }

  /// Validates a card expiry month.
  static String? expiryMonth(
    String? value, {
    String? yearValue,
    DateTime? now,
  }) {
    final trimmed = _trimmed(value);
    if (trimmed.isEmpty) {
      return AppStrings.subscriptionsPaymentExpiryMonthHint;
    }

    final month = int.tryParse(trimmed);
    if (month == null || month < 1 || month > 12) {
      return AppStrings.subscriptionsPaymentExpiryMonthHint;
    }

    final year = int.tryParse(_trimmed(yearValue));
    if (year != null) {
      final currentDate = now ?? DateTime.now();
      if (_isExpired(month: month, year: year, now: currentDate) ||
          _isTooFarInFuture(year: year, now: currentDate)) {
        return _hiddenValidationError;
      }
    }
    return null;
  }

  /// Validates a card expiry year.
  static String? expiryYear(
    String? value, {
    String? monthValue,
    DateTime? now,
  }) {
    final trimmed = _trimmed(value);
    if (trimmed.isEmpty) {
      return AppStrings.subscriptionsPaymentExpiryYearHint;
    }
    if (trimmed.length != 4) {
      return AppStrings.subscriptionsPaymentExpiryYearHint;
    }

    final year = int.tryParse(trimmed);
    if (year == null) {
      return AppStrings.subscriptionsPaymentExpiryYearHint;
    }

    final currentDate = now ?? DateTime.now();
    if (year < currentDate.year || _isTooFarInFuture(year: year, now: currentDate)) {
      return _hiddenValidationError;
    }

    final month = int.tryParse(_trimmed(monthValue));
    if (month != null &&
        month >= 1 &&
        month <= 12 &&
        _isExpired(month: month, year: year, now: currentDate)) {
      return _hiddenValidationError;
    }
    return null;
  }

  /// Validates a card CVV.
  static String? cvv(String? value) {
    final trimmed = _trimmed(value);
    if (trimmed.isEmpty) {
      return AppStrings.subscriptionsPaymentCvvHint;
    }
    if (trimmed.length != 3 || int.tryParse(trimmed) == null) {
      return AppStrings.subscriptionsPaymentCvvHint;
    }
    return null;
  }

  static String _trimmed(String? value) => value?.trim() ?? '';

  static String _digitsOnly(String? value) => (value ?? '').replaceAll(RegExp(r'\D'), '');

  static bool _isExpired({
    required int month,
    required int year,
    required DateTime now,
  }) {
    if (year < now.year) return true;
    if (year == now.year && month < now.month) return true;
    return false;
  }

  static bool _isTooFarInFuture({
    required int year,
    required DateTime now,
  }) {
    return year > now.year + _maxFutureYears;
  }
}
