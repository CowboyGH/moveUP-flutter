import '../../domain/entities/profile_statistics/frequency_period.dart';
import '../../domain/entities/profile_statistics/frequency_statistics_data.dart';
import '../../domain/entities/profile_statistics/profile_exercise_option.dart';
import '../../domain/entities/profile_statistics/profile_workout_option.dart';
import '../../domain/entities/profile_statistics/trend_statistics_data.dart';
import '../../domain/entities/profile_statistics/volume_statistics_data.dart';
import '../dto/stats/frequency_response_dto.dart';
import '../dto/stats/profile_exercises_response_dto.dart';
import '../dto/stats/profile_workouts_response_dto.dart';
import '../dto/stats/trend_response_dto.dart';
import '../dto/stats/volume_response_dto.dart';

/// Maps profile statistics DTOs into domain entities.
extension VolumeStatisticsMapper on VolumeStatisticsDto {
  /// Converts volume statistics DTO into [VolumeStatisticsData].
  VolumeStatisticsData toEntity() => VolumeStatisticsData(
    hasData: hasData,
    exerciseId: exercise?.id,
    title: exercise?.title ?? '',
    averageScorePercent: averageScorePercent ?? 0,
    averageScoreLabel: averageScoreLabel ?? '',
    period: (period ?? _FallbackVolumePeriodDto()).toEntity(),
    chart: chart.map((item) => item.toEntity()).toList(growable: false),
  );
}

extension on VolumePeriodDto {
  VolumePeriodData toEntity() => VolumePeriodData(
    start: start,
    end: end,
    label: label,
    weekOffset: weekOffset ?? 0,
    canGoPrevious: canGoPrevious,
    canGoNext: canGoNext,
  );
}

extension on VolumeChartItemDto {
  VolumeChartBarData toEntity() => VolumeChartBarData(
    label: name,
    value: totalVolume,
    date: date,
  );
}

/// Maps trend statistics DTO into domain data.
extension TrendStatisticsMapper on TrendStatisticsDto {
  /// Converts trend statistics DTO into [TrendStatisticsData].
  TrendStatisticsData toEntity() => TrendStatisticsData(
    hasData: hasData,
    workoutId: workout?.id,
    title: workout?.title ?? '',
    completedAtFormatted: workout?.completedAtFormatted,
    averageScorePercent: averageScorePercent ?? 0,
    averageScoreLabel: averageScoreLabel ?? '',
    exercises: chart.map((item) => item.toEntity()).toList(growable: false),
  );
}

extension on TrendChartItemDto {
  TrendExerciseData toEntity() => TrendExerciseData(
    exerciseName: exerciseName,
    scorePercent: scorePercent ?? 0,
    scoreLabel: scoreLabel,
    reaction: reaction,
    weightUsed: weightUsed,
  );
}

/// Maps frequency statistics DTO into domain data.
extension FrequencyStatisticsMapper on FrequencyStatisticsDto {
  /// Converts frequency statistics DTO into [FrequencyStatisticsData].
  FrequencyStatisticsData toEntity({
    required FrequencyPeriod fallbackPeriod,
    required int fallbackOffset,
  }) {
    final resolvedPeriod = periodInfo == null
        ? fallbackPeriod
        : FrequencyPeriod.fromRequestValue(periodInfo!.type);

    return FrequencyStatisticsData(
      hasData: hasData,
      period: resolvedPeriod,
      offset: periodInfo?.offset ?? fallbackOffset,
      label: periodInfo?.label ?? '',
      averagePerWeek: summary?.averagePerWeek ?? 0,
      chart: chart.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

extension on FrequencyChartItemDto {
  FrequencyChartBarData toEntity() => FrequencyChartBarData(
    label: label,
    shortLabel: shortLabel?.isNotEmpty == true ? shortLabel! : label,
    startDate: startDate,
    endDate: endDate,
    count: count,
    goal: goal ?? 0,
  );
}

/// Maps profile exercise selector DTO list into domain options.
extension ProfileExerciseOptionMapper on List<ProfileExerciseItemDto> {
  /// Converts selector DTO list into exercise options.
  List<ProfileExerciseOption> toEntity() => map(
    (item) => ProfileExerciseOption(
      id: item.id,
      name: item.name,
      lastUsedFormatted: item.lastUsedFormatted,
    ),
  ).toList(growable: false);
}

/// Maps profile workout selector DTO list into domain options.
extension ProfileWorkoutOptionMapper on List<ProfileWorkoutItemDto> {
  /// Converts selector DTO list into workout options.
  List<ProfileWorkoutOption> toEntity() => map(
    (item) => ProfileWorkoutOption(
      id: item.id,
      title: item.title,
      completedAtFormatted: item.completedAtFormatted,
    ),
  ).toList(growable: false);
}

final class _FallbackVolumePeriodDto extends VolumePeriodDto {
  _FallbackVolumePeriodDto()
    : super(
        start: '',
        end: '',
        label: '',
        weekNumber: 0,
        weekOffset: 0,
        canGoPrevious: false,
        canGoNext: false,
      );
}
