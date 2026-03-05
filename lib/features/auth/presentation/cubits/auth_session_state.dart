part of 'auth_session_cubit.dart';

/// States for [AuthSessionCubit].
@freezed
class AuthSessionState with _$AuthSessionState {
  /// Initial state before session check.
  const factory AuthSessionState.initial() = _Initial;

  /// Session check in progress.
  const factory AuthSessionState.checking() = _Checking;

  /// User is not authenticated.
  const factory AuthSessionState.unauthenticated() = _Unauthenticated;

  /// User is in guest mode.
  const factory AuthSessionState.guest() = _Guest;

  /// User is authenticated.
  const factory AuthSessionState.authenticated(User user) = _Authenticated;
}
