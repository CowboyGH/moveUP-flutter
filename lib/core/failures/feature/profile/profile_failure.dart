import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Profile application error.
sealed class ProfileFailure extends AppFailure {
  /// Creates an instance of [ProfileFailure].
  const ProfileFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Profile validation failed because the provided input is invalid.
final class ProfileValidationFailure extends ProfileFailure {
  /// Creates an instance of [ProfileValidationFailure].
  const ProfileValidationFailure({
    String message = AppStrings.profileValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Profile request failed because of infrastructure or network conditions.
final class ProfileRequestFailure extends ProfileFailure {
  /// Creates an instance of [ProfileRequestFailure].
  const ProfileRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Unknown profile failure.
final class UnknownProfileFailure extends ProfileFailure {
  /// Creates an instance of [UnknownProfileFailure].
  const UnknownProfileFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.profileUnknown);
}
