import 'package:equatable/equatable.dart';

/// Workout item displayed on the workouts overview screen.
final class WorkoutOverviewItem extends Equatable {
  /// User workout identifier.
  final int userWorkoutId;

  /// Workout template identifier.
  final int workoutId;

  /// Workout title.
  final String title;

  /// Workout description.
  final String description;

  /// Workout duration in minutes.
  final int durationMinutes;

  /// Normalized image URL.
  final String imageUrl;

  /// Backend workout status.
  final String status;

  /// Creates an instance of [WorkoutOverviewItem].
  const WorkoutOverviewItem({
    required this.userWorkoutId,
    required this.workoutId,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    required this.status,
  });

  @override
  List<Object?> get props => [
    userWorkoutId,
    workoutId,
    title,
    description,
    durationMinutes,
    imageUrl,
    status,
  ];
}
