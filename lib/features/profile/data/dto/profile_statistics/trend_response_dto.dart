import 'package:json_annotation/json_annotation.dart';

part 'trend_response_dto.g.dart';

/// DTO response with profile trend statistics payload.
@JsonSerializable(createToJson: false)
class TrendResponseDto {
  /// Nested statistics payload.
  final TrendStatisticsDto data;

  /// Creates an instance of [TrendResponseDto].
  TrendResponseDto({
    required this.data,
  });

  /// Creates a [TrendResponseDto] from JSON.
  factory TrendResponseDto.fromJson(Map<String, dynamic> json) => _$TrendResponseDtoFromJson(json);
}

/// DTO for trend statistics.
@JsonSerializable(createToJson: false)
class TrendStatisticsDto {
  /// Whether the selected trend contains data.
  @JsonKey(name: 'has_data', defaultValue: false)
  final bool hasData;

  /// Selected workout info.
  final TrendWorkoutInfoDto? workout;

  /// Average trend score.
  @JsonKey(name: 'average_score')
  final double? averageScore;

  /// Average score percent.
  @JsonKey(name: 'average_score_percent')
  final int? averageScorePercent;

  /// Average score label.
  @JsonKey(name: 'average_score_label')
  final String? averageScoreLabel;

  /// Trend chart items.
  @JsonKey(defaultValue: <TrendChartItemDto>[])
  final List<TrendChartItemDto> chart;

  /// Available workouts included in the response payload.
  @JsonKey(name: 'available_workouts', defaultValue: <AvailableWorkoutDto>[])
  final List<AvailableWorkoutDto> availableWorkouts;

  /// Creates an instance of [TrendStatisticsDto].
  TrendStatisticsDto({
    required this.hasData,
    required this.workout,
    required this.averageScore,
    required this.averageScorePercent,
    required this.averageScoreLabel,
    required this.chart,
    required this.availableWorkouts,
  });

  /// Creates a [TrendStatisticsDto] from JSON.
  factory TrendStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$TrendStatisticsDtoFromJson(json);
}

/// DTO with selected workout info inside trend statistics.
@JsonSerializable(createToJson: false)
class TrendWorkoutInfoDto {
  /// Trend item identifier.
  final int id;

  /// Workout catalog identifier.
  @JsonKey(name: 'workout_id')
  final int workoutId;

  /// Workout title.
  final String title;

  /// Raw completed date.
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  /// Formatted completed date.
  @JsonKey(name: 'completed_at_formatted')
  final String? completedAtFormatted;

  /// Workout duration in minutes.
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;

  /// Creates an instance of [TrendWorkoutInfoDto].
  TrendWorkoutInfoDto({
    required this.id,
    required this.workoutId,
    required this.title,
    required this.completedAt,
    required this.completedAtFormatted,
    required this.durationMinutes,
  });

  /// Creates a [TrendWorkoutInfoDto] from JSON.
  factory TrendWorkoutInfoDto.fromJson(Map<String, dynamic> json) =>
      _$TrendWorkoutInfoDtoFromJson(json);
}

/// DTO item for the trend chart.
@JsonSerializable(createToJson: false)
class TrendChartItemDto {
  /// Exercise number inside the workout.
  @JsonKey(name: 'exercise_number')
  final int? exerciseNumber;

  /// Exercise identifier.
  @JsonKey(name: 'exercise_id')
  final int? exerciseId;

  /// Exercise title.
  @JsonKey(name: 'exercise_name')
  final String exerciseName;

  /// User reaction value.
  final String? reaction;

  /// Raw score value.
  final int? score;

  /// Score percent.
  @JsonKey(name: 'score_percent')
  final int? scorePercent;

  /// Score label.
  @JsonKey(name: 'score_label')
  final String? scoreLabel;

  /// Used weight.
  @JsonKey(name: 'weight_used')
  final String? weightUsed;

  /// Completed sets count.
  @JsonKey(name: 'sets_completed')
  final int? setsCompleted;

  /// Completed reps count.
  @JsonKey(name: 'reps_completed')
  final int? repsCompleted;

  /// Planned sets count.
  @JsonKey(name: 'sets_planned')
  final int? setsPlanned;

  /// Planned reps count.
  @JsonKey(name: 'reps_planned')
  final int? repsPlanned;

  /// Creates an instance of [TrendChartItemDto].
  TrendChartItemDto({
    required this.exerciseNumber,
    required this.exerciseId,
    required this.exerciseName,
    required this.reaction,
    required this.score,
    required this.scorePercent,
    required this.scoreLabel,
    required this.weightUsed,
    required this.setsCompleted,
    required this.repsCompleted,
    required this.setsPlanned,
    required this.repsPlanned,
  });

  /// Creates a [TrendChartItemDto] from JSON.
  factory TrendChartItemDto.fromJson(Map<String, dynamic> json) =>
      _$TrendChartItemDtoFromJson(json);
}

/// DTO item describing a selectable workout inside trend statistics.
@JsonSerializable(createToJson: false)
class AvailableWorkoutDto {
  /// Trend item identifier.
  final int id;

  /// Workout title.
  final String title;

  /// Formatted workout date.
  final String? date;

  /// Whether this workout is selected in the backend payload.
  @JsonKey(name: 'is_current', defaultValue: false)
  final bool isCurrent;

  /// Creates an instance of [AvailableWorkoutDto].
  AvailableWorkoutDto({
    required this.id,
    required this.title,
    required this.date,
    required this.isCurrent,
  });

  /// Creates a [AvailableWorkoutDto] from JSON.
  factory AvailableWorkoutDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableWorkoutDtoFromJson(json);
}
