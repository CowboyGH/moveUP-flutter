import 'package:equatable/equatable.dart';

/// Single-select option for the profile statistics workout selector.
final class ProfileWorkoutOption extends Equatable {
  /// Workout selector identifier.
  final int id;

  /// Workout title.
  final String title;

  /// Optional formatted completion date.
  final String? completedAtFormatted;

  /// Creates an instance of [ProfileWorkoutOption].
  const ProfileWorkoutOption({
    required this.id,
    required this.title,
    required this.completedAtFormatted,
  });

  @override
  List<Object?> get props => [id, title, completedAtFormatted];
}
