/// Typed route args for the verify-email screen.
final class VerifyEmailRouteArgs {
  /// User email.
  final String email;

  /// Whether the screen should request a fresh code when it opens.
  final bool resendOnOpen;

  /// Creates an instance of [VerifyEmailRouteArgs].
  const VerifyEmailRouteArgs({
    required this.email,
    required this.resendOnOpen,
  });
}
