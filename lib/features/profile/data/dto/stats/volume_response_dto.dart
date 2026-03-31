import 'package:json_annotation/json_annotation.dart';

part 'volume_response_dto.g.dart';

/// DTO response with profile volume statistics payload.
@JsonSerializable(createToJson: false)
class VolumeResponseDto {
  /// Nested statistics payload.
  final VolumeStatisticsDto data;

  /// Creates an instance of [VolumeResponseDto].
  VolumeResponseDto({required this.data});

  /// Creates a [VolumeResponseDto] from JSON.
  factory VolumeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VolumeResponseDtoFromJson(json);
}

/// DTO for volume statistics.
@JsonSerializable(createToJson: false)
class VolumeStatisticsDto {
  /// Whether the selected period has chart data.
  @JsonKey(name: 'has_data', defaultValue: false)
  final bool hasData;

  /// Selected exercise info.
  final ProfileExerciseInfoDto? exercise;

  /// Average score value.
  @JsonKey(name: 'average_score')
  final double? averageScore;

  /// Average score percent.
  @JsonKey(name: 'average_score_percent')
  final int? averageScorePercent;

  /// Average score label.
  @JsonKey(name: 'average_score_label')
  final String? averageScoreLabel;

  /// Current period metadata.
  final VolumePeriodDto? period;

  /// Summary payload.
  final VolumeSummaryDto? summary;

  /// Chart payload.
  @JsonKey(defaultValue: <VolumeChartItemDto>[])
  final List<VolumeChartItemDto> chart;

  /// Creates an instance of [VolumeStatisticsDto].
  VolumeStatisticsDto({
    required this.hasData,
    required this.exercise,
    required this.averageScore,
    required this.averageScorePercent,
    required this.averageScoreLabel,
    required this.period,
    required this.summary,
    required this.chart,
  });

  /// Creates a [VolumeStatisticsDto] from JSON.
  factory VolumeStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$VolumeStatisticsDtoFromJson(json);
}

/// DTO with selected exercise info inside volume statistics.
@JsonSerializable(createToJson: false)
class ProfileExerciseInfoDto {
  /// Exercise identifier.
  final int id;

  /// Exercise title.
  final String title;

  /// Exercise muscle group.
  @JsonKey(name: 'muscle_group')
  final String? muscleGroup;

  /// Creates an instance of [ProfileExerciseInfoDto].
  ProfileExerciseInfoDto({
    required this.id,
    required this.title,
    required this.muscleGroup,
  });

  /// Creates a [ProfileExerciseInfoDto] from JSON.
  factory ProfileExerciseInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileExerciseInfoDtoFromJson(json);
}

/// DTO with volume period metadata.
@JsonSerializable(createToJson: false)
class VolumePeriodDto {
  /// Period start date.
  final String start;

  /// Period end date.
  final String end;

  /// Period label.
  final String label;

  /// Current week number.
  @JsonKey(name: 'week_number')
  final int? weekNumber;

  /// Current week offset.
  @JsonKey(name: 'week_offset')
  final int? weekOffset;

  /// Whether previous period navigation is allowed.
  @JsonKey(name: 'can_go_previous', defaultValue: false)
  final bool canGoPrevious;

  /// Whether next period navigation is allowed.
  @JsonKey(name: 'can_go_next', defaultValue: false)
  final bool canGoNext;

  /// Creates an instance of [VolumePeriodDto].
  VolumePeriodDto({
    required this.start,
    required this.end,
    required this.label,
    required this.weekNumber,
    required this.weekOffset,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  /// Creates a [VolumePeriodDto] from JSON.
  factory VolumePeriodDto.fromJson(Map<String, dynamic> json) => _$VolumePeriodDtoFromJson(json);
}

/// DTO with summary values for volume statistics.
@JsonSerializable(createToJson: false)
class VolumeSummaryDto {
  /// Total volume for the selected period.
  @JsonKey(name: 'total_volume')
  final double? totalVolume;

  /// Completed workouts count.
  @JsonKey(name: 'workout_count')
  final int? workoutCount;

  /// Average volume per workout.
  @JsonKey(name: 'average_volume_per_workout')
  final double? averageVolumePerWorkout;

  /// Creates an instance of [VolumeSummaryDto].
  VolumeSummaryDto({
    required this.totalVolume,
    required this.workoutCount,
    required this.averageVolumePerWorkout,
  });

  /// Creates a [VolumeSummaryDto] from JSON.
  factory VolumeSummaryDto.fromJson(Map<String, dynamic> json) => _$VolumeSummaryDtoFromJson(json);
}

/// DTO item for the volume chart.
@JsonSerializable(createToJson: false)
class VolumeChartItemDto {
  /// Axis label.
  final String name;

  /// Total volume for the point.
  @JsonKey(name: 'total_volume')
  final double totalVolume;

  /// Chart point date.
  final String? date;

  /// Creates an instance of [VolumeChartItemDto].
  VolumeChartItemDto({
    required this.name,
    required this.totalVolume,
    required this.date,
  });

  /// Creates a [VolumeChartItemDto] from JSON.
  factory VolumeChartItemDto.fromJson(Map<String, dynamic> json) =>
      _$VolumeChartItemDtoFromJson(json);
}
