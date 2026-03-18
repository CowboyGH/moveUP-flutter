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

  /// User is in guest onboarding mode.
  const factory AuthSessionState.guest(FitnessStartStage stage) = _Guest;

  /// User is authenticated and currently inside onboarding.
  const factory AuthSessionState.authenticatedOnboarding(
    User user,
    FitnessStartStage stage,
  ) = _AuthenticatedOnboarding;

  /// User is authenticated.
  const factory AuthSessionState.authenticated(User user) = _Authenticated;
}
