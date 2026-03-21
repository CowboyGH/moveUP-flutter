part of 'test_attempt_cubit.dart';

/// State for [TestAttemptCubit].
@freezed
abstract class TestAttemptState with _$TestAttemptState {
  /// Creates an instance of [TestAttemptState].
  const factory TestAttemptState({
    @Default(false) bool isStarting,
    @Default(false) bool isSubmittingResult,
    @Default(false) bool isCompleting,
    String? attemptId,
    TestAttemptTesting? testing,
    TestingExercise? currentExercise,
    @Default(0) int currentExerciseOrderNumber,
    TestsFailure? failure,
    @Default(false) bool isAwaitingPulse,
    @Default(false) bool isCompleted,
    CompletedTestAttempt? completedAttempt,
  }) = _TestAttemptState;
}
