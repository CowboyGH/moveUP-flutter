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

/// No network connection error.
final class AuthNoNetworkFailure extends AuthFailure {
  /// Creates an instance of [AuthNoNetworkFailure].
  const AuthNoNetworkFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Проверьте подключение к интернету и попробуйте снова');
}

/// Request timeout error.
final class AuthConnectionTimeoutFailure extends AuthFailure {
  /// Creates an instance of [AuthConnectionTimeoutFailure].
  const AuthConnectionTimeoutFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Сервер не отвечает. Попробуйте позже');
}

/// Server error for auth requests.
final class AuthServerErrorFailure extends AuthFailure {
  /// Creates an instance of [AuthServerErrorFailure].
  const AuthServerErrorFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Ошибка сервера. Попробуйте позже');
}

/// Invalid credentials error.
final class InvalidCredentialsFailure extends AuthFailure {
  /// Creates an instance of [InvalidCredentialsFailure].
  const InvalidCredentialsFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Неверные учетные данные');
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
  }) : super('Проверьте введенные данные и попробуйте снова');
}

/// Email already verified error.
final class EmailAlreadyVerifiedFailure extends AuthFailure {
  /// Creates an instance of [EmailAlreadyVerifiedFailure].
  const EmailAlreadyVerifiedFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Email уже подтвержден. Войдите в аккаунт');
}

/// Email not verified error.
final class EmailNotVerifiedFailure extends AuthFailure {
  /// Creates an instance of [EmailNotVerifiedFailure].
  const EmailNotVerifiedFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Подтвердите email, чтобы продолжить');
}

/// Auth Rate limited error.
final class AuthRateLimitedFailure extends AuthFailure {
  /// Creates an instance of [AuthRateLimitedFailure].
  const AuthRateLimitedFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Слишком много попыток. Попробуйте позже');
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
  /// Optional error code from backend for diagnostics.
  final String? code;

  /// Original error message.
  final String? originalMessage;

  /// Creates an instance of [UnknownAuthFailure].
  const UnknownAuthFailure({
    this.code,
    this.originalMessage,
    super.parentException,
    super.stackTrace,
  }) : super(originalMessage ?? 'Не удалось выполнить действие. Попробуйте снова');
}
