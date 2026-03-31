import 'package:json_annotation/json_annotation.dart';

part 'profile_statistics_overview_response_dto.g.dart';

/// DTO for the aggregate profile statistics overview response.
@JsonSerializable(createToJson: false)
class ProfileStatisticsOverviewResponseDto {
  /// Nested overview payload.
  final ProfileStatisticsOverviewDataDto data;

  /// Creates an instance of [ProfileStatisticsOverviewResponseDto].
  ProfileStatisticsOverviewResponseDto({required this.data});

  /// Creates a [ProfileStatisticsOverviewResponseDto] from JSON.
  factory ProfileStatisticsOverviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatisticsOverviewResponseDtoFromJson(json);
}

/// DTO with focused aggregate statistics subset for the current phase section.
@JsonSerializable(createToJson: false)
class ProfileStatisticsOverviewDataDto {
  /// Frequency overview subset.
  final ProfileStatisticsOverviewFrequencyDto? frequency;

  /// Creates an instance of [ProfileStatisticsOverviewDataDto].
  ProfileStatisticsOverviewDataDto({this.frequency});

  /// Creates a [ProfileStatisticsOverviewDataDto] from JSON.
  factory ProfileStatisticsOverviewDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatisticsOverviewDataDtoFromJson(json);
}

/// DTO with frequency subset from the aggregate statistics response.
@JsonSerializable(createToJson: false)
class ProfileStatisticsOverviewFrequencyDto {
  /// Frequency summary subset.
  final ProfileStatisticsOverviewFrequencySummaryDto? summary;

  /// Creates an instance of [ProfileStatisticsOverviewFrequencyDto].
  ProfileStatisticsOverviewFrequencyDto({required this.summary});

  /// Creates a [ProfileStatisticsOverviewFrequencyDto] from JSON.
  factory ProfileStatisticsOverviewFrequencyDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatisticsOverviewFrequencyDtoFromJson(json);
}

/// DTO with current phase frequency numbers for the profile section.
@JsonSerializable(createToJson: false)
class ProfileStatisticsOverviewFrequencySummaryDto {
  /// Average trainings per week.
  @JsonKey(name: 'average_per_week')
  final double averagePerWeek;

  /// Recommended weekly goal.
  @JsonKey(name: 'weekly_goal')
  final int weeklyGoal;

  /// Creates an instance of [ProfileStatisticsOverviewFrequencySummaryDto].
  ProfileStatisticsOverviewFrequencySummaryDto({
    required this.averagePerWeek,
    required this.weeklyGoal,
  });

  /// Creates a [ProfileStatisticsOverviewFrequencySummaryDto] from JSON.
  factory ProfileStatisticsOverviewFrequencySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatisticsOverviewFrequencySummaryDtoFromJson(json);
}
