part of 'auth_bloc.dart';

/// State class for authentication status.
@freezed
class AuthState with _$AuthState {
  /// Initial state of authentication.
  const factory AuthState.initial() = _Initial;

  /// State indicating that authentication is in progress.
  const factory AuthState.operationInProgress() = _AuthInProgress;

  /// State indicating that the user is authenticated.
  const factory AuthState.authenticated(User user) = _Authenticated;

  /// State indicating that the user is unauthenticated.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// State indicating an authentication error.
  const factory AuthState.authError(AuthFailure failure) = _AuthError;
}
