part of 'change_password_cubit.dart';

/// States for [ChangePasswordCubit].
@freezed
class ChangePasswordState with _$ChangePasswordState {
  /// Initial idle state.
  const factory ChangePasswordState.initial() = _Initial;

  /// Submit is in progress.
  const factory ChangePasswordState.inProgress() = _InProgress;

  /// Password change succeeded.
  const factory ChangePasswordState.succeed() = _Succeed;

  /// Password change failed.
  const factory ChangePasswordState.failed(ProfileFailure failure) = _Failed;
}
