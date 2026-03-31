import 'package:json_annotation/json_annotation.dart';

part 'frequency_response_dto.g.dart';

/// DTO response with profile frequency statistics payload.
@JsonSerializable(createToJson: false)
class FrequencyResponseDto {
  /// Nested statistics payload.
  final FrequencyStatisticsDto data;

  /// Creates an instance of [FrequencyResponseDto].
  FrequencyResponseDto({required this.data});

  /// Creates a [FrequencyResponseDto] from JSON.
  factory FrequencyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FrequencyResponseDtoFromJson(json);
}

/// DTO for frequency statistics.
@JsonSerializable(createToJson: false)
class FrequencyStatisticsDto {
  /// Whether selected frequency period has data.
  @JsonKey(name: 'has_data', defaultValue: false)
  final bool hasData;

  /// Current period info.
  @JsonKey(name: 'period_info')
  final FrequencyPeriodInfoDto? periodInfo;

  /// Summary block.
  final FrequencySummaryDto? summary;

  /// Chart items.
  @JsonKey(defaultValue: <FrequencyChartItemDto>[])
  final List<FrequencyChartItemDto> chart;

  /// Creates an instance of [FrequencyStatisticsDto].
  FrequencyStatisticsDto({
    required this.hasData,
    required this.periodInfo,
    required this.summary,
    required this.chart,
  });

  /// Creates a [FrequencyStatisticsDto] from JSON.
  factory FrequencyStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$FrequencyStatisticsDtoFromJson(json);
}

/// DTO with current frequency period metadata.
@JsonSerializable(createToJson: false)
class FrequencyPeriodInfoDto {
  /// Frequency period key.
  final String type;

  /// Current offset.
  final int offset;

  /// Human-readable label.
  final String label;

  /// Chart items count.
  @JsonKey(name: 'items_count')
  final int? itemsCount;

  /// Creates an instance of [FrequencyPeriodInfoDto].
  FrequencyPeriodInfoDto({
    required this.type,
    required this.offset,
    required this.label,
    required this.itemsCount,
  });

  /// Creates a [FrequencyPeriodInfoDto] from JSON.
  factory FrequencyPeriodInfoDto.fromJson(Map<String, dynamic> json) =>
      _$FrequencyPeriodInfoDtoFromJson(json);
}

/// DTO with summary values for frequency statistics.
@JsonSerializable(createToJson: false)
class FrequencySummaryDto {
  /// Total completed workouts.
  @JsonKey(name: 'total_workouts')
  final int? totalWorkouts;

  /// Average workouts per week.
  @JsonKey(name: 'average_per_week')
  final double? averagePerWeek;

  /// Current streak length.
  @JsonKey(name: 'current_streak')
  final int? currentStreak;

  /// Longest streak length.
  @JsonKey(name: 'longest_streak')
  final int? longestStreak;

  /// Weekly goal.
  @JsonKey(name: 'weekly_goal')
  final int? weeklyGoal;

  /// Creates an instance of [FrequencySummaryDto].
  FrequencySummaryDto({
    required this.totalWorkouts,
    required this.averagePerWeek,
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyGoal,
  });

  /// Creates a [FrequencySummaryDto] from JSON.
  factory FrequencySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FrequencySummaryDtoFromJson(json);
}

/// DTO item for the frequency chart.
@JsonSerializable(createToJson: false)
class FrequencyChartItemDto {
  /// Current day position for `week` payloads.
  @JsonKey(name: 'day_index')
  final int? dayIndex;

  /// Day number for `week` payloads.
  @JsonKey(name: 'day_number')
  final int? dayNumber;

  /// Current chart position.
  @JsonKey(name: 'week_index')
  final int? weekIndex;

  /// Week number.
  @JsonKey(name: 'week_number')
  final int? weekNumber;

  /// Full label.
  final String label;

  /// Short label.
  @JsonKey(name: 'short_label')
  final String? shortLabel;

  /// Formatted date label for `week` payloads.
  @JsonKey(name: 'date_formatted')
  final String? dateFormatted;

  /// Range start date.
  @JsonKey(name: 'start_date')
  final String? startDate;

  /// Range end date.
  @JsonKey(name: 'end_date')
  final String? endDate;

  /// Completed workouts count.
  final int count;

  /// Goal for the bar.
  final int? goal;

  /// Creates an instance of [FrequencyChartItemDto].
  FrequencyChartItemDto({
    required this.dayIndex,
    required this.dayNumber,
    required this.weekIndex,
    required this.weekNumber,
    required this.label,
    this.shortLabel,
    this.dateFormatted,
    required this.startDate,
    required this.endDate,
    required this.count,
    required this.goal,
  });

  /// Creates a [FrequencyChartItemDto] from JSON.
  factory FrequencyChartItemDto.fromJson(Map<String, dynamic> json) =>
      _$FrequencyChartItemDtoFromJson(json);
}
