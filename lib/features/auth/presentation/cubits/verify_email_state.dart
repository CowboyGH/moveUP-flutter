part of 'verify_email_cubit.dart';

/// States for [VerifyEmailCubit].
@freezed
class VerifyEmailState with _$VerifyEmailState {
  /// Initial idle state before any verify-email attempt.
  const factory VerifyEmailState.initial() = _Initial;

  /// State emitted when verify-email succeeds.
  const factory VerifyEmailState.succeed(User user) = _Succeed;

  /// State emitted when verify-email fails.
  const factory VerifyEmailState.failed(AuthFailure failure) = _Failed;

  /// State emitted while verify-email request is in progress.
  const factory VerifyEmailState.inProgress() = _InProgress;
}
