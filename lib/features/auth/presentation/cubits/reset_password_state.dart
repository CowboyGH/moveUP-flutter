part of 'reset_password_cubit.dart';

/// States for [ResetPasswordCubit].
@freezed
class ResetPasswordState with _$ResetPasswordState {
  /// Initial idle state before any reset-password attempt.
  const factory ResetPasswordState.initial() = _Initial;

  /// State emitted when reset-password succeeds.
  const factory ResetPasswordState.succeed() = _Succeed;

  /// State emitted when reset-password fails.
  const factory ResetPasswordState.failed(AuthFailure failure) = _Failed;

  /// State emitted while reset-password request is in progress.
  const factory ResetPasswordState.inProgress() = _InProgress;
}
