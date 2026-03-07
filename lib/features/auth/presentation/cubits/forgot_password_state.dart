part of 'forgot_password_cubit.dart';

/// States for [ForgotPasswordCubit].
@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  /// Initial idle state before any forgot-password attempt.
  const factory ForgotPasswordState.initial() = _Initial;

  /// State emitted when forgot-password request succeeds.
  const factory ForgotPasswordState.succeed() = _Succeed;

  /// State emitted when forgot-password request fails.
  const factory ForgotPasswordState.failed(AuthFailure failure) = _Failed;

  /// State emitted while forgot-password request is in progress.
  const factory ForgotPasswordState.inProgress() = _InProgress;
}
