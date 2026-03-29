part of 'update_profile_cubit.dart';

/// States for [UpdateProfileCubit].
@freezed
class UpdateProfileState with _$UpdateProfileState {
  /// Initial idle state.
  const factory UpdateProfileState.initial() = _Initial;

  /// Submit is in progress.
  const factory UpdateProfileState.inProgress() = _InProgress;

  /// Submit succeeded with a refreshed canonical user payload.
  const factory UpdateProfileState.succeed(User user) = _Succeed;

  /// Submit failed with a profile error.
  const factory UpdateProfileState.failed(ProfileFailure failure) = _Failed;
}
