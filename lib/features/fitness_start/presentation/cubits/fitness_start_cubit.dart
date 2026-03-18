import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/failures/feature/fitness_start/fitness_start_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/fitness_start_gender.dart';
import '../../domain/entities/fitness_start_references.dart';
import '../../domain/repositories/fitness_start_repository.dart';

part 'fitness_start_cubit.freezed.dart';
part 'fitness_start_state.dart';

/// Cubit that manages the Fitness Start quiz flow.
final class FitnessStartCubit extends Cubit<FitnessStartState> {
  final FitnessStartRepository _repository;

  /// Creates an instance of [FitnessStartCubit].
  FitnessStartCubit(this._repository) : super(const FitnessStartState());

  /// Loads references required to render the quiz.
  Future<void> loadReferences() async {
    if (state.references != null || state.isLoadingReferences) return;

    emit(
      state.copyWith(
        isLoadingReferences: true,
        failure: null,
      ),
    );

    final result = await _repository.getReferences();
    if (isClosed) return;

    switch (result) {
      case Success(data: final references):
        emit(
          state.copyWith(
            isLoadingReferences: false,
            references: references,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoadingReferences: false,
            failure: error,
          ),
        );
    }
  }

  /// Selects the goal option for the first step.
  void selectGoal(int goalId) => emit(
    state.copyWith(
      selectedGoalId: goalId,
      failure: null,
    ),
  );

  /// Selects the gender option for the second step.
  void selectGender(FitnessStartGender gender) => emit(
    state.copyWith(
      selectedGender: gender,
      failure: null,
    ),
  );

  /// Selects the equipment option for the second step.
  void selectEquipment(int equipmentId) => emit(
    state.copyWith(
      selectedEquipmentId: equipmentId,
      failure: null,
    ),
  );

  /// Selects the level option for the third step.
  void selectLevel(int levelId) => emit(
    state.copyWith(
      selectedLevelId: levelId,
      failure: null,
    ),
  );

  /// Moves the quiz to the previous step.
  void previousStep() {
    if (state.isSubmitting || state.currentStep == 0) return;

    emit(
      state.copyWith(
        currentStep: state.currentStep - 1,
        failure: null,
      ),
    );
  }

  /// Clears the current failure after it was handled by the UI.
  void clearFailure() {
    emit(state.copyWith(failure: null));
  }

  /// Submits the selected goal.
  Future<void> submitGoal() async {
    final selectedGoalId = state.selectedGoalId;
    if (state.isSubmitting || selectedGoalId == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        failure: null,
      ),
    );

    final result = await _repository.saveGoal(selectedGoalId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isSubmitting: false,
            currentStep: 1,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: error,
          ),
        );
    }
  }

  /// Submits anthropometry data.
  Future<void> submitAnthropometry({
    required int age,
    required double weight,
    required int height,
  }) async {
    final selectedGender = state.selectedGender;
    final selectedEquipmentId = state.selectedEquipmentId;
    if (state.isSubmitting || selectedGender == null || selectedEquipmentId == null) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        failure: null,
      ),
    );

    final result = await _repository.saveAnthropometry(
      gender: selectedGender,
      age: age,
      weight: weight,
      height: height,
      equipmentId: selectedEquipmentId,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isSubmitting: false,
            currentStep: 2,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: error,
          ),
        );
    }
  }

  /// Submits the selected preparation level.
  Future<void> submitLevel() async {
    final selectedLevelId = state.selectedLevelId;
    if (state.isSubmitting || selectedLevelId == null) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        failure: null,
      ),
    );

    final result = await _repository.saveLevel(selectedLevelId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isSubmitting: false,
            isCompleted: true,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: error,
          ),
        );
    }
  }
}
