import '../../constants/app_strings.dart';
import '../app_failure.dart';

/// Network application error.
sealed class NetworkFailure extends AppFailure {
  /// Stable error code for business logic mapping.
  final String code;

  /// Creates an instance of [NetworkFailure].
  const NetworkFailure(
    super.message, {
    required this.code,
    super.parentException,
    super.stackTrace,
  });
}

/// No internet connection error.
final class NoNetworkFailure extends NetworkFailure {
  /// Creates an instance of [NoNetworkFailure].
  const NoNetworkFailure({
    String code = 'no_network',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkNoConnection, code: code);
}

/// Connection timeout error.
final class ConnectionTimeoutFailure extends NetworkFailure {
  /// Creates an instance of [ConnectionTimeoutFailure].
  const ConnectionTimeoutFailure({
    String code = 'connection_timeout',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkTimeout, code: code);
}

/// HTTP 400 error.
final class BadRequestFailure extends NetworkFailure {
  /// Creates an instance of [BadRequestFailure].
  const BadRequestFailure({
    String code = 'bad_request',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkBadRequest, code: code);
}

/// HTTP 401 error.
final class UnauthorizedFailure extends NetworkFailure {
  /// Creates an instance of [UnauthorizedFailure].
  const UnauthorizedFailure({
    String code = 'unauthorized',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkUnauthorized, code: code);
}

/// HTTP 403 error.
final class ForbiddenFailure extends NetworkFailure {
  /// Creates an instance of [ForbiddenFailure].
  const ForbiddenFailure({
    String code = 'forbidden',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkForbidden, code: code);
}

/// HTTP 404 error.
final class NotFoundFailure extends NetworkFailure {
  /// Creates an instance of [NotFoundFailure].
  const NotFoundFailure({
    String code = 'not_found',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkNotFound, code: code);
}

/// HTTP 409 error.
final class ConflictFailure extends NetworkFailure {
  /// Creates an instance of [ConflictFailure].
  const ConflictFailure({
    String code = 'conflict',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkConflict, code: code);
}

/// HTTP 422 error.
final class ValidationFailure extends NetworkFailure {
  /// Detailed validation errors by field.
  final Map<String, List<String>> errors;

  /// Creates an instance of [ValidationFailure].
  const ValidationFailure({
    String code = 'validation_failed',
    this.errors = const {},
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkValidation, code: code);
}

/// HTTP 429 error.
final class RateLimitedFailure extends NetworkFailure {
  /// Creates an instance of [RateLimitedFailure].
  const RateLimitedFailure({
    String code = 'rate_limited',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkRateLimited, code: code);
}

/// HTTP 5xx error.
final class ServerErrorFailure extends NetworkFailure {
  /// Creates an instance of [ServerErrorFailure].
  const ServerErrorFailure({
    String code = 'server_error',
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkServerError, code: code);
}

/// Unknown network error.
final class UnknownNetworkFailure extends NetworkFailure {
  /// Original error message.
  final String? originalMessage;

  /// Creates an instance of [UnknownNetworkFailure].
  const UnknownNetworkFailure({
    String code = 'unknown_network',
    this.originalMessage,
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.networkUnknown, code: code);
}
