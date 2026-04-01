part of 'delete_profile_cubit.dart';

/// States for [DeleteProfileCubit].
@freezed
class DeleteProfileState with _$DeleteProfileState {
  /// Initial idle state.
  const factory DeleteProfileState.initial() = _Initial;

  /// Delete request is in progress.
  const factory DeleteProfileState.inProgress() = _InProgress;

  /// Profile deletion succeeded.
  const factory DeleteProfileState.succeed() = _Succeed;

  /// Profile deletion failed.
  const factory DeleteProfileState.failed(ProfileFailure failure) = _Failed;
}
