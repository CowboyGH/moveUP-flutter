import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Fitness Start application error.
sealed class FitnessStartFailure extends AppFailure {
  /// Creates an instance of [FitnessStartFailure].
  const FitnessStartFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Validation failed for Fitness Start request.
final class FitnessStartValidationFailure extends FitnessStartFailure {
  /// Creates an instance of [FitnessStartValidationFailure].
  const FitnessStartValidationFailure({
    String message = AppStrings.fitnessStartValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Fitness Start request failed because of infrastructure or network conditions.
final class FitnessStartRequestFailure extends FitnessStartFailure {
  /// Creates an instance of [FitnessStartRequestFailure].
  const FitnessStartRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Unknown Fitness Start failure.
final class UnknownFitnessStartFailure extends FitnessStartFailure {
  /// Creates an instance of [UnknownFitnessStartFailure].
  const UnknownFitnessStartFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.fitnessStartUnknown);
}
