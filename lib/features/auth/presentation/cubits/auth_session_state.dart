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

  /// Session restore failed but the persisted session was not invalidated.
  const factory AuthSessionState.restoreFailed() = _RestoreFailed;

  /// Guest has completed onboarding and can reuse the saved data or restart.
  const factory AuthSessionState.guestResumeAvailable() = _GuestResumeAvailable;

  /// User is in guest onboarding mode.
  const factory AuthSessionState.guest() = _Guest;

  /// Guest has completed onboarding and should continue to registration.
  const factory AuthSessionState.guestCompletedOnboarding() = _GuestCompletedOnboarding;

  /// User is authenticated.
  const factory AuthSessionState.authenticated(User user) = _Authenticated;
}
