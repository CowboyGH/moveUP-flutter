import 'package:json_annotation/json_annotation.dart';

part 'workout_execution_exercise_item_dto.g.dart';

/// DTO for a workout execution exercise step.
@JsonSerializable(createToJson: false)
class WorkoutExecutionExerciseItemDto {
  /// Exercise identifier.
  final int id;

  /// Exercise title.
  final String title;

  /// Exercise description.
  final String description;

  /// Exercise image path or URL.
  final String? image;

  /// Planned sets count.
  final int sets;

  /// Recommended repetitions count.
  final int reps;

  /// Current exercise weight for the user.
  @JsonKey(name: 'current_weight')
  final double? currentWeight;

  /// Creates an instance of [WorkoutExecutionExerciseItemDto].
  WorkoutExecutionExerciseItemDto({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.sets,
    required this.reps,
    required this.currentWeight,
  });

  /// Creates a [WorkoutExecutionExerciseItemDto] from JSON.
  factory WorkoutExecutionExerciseItemDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExecutionExerciseItemDtoFromJson(json);
}
