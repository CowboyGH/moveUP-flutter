import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [AuthFailure].
extension AuthFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into an auth-specific failure.
  AuthFailure toAuthFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = buildValidationMessage(
      fieldErrors,
      fallbackMessage: const ValidationFailedFailure().message,
    );

    switch (code) {
      case 'invalid_credentials':
        return InvalidCredentialsFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'validation_failed':
        return ValidationFailedFailure(
          message: validationMessage,
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'email_already_verified':
        return EmailAlreadyVerifiedFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'email_not_verified':
        return EmailNotVerifiedFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'rate_limited':
        return AuthRateLimitedFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'token_expired':
      case 'session_expired_inactivity':
      case 'session_expired_absolute':
      case 'unauthorized':
      case 'forbidden':
        return UnauthorizedAuthFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      default:
        return switch (this) {
          NoNetworkFailure() ||
          ConnectionTimeoutFailure() ||
          ServerErrorFailure() ||
          UnknownNetworkFailure() => AuthRequestFailure(
            message,
            parentException: parentException,
            stackTrace: stackTrace,
          ),
          _ => UnknownAuthFailure(
            parentException: parentException,
            stackTrace: stackTrace,
          ),
        };
    }
  }
}
