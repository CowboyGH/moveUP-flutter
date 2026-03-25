import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/test_attempt_testing.dart';
import '../../domain/entities/testing_exercise.dart';
import '../../domain/repositories/test_attempt_repository.dart';

part 'test_attempt_cubit.freezed.dart';
part 'test_attempt_state.dart';

/// Cubit that manages guest test attempt start, progress, and completion.
final class TestAttemptCubit extends Cubit<TestAttemptState> {
  final TestAttemptRepository _repository;

  /// Creates an instance of [TestAttemptCubit].
  TestAttemptCubit(this._repository) : super(const TestAttemptState());

  bool get _isBusy => state.isStarting || state.isSubmittingResult || state.isCompleting;

  /// Starts a test attempt for the given [testingId].
  Future<void> startTest(int testingId) async {
    if (_isBusy) return;

    emit(
      state.copyWith(
        isStarting: true,
        isSubmittingResult: false,
        isCompleting: false,
        attemptId: null,
        testing: null,
        currentExercise: null,
        failure: null,
        isAwaitingPulse: false,
        isCompleted: false,
      ),
    );

    final result = await _repository.startTest(testingId);
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            isStarting: false,
            attemptId: data.attemptId,
            testing: data.testing,
            currentExercise: data.currentExercise,
            failure: null,
            isAwaitingPulse: false,
            isCompleted: false,
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

  /// Saves the current exercise result with a discrete [resultValue] from 1 to 4.
  Future<void> submitResult(int resultValue) async {
    final attemptId = state.attemptId;
    final currentExercise = state.currentExercise;
    if (_isBusy || state.isCompleted || attemptId == null || currentExercise == null) return;
    if (state.isAwaitingPulse) return;

    emit(
      state.copyWith(
        isSubmittingResult: true,
        failure: null,
      ),
    );

    final result = await _repository.saveResult(
      attemptId: attemptId,
      testingExerciseId: currentExercise.id,
      resultValue: resultValue,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final nextExercise = data.nextExercise;
        final exerciseForState = data.isAwaitingPulse ? currentExercise : nextExercise;
        emit(
          state.copyWith(
            isSubmittingResult: false,
            currentExercise: exerciseForState,
            failure: null,
            isAwaitingPulse: data.isAwaitingPulse,
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

  /// Completes the current attempt with the provided [pulse] value.
  Future<void> submitPulse(int pulse) async {
    final attemptId = state.attemptId;
    if (_isBusy || attemptId == null || !state.isAwaitingPulse) return;

    emit(
      state.copyWith(
        isCompleting: true,
        failure: null,
      ),
    );

    final result = await _repository.completeTest(
      attemptId: attemptId,
      pulse: pulse,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isCompleting: false,
            failure: null,
            isAwaitingPulse: false,
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

  /// Clears the current [TestsFailure] after it was handled by the UI.
  void clearFailure() {
    emit(state.copyWith(failure: null));
  }
}
