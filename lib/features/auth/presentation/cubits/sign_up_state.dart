part of 'sign_up_cubit.dart';

/// States for [SignUpCubit].
@freezed
class SignUpState with _$SignUpState {
  /// Initial idle state before any register attempt.
  const factory SignUpState.initial() = _Initial;

  /// State emitted when sign-up succeeds.
  const factory SignUpState.succeed(User user) = _Succeed;

  /// State emitted when sign-up fails.
  const factory SignUpState.failed(AuthFailure failure) = _Failed;

  /// State emitted while sign-up request is in progress.
  const factory SignUpState.inProgress() = _InProgress;
}
