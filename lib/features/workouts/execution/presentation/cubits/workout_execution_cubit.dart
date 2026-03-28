import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/workout_execution_entry_mode.dart';
import '../../domain/entities/workout_execution_result.dart';
import '../../domain/entities/workout_execution_step.dart';
import '../../domain/entities/workout_exercise_reaction.dart';
import '../../domain/repositories/workout_execution_repository.dart';

part 'workout_execution_cubit.freezed.dart';
part 'workout_execution_state.dart';

/// Cubit that manages the authenticated workout execution flow.
final class WorkoutExecutionCubit extends Cubit<WorkoutExecutionState> {
  final WorkoutExecutionRepository _repository;
  WorkoutLoadAdjustment? _pendingAdjustment;

  /// Creates an instance of [WorkoutExecutionCubit].
  WorkoutExecutionCubit(this._repository) : super(const WorkoutExecutionState());

  bool get _isBusy =>
      state.isStarting || state.isAdvancingWarmup || state.isSubmittingResult || state.isCompleting;

  /// Starts workout execution for the given [userWorkoutId] and [entryMode].
  Future<void> startExecution(
    int userWorkoutId,
    WorkoutExecutionEntryMode entryMode,
  ) async {
    if (_isBusy) return;

    emit(
      state.copyWith(
        isStarting: true,
        isAdvancingWarmup: false,
        isSubmittingResult: false,
        isCompleting: false,
        userWorkoutId: userWorkoutId,
        currentStep: null,
        failure: null,
        isCompleted: false,
        shouldPopToDetails: false,
      ),
    );
    _pendingAdjustment = null;

    final result = await _repository.startExecution(
      userWorkoutId: userWorkoutId,
      entryMode: entryMode,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isStarting: false,
            userWorkoutId: data.userWorkoutId,
            currentStep: data.currentStep,
            failure: null,
            isCompleted: false,
            shouldPopToDetails: false,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isStarting: false,
            failure: error,
          ),
        );
    }
  }

  /// Loads the next warmup step or the first workout exercise.
  Future<void> nextWarmup() async {
    final userWorkoutId = state.userWorkoutId;
    final currentStep = state.currentStep;
    if (_isBusy ||
        state.isCompleted ||
        userWorkoutId == null ||
        currentStep is! WorkoutWarmupStep) {
      return;
    }

    emit(
      state.copyWith(
        isAdvancingWarmup: true,
        failure: null,
      ),
    );

    final result = await _repository.nextWarmup(
      userWorkoutId: userWorkoutId,
      currentWarmupId: currentStep.id,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            currentStep: data,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            failure: error,
          ),
        );
    }
  }

  /// Completes warmup early and moves to the first exercise.
  Future<void> skipWarmup() async {
    final userWorkoutId = state.userWorkoutId;
    final currentStep = state.currentStep;
    if (_isBusy ||
        state.isCompleted ||
        userWorkoutId == null ||
        currentStep is! WorkoutWarmupStep) {
      return;
    }

    emit(
      state.copyWith(
        isAdvancingWarmup: true,
        failure: null,
      ),
    );

    final result = await _repository.skipWarmup(userWorkoutId);
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            currentStep: data,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            failure: error,
          ),
        );
    }
  }

  /// Completes warmup early and requests the page to return to details.
  Future<void> exitWarmupToDetails() async {
    final userWorkoutId = state.userWorkoutId;
    final currentStep = state.currentStep;
    if (_isBusy ||
        state.isCompleted ||
        userWorkoutId == null ||
        currentStep is! WorkoutWarmupStep) {
      return;
    }

    emit(
      state.copyWith(
        isAdvancingWarmup: true,
        failure: null,
      ),
    );

    final result = await _repository.skipWarmup(userWorkoutId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            failure: null,
            shouldPopToDetails: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isAdvancingWarmup: false,
            failure: error,
          ),
        );
    }
  }

  /// Submits a reaction for the current workout exercise.
  Future<void> submitReaction(
    WorkoutExerciseReaction reaction, {
    double? weightUsed,
  }) async {
    final userWorkoutId = state.userWorkoutId;
    final currentStep = state.currentStep;
    if (_isBusy ||
        state.isCompleted ||
        userWorkoutId == null ||
        currentStep is! WorkoutExerciseStep) {
      return;
    }

    emit(
      state.copyWith(
        isSubmittingResult: true,
        failure: null,
      ),
    );

    final result = await _repository.saveExerciseResult(
      userWorkoutId: userWorkoutId,
      exerciseId: currentStep.id,
      reaction: reaction,
      weightUsed: weightUsed,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        _pendingAdjustment = data.adjustment;
        if (data.isAwaitingCompletion) {
          emit(
            state.copyWith(
              isSubmittingResult: false,
              failure: null,
            ),
          );
          await completeWorkout();
          return;
        }

        emit(
          state.copyWith(
            isSubmittingResult: false,
            currentStep: data.nextExercise,
            failure: null,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmittingResult: false,
            failure: error,
          ),
        );
    }
  }

  /// Completes the current workout.
  Future<void> completeWorkout() async {
    final userWorkoutId = state.userWorkoutId;
    if (_isBusy || state.isCompleted || userWorkoutId == null) return;

    emit(
      state.copyWith(
        isCompleting: true,
        failure: null,
      ),
    );

    final result = await _repository.completeWorkout(userWorkoutId);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isCompleting: false,
            failure: null,
            isCompleted: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isCompleting: false,
            failure: error,
          ),
        );
    }
  }

  /// Clears the current failure after the UI handles it.
  void clearFailure() {
    emit(state.copyWith(failure: null));
  }

  /// Clears the flag that asks the UI to pop back to details.
  void clearPopToDetails() {
    emit(state.copyWith(shouldPopToDetails: false));
  }

  /// Consumes the latest load adjustment that should be shown in UI once.
  WorkoutLoadAdjustment? consumePendingAdjustment() {
    final adjustment = _pendingAdjustment;
    _pendingAdjustment = null;
    return adjustment;
  }
}
