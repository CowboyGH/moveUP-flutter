part of 'profile_user_cubit.dart';

/// State for [ProfileUserCubit].
@freezed
abstract class ProfileUserState with _$ProfileUserState {
  /// Creates an instance of [ProfileUserState].
  const factory ProfileUserState({
    @Default(false) bool isLoading,
    User? user,
    ProfileStatsHistorySnapshot? historySnapshot,
    ProfilePhaseSnapshot? phaseSnapshot,
    ProfileParametersSnapshot? parametersSnapshot,
    ProfileFailure? failure,
  }) = _ProfileUserState;
}
