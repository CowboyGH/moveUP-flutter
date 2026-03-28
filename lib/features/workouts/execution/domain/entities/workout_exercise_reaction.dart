/// User reaction values supported by workout execution.
enum WorkoutExerciseReaction {
  /// Exercise felt bad.
  bad,

  /// Exercise felt normal.
  normal,

  /// Exercise felt good.
  good,
}

/// Maps [WorkoutExerciseReaction] into backend request values.
extension WorkoutExerciseReactionRequestValue on WorkoutExerciseReaction {
  /// Returns the backend request value for the selected reaction.
  String get requestValue => switch (this) {
    WorkoutExerciseReaction.bad => 'bad',
    WorkoutExerciseReaction.normal => 'normal',
    WorkoutExerciseReaction.good => 'good',
  };
}
