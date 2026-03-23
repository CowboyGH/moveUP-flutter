import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Phases application error.
sealed class PhasesFailure extends AppFailure {
  /// Creates an instance of [PhasesFailure].
  const PhasesFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Phases request failed because of infrastructure or network conditions.
final class PhasesRequestFailure extends PhasesFailure {
  /// Creates an instance of [PhasesRequestFailure].
  const PhasesRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Phases validation failed because the provided input is invalid.
final class PhasesValidationFailure extends PhasesFailure {
  /// Creates an instance of [PhasesValidationFailure].
  const PhasesValidationFailure({
    String message = AppStrings.phasesValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Unknown phases failure.
final class UnknownPhasesFailure extends PhasesFailure {
  /// Creates an instance of [UnknownPhasesFailure].
  const UnknownPhasesFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.phasesUnknown);
}
