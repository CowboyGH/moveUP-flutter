part of 'profile_parameters_cubit.dart';

/// State for [ProfileParametersCubit].
@freezed
abstract class ProfileParametersState with _$ProfileParametersState {
  /// Creates an instance of [ProfileParametersState].
  const factory ProfileParametersState({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool shouldReloadWorkouts,
    ProfileParametersSnapshot? bootstrapSnapshot,
    ProfileParametersReferences? references,
    ProfileParametersData? currentParameters,
    int? selectedGoalId,
    ProfileParametersGender? selectedGender,
    int? selectedEquipmentId,
    int? selectedLevelId,
    ProfileFailure? failure,
  }) = _ProfileParametersState;
}
