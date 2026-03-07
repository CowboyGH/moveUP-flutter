part of 'verify_reset_code_cubit.dart';

/// States for [VerifyResetCodeCubit].
@freezed
class VerifyResetCodeState with _$VerifyResetCodeState {
  /// Initial idle state before any verify-reset-code attempt.
  const factory VerifyResetCodeState.initial() = _Initial;

  /// State emitted when verify-reset-code succeeds.
  const factory VerifyResetCodeState.succeed() = _Succeed;

  /// State emitted when verify-reset-code fails.
  const factory VerifyResetCodeState.failed(AuthFailure failure) = _Failed;

  /// State emitted while verify-reset-code request is in progress.
  const factory VerifyResetCodeState.inProgress() = _InProgress;
}
