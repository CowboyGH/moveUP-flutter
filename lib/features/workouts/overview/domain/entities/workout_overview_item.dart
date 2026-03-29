import 'package:equatable/equatable.dart';

/// Workout item displayed on the workouts overview screen.
final class WorkoutOverviewItem extends Equatable {
  /// User workout identifier.
  final int userWorkoutId;

  /// Whether this workout is already started and should be continued.
  final bool isStarted;

  /// Whether a different active workout blocks starting this one.
  final bool isBlockedByActiveWorkout;

  /// Workout title.
  final String title;

  /// Workout description.
  final String description;

  /// Workout duration in minutes.
  final int durationMinutes;

  /// Normalized image URL.
  final String imageUrl;

  /// Creates an instance of [WorkoutOverviewItem].
  const WorkoutOverviewItem({
    required this.userWorkoutId,
    required this.isStarted,
    required this.isBlockedByActiveWorkout,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    userWorkoutId,
    isStarted,
    isBlockedByActiveWorkout,
    title,
    description,
    durationMinutes,
    imageUrl,
  ];
}
