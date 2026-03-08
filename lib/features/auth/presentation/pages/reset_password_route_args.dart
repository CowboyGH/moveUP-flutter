/// Typed route args for the reset-password screen.
final class ResetPasswordRouteArgs {
  /// User email.
  final String email;

  /// Verified reset code.
  final String code;

  /// Creates an instance of [ResetPasswordRouteArgs].
  const ResetPasswordRouteArgs({
    required this.email,
    required this.code,
  });
}
