import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/profile_parameters/profile_parameters_data.dart';
import '../../domain/entities/profile_parameters/profile_parameters_gender.dart';
import '../../domain/entities/profile_parameters/profile_parameters_references.dart';
import '../../domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import '../../domain/entities/profile_parameters/profile_parameters_submit_payload.dart';
import '../../domain/repositories/profile_parameters_repository.dart';

part 'profile_parameters_cubit.freezed.dart';
part 'profile_parameters_state.dart';

/// Cubit that manages the editable profile parameters section.
final class ProfileParametersCubit extends Cubit<ProfileParametersState> {
  final ProfileParametersRepository _repository;

  /// Creates an instance of [ProfileParametersCubit].
  ProfileParametersCubit(this._repository) : super(const ProfileParametersState());

  /// Stores bootstrap snapshot values from `/profile`.
  void setBootstrapSnapshot(ProfileParametersSnapshot? snapshot) {
    if (isClosed || state.bootstrapSnapshot == snapshot) return;

    emit(
      state.copyWith(
        bootstrapSnapshot: snapshot,
        selectedGender: state.selectedGender ?? state.currentParameters?.gender ?? snapshot?.gender,
      ),
    );
  }

  /// Loads references and canonical current parameters.
  Future<void> loadInitial() async {
    await _load(force: false);
  }

  /// Reloads the full parameters form state.
  Future<void> reload() async {
    await _load(force: true);
  }

  /// Selects the current training goal.
  void selectGoal(int goalId) {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        selectedGoalId: goalId,
        failure: null,
      ),
    );
  }

  /// Selects the current gender value.
  void selectGender(ProfileParametersGender gender) {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        selectedGender: gender,
        failure: null,
      ),
    );
  }

  /// Selects the current equipment option.
  void selectEquipment(int equipmentId) {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        selectedEquipmentId: equipmentId,
        failure: null,
      ),
    );
  }

  /// Selects the current preparation level.
  void selectLevel(int levelId) {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        selectedLevelId: levelId,
        failure: null,
      ),
    );
  }

  /// Clears the current failure after it was handled by the UI.
  void clearFailure() {
    emit(state.copyWith(failure: null));
  }

  /// Resets the pending workouts reload request after the UI handled it.
  void consumeWorkoutsReloadRequest() {
    if (!state.shouldReloadWorkouts) return;
    emit(state.copyWith(shouldReloadWorkouts: false));
  }

  /// Saves the profile parameters form and marks workouts for reload when needed.
  Future<void> submit({
    required ProfileParametersSubmitPayload payload,
    required int currentWeeklyGoal,
  }) async {
    final currentParameters = state.currentParameters;
    if (state.isLoading || state.isSubmitting || currentParameters == null) return;
    final hasChanges =
        payload.goalId != currentParameters.goalId ||
        payload.gender != currentParameters.gender ||
        payload.age != currentParameters.age ||
        payload.weight != currentParameters.weight ||
        payload.height != currentParameters.height ||
        payload.equipmentId != currentParameters.equipmentId ||
        payload.levelId != currentParameters.levelId ||
        payload.weeklyGoal != currentWeeklyGoal;
    final shouldReloadWorkouts =
        payload.goalId != currentParameters.goalId ||
        payload.equipmentId != currentParameters.equipmentId ||
        payload.levelId != currentParameters.levelId;
    if (!hasChanges) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        shouldReloadWorkouts: false,
        failure: null,
      ),
    );

    final result = await _repository.saveParameters(
      currentParameters: currentParameters,
      currentWeeklyGoal: currentWeeklyGoal,
      payload: payload,
    );
    if (isClosed) return;

    switch (result) {
      case Success(data: final data):
        emit(
          state.copyWith(
            isSubmitting: false,
            shouldReloadWorkouts: shouldReloadWorkouts,
            currentParameters: data,
            bootstrapSnapshot: _toSnapshot(data),
            selectedGoalId: data.goalId,
            selectedGender: data.gender,
            selectedEquipmentId: data.equipmentId,
            selectedLevelId: data.levelId,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmitting: false,
            shouldReloadWorkouts: false,
            failure: error,
          ),
        );
    }
  }

  Future<void> _load({required bool force}) async {
    final hasLoadedState = state.references != null && state.currentParameters != null;
    if (state.isSubmitting) return;
    if (!force && (state.isLoading || hasLoadedState)) return;

    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
      ),
    );

    final referencesFuture = _repository.getReferences();
    final currentParametersFuture = _repository.getCurrentParameters();

    final referencesResult = await referencesFuture;
    final currentParametersResult = await currentParametersFuture;
    if (isClosed) return;

    final nextReferences = switch (referencesResult) {
      Success(data: final references) => references,
      Failure() => state.references,
    };
    final nextCurrentParameters = switch (currentParametersResult) {
      Success(data: final parameters) => parameters,
      Failure() => state.currentParameters,
    };
    final nextFailure = switch ((referencesResult, currentParametersResult)) {
      (Failure(error: final error), _) => error,
      (_, Failure(error: final error)) => error,
      _ => null,
    };

    emit(
      state.copyWith(
        isLoading: false,
        references: nextReferences,
        currentParameters: nextCurrentParameters,
        bootstrapSnapshot: nextCurrentParameters == null
            ? state.bootstrapSnapshot
            : _toSnapshot(nextCurrentParameters),
        selectedGoalId: nextCurrentParameters?.goalId ?? state.selectedGoalId,
        selectedGender: nextCurrentParameters?.gender ?? state.selectedGender,
        selectedEquipmentId: nextCurrentParameters?.equipmentId ?? state.selectedEquipmentId,
        selectedLevelId: nextCurrentParameters?.levelId ?? state.selectedLevelId,
        failure: nextFailure,
      ),
    );
  }

  ProfileParametersSnapshot _toSnapshot(ProfileParametersData data) => ProfileParametersSnapshot(
    goal: data.goalName,
    gender: data.gender,
    age: data.age,
    weight: data.weight,
    height: data.height,
    equipment: data.equipmentName,
    level: data.levelName,
  );
}
