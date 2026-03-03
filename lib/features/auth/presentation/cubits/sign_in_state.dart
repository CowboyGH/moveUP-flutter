part of 'sign_in_cubit.dart';

/// States for [SignInCubit].
@freezed
class SignInState with _$SignInState {
  /// Initial idle state before any login attempt.
  const factory SignInState.initial() = _Initial;

  /// State emitted when sign-in succeeds.
  const factory SignInState.succeed(User user) = _Succeed;

  /// State emitted when sign-in fails.
  const factory SignInState.failed(AuthFailure failure) = _Failed;

  /// State emitted while sign-in request is in progress.
  const factory SignInState.inProgress() = _InProgress;
}
