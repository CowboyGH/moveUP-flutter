import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Cards application error.
sealed class CardsFailure extends AppFailure {
  /// Creates an instance of [CardsFailure].
  const CardsFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Cards validation failed because the provided input is invalid.
final class CardsValidationFailure extends CardsFailure {
  /// Creates an instance of [CardsValidationFailure].
  const CardsValidationFailure({
    String message = AppStrings.cardsValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Cards request failed because of infrastructure or network conditions.
final class CardsRequestFailure extends CardsFailure {
  /// Creates an instance of [CardsRequestFailure].
  const CardsRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Unknown cards failure.
final class UnknownCardsFailure extends CardsFailure {
  /// Creates an instance of [UnknownCardsFailure].
  const UnknownCardsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.cardsUnknown);
}
