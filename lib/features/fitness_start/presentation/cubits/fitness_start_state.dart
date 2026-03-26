part of 'fitness_start_cubit.dart';

/// State for [FitnessStartCubit].
@freezed
abstract class FitnessStartState with _$FitnessStartState {
  /// Creates an instance of [FitnessStartState].
  const factory FitnessStartState({
    @Default(false) bool isLoadingReferences,
    @Default(false) bool isSubmitting,
    FitnessStartReferences? references,
    FitnessStartFailure? failure,
    @Default(0) int currentStep,
    int? selectedGoalId,
    FitnessStartGender? selectedGender,
    int? selectedEquipmentId,
    int? selectedLevelId,
    @Default(false) bool isCompleted,
  }) = _FitnessStartState;
}
