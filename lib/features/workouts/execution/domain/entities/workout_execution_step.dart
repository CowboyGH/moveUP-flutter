import 'package:equatable/equatable.dart';

/// Base entity for workout execution steps.
sealed class WorkoutExecutionStep extends Equatable {
  /// Step identifier.
  final int id;

  /// Creates an instance of [WorkoutExecutionStep].
  const WorkoutExecutionStep({required this.id});
}

/// Warmup execution step.
final class WorkoutWarmupStep extends WorkoutExecutionStep {
  /// Warmup title.
  final String name;

  /// Warmup description.
  final String description;

  /// Normalized warmup image URL.
  final String imageUrl;

  /// Warmup duration in seconds.
  final int durationSeconds;

  /// Whether this is the last warmup in the flow.
  final bool isLast;

  /// Creates an instance of [WorkoutWarmupStep].
  const WorkoutWarmupStep({
    required super.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.durationSeconds,
    required this.isLast,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    durationSeconds,
    isLast,
  ];
}

/// Main workout execution step.
final class WorkoutExerciseStep extends WorkoutExecutionStep {
  /// Exercise title.
  final String title;

  /// Exercise description.
  final String description;

  /// Normalized exercise image URL.
  final String imageUrl;

  /// Planned sets.
  final int sets;

  /// Planned repetitions.
  final int reps;

  /// Current user weight for this exercise.
  final double? currentWeight;

  /// Whether backend expects explicit weight input.
  final bool needsWeightInput;

  /// Creates an instance of [WorkoutExerciseStep].
  const WorkoutExerciseStep({
    required super.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sets,
    required this.reps,
    required this.currentWeight,
    required this.needsWeightInput,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    sets,
    reps,
    currentWeight,
    needsWeightInput,
  ];
}
