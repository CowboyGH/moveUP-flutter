part of 'profile_refresh_cubit.dart';

/// State for [ProfileRefreshCubit].
@freezed
abstract class ProfileRefreshState with _$ProfileRefreshState {
  /// Creates an instance of [ProfileRefreshState].
  const factory ProfileRefreshState({
    @Default(false) bool shouldRefresh,
  }) = _ProfileRefreshState;
}
