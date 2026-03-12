import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Auth application error.
sealed class AuthFailure extends AppFailure {
  /// Creates an instance of [AuthFailure].
  const AuthFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Invalid credentials error.
final class InvalidCredentialsFailure extends AuthFailure {
  /// Creates an instance of [InvalidCredentialsFailure].
  const InvalidCredentialsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.authInvalidCredentials);
}

/// Validation failed error.
final class ValidationFailedFailure extends AuthFailure {
  /// Field-specific validation errors.
  final Map<String, List<String>> fieldErrors;

  /// Creates an instance of [ValidationFailedFailure].
  const ValidationFailedFailure({
    super.parentException,
    super.stackTrace,
    this.fieldErrors = const {},
  }) : super(AppStrings.authValidationFailed);
}

/// Email already verified error.
final class EmailAlreadyVerifiedFailure extends AuthFailure {
  /// Creates an instance of [EmailAlreadyVerifiedFailure].
  const EmailAlreadyVerifiedFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.authEmailAlreadyVerified);
}

/// Email not verified error.
final class EmailNotVerifiedFailure extends AuthFailure {
  /// Creates an instance of [EmailNotVerifiedFailure].
  const EmailNotVerifiedFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.authEmailNotVerified);
}

/// Auth Rate limited error.
final class AuthRateLimitedFailure extends AuthFailure {
  /// Creates an instance of [AuthRateLimitedFailure].
  const AuthRateLimitedFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.authRateLimited);
}

/// Unauthorized error.
final class UnauthorizedAuthFailure extends AuthFailure {
  /// Creates an instance of [UnauthorizedAuthFailure].
  const UnauthorizedAuthFailure({
    super.parentException,
    super.stackTrace,
    // logout/redirect without showing a snackbar
  }) : super('');
}

/// Unknown authentication error.
final class UnknownAuthFailure extends AuthFailure {
  /// Creates an instance of [UnknownAuthFailure].
  const UnknownAuthFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.authUnknown);
}
