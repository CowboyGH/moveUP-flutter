part of 'logout_cubit.dart';

/// States for [LogoutCubit].
@freezed
class LogoutState with _$LogoutState {
  /// Initial idle state before any logout attempt.
  const factory LogoutState.initial() = _Initial;

  /// State emitted when logout succeeds.
  const factory LogoutState.succeed() = _Succeed;

  /// State emitted when logout fails.
  const factory LogoutState.failed(AuthFailure failure) = _Failed;

  /// State emitted while logout request is in progress.
  const factory LogoutState.inProgress() = _InProgress;
}
