part of 'profile_phase_cubit.dart';

/// State for [ProfilePhaseCubit].
@freezed
abstract class ProfilePhaseState with _$ProfilePhaseState {
  /// Creates an instance of [ProfilePhaseState].
  const factory ProfilePhaseState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingSummary,
    ProfilePhaseSnapshot? phaseSnapshot,
    ProfileCurrentPhaseSummary? currentPhaseSummary,
    ProfileFailure? phaseFailure,
    ProfileFailure? summaryFailure,
  }) = _ProfilePhaseState;
}
