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
