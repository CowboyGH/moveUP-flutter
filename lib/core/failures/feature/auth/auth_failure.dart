import '../../app_failure.dart';

/// Auth application error.
sealed class AuthFailure extends AppFailure {
  /// Error code.
  abstract final String code;

  /// Creates an instance of [AuthFailure].
  const AuthFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Invalid credential error.
final class InvalidCredentialFailure extends AuthFailure {
  @override
  String get code => 'invalid-credential';

  /// Creates an instance of [InvalidCredentialFailure].
  const InvalidCredentialFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Weak password error.
final class WeakPasswordFailure extends AuthFailure {
  @override
  String get code => 'weak-password';

  /// Creates an instance of [WeakPasswordFailure].
  const WeakPasswordFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Wrong password error.
final class WrongPasswordFailure extends AuthFailure {
  @override
  String get code => 'wrong-password';

  /// Creates an instance of [WrongPasswordFailure].
  const WrongPasswordFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Invalid email error.
final class InvalidEmailFailure extends AuthFailure {
  @override
  String get code => 'invalid-email';

  /// Creates an instance of [InvalidEmailFailure].
  const InvalidEmailFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Email already in use error.
final class EmailAlreadyInUseFailure extends AuthFailure {
  @override
  String get code => 'email-already-in-use';

  /// Creates an instance of [EmailAlreadyInUseFailure].
  const EmailAlreadyInUseFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// User disabled error.
final class UserDisabledFailure extends AuthFailure {
  @override
  String get code => 'user-disabled';

  /// Creates an instance of [UserDisabledFailure].
  const UserDisabledFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// User token expired error.
final class UserTokenExpiredFailure extends AuthFailure {
  @override
  String get code => 'user-token-expired';

  /// Creates an instance of [UserTokenExpiredFailure].
  const UserTokenExpiredFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// User not found error.
final class UserNotFoundFailure extends AuthFailure {
  @override
  String get code => 'user-not-found';

  /// Creates an instance of [UserNotFoundFailure].
  const UserNotFoundFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Operation not allowed error.
final class OperationNotAllowed extends AuthFailure {
  @override
  String get code => 'operation-not-allowed';

  /// Creates an instance of [OperationNotAllowed].
  const OperationNotAllowed({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Too many requests error.
final class TooManyRequestsFailure extends AuthFailure {
  @override
  String get code => 'too-many-requests';

  /// Creates an instance of [TooManyRequestsFailure].
  const TooManyRequestsFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Network request failed error.
final class NetworkRequestFailedFailure extends AuthFailure {
  @override
  String get code => 'network-request-failed';

  /// Creates an instance of [NetworkRequestFailedFailure].
  const NetworkRequestFailedFailure({
    super.parentException,
    super.stackTrace,
  }) : super('');
}

/// Operation cancelled error.
final class OperationCancelledFailure extends AuthFailure {
  @override
  String get code => 'canceled';

  /// Creates an instance of [OperationCancelledFailure].
  const OperationCancelledFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// Operation interrupted error.
final class OperationInterruptedFailure extends AuthFailure {
  @override
  String get code => 'interrupted';

  /// Creates an instance of [OperationInterruptedFailure].
  const OperationInterruptedFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// Client configuration error.
final class ClientConfigurationFailure extends AuthFailure {
  @override
  String get code => 'clientConfigurationError';

  /// Creates an instance of [ClientConfigurationFailure].
  const ClientConfigurationFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// Provider configuration error.
final class ProviderConfigurationFailure extends AuthFailure {
  @override
  String get code => 'providerConfigurationError';

  /// Creates an instance of [ProviderConfigurationFailure].
  const ProviderConfigurationFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// UI unavailable error.
final class UIUnavailableFailure extends AuthFailure {
  @override
  String get code => 'uiUnavailable';

  /// Creates an instance of [UIUnavailableFailure].
  const UIUnavailableFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// Operation cancelled error.
final class UserMismatchFailure extends AuthFailure {
  @override
  String get code => 'userMismatch';

  /// Creates an instance of [UserMismatchFailure].
  const UserMismatchFailure({
    super.stackTrace,
    super.parentException,
  }) : super('');
}

/// Unknown authentication error.
final class UnknownAuthFailure extends AuthFailure {
  @override
  final String code;

  /// Original error message.
  final String? originalMessage;

  /// Creates an instance of [UnknownAuthFailure].
  const UnknownAuthFailure(
    this.code, {
    this.originalMessage,
    super.parentException,
    super.stackTrace,
  }) : super(originalMessage ?? 'Unknown authentication error');
}
