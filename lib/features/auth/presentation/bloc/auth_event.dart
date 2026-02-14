part of 'auth_bloc.dart';

/// Event class for authentication actions.
@freezed
class AuthEvent with _$AuthEvent {
  /// Event to indicate a change in authentication state.
  const factory AuthEvent.authStateChanged(User? user) = _AuthStateChanged;

  /// Event to request sign-in.
  const factory AuthEvent.signInRequested(String email, String password) = _SignInRequested;

  /// Event to request sign-up.
  const factory AuthEvent.signUpRequested(String email, String password) = _SignUpRequested;

  /// Event to request google sign-in.
  const factory AuthEvent.signInWithGoogleRequested() = _SignInWithGoogleRequested;

  /// Event to request sign-out.
  const factory AuthEvent.signOutRequested() = _SignOutRequested;
}
