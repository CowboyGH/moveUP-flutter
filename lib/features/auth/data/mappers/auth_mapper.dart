import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [AuthFailure].
extension AuthFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into an auth-specific failure.
  AuthFailure toAuthFailure() {
    final Map<String, List<String>> fieldErrors = this is ValidationFailure
        ? (this as ValidationFailure).errors
        : const <String, List<String>>{};

    switch (code) {
      case 'no_network':
        return AuthNoNetworkFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'connection_timeout':
        return AuthConnectionTimeoutFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'server_error':
        return AuthServerErrorFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'invalid_credentials':
        return InvalidCredentialsFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'validation_failed':
        return ValidationFailedFailure(
          fieldErrors: fieldErrors,
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
      case 'not_found':
        return UnknownAuthFailure(
          code: code,
          parentException: parentException,
          stackTrace: stackTrace,
        );
      default:
        return UnknownAuthFailure(
          parentException: parentException,
          stackTrace: stackTrace,
        );
    }
  }
}
