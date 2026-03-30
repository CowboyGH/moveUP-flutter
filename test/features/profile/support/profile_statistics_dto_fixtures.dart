import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_statistics/frequency_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_statistics/profile_exercises_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_statistics/profile_workouts_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_statistics/trend_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_statistics/volume_response_dto.dart';

const testVolumeExerciseId = 17;
const testVolumeExerciseTitle = 'Скручивания на пресс';
const testVolumeAverageScorePercent = 66;
const testVolumeAverageScoreLabel = 'Нормально';
const testVolumePeriodStart = '2026-03-16';
const testVolumePeriodEnd = '2026-03-22';
const testVolumePeriodLabel = 'Неделя 4';
const testVolumeWeekOffset = 0;
const testTrendWorkoutId = 231;
const testTrendWorkoutTitle = 'Силовая: Грудь + трицепс';
const testTrendWorkoutCompletedFormatted = '18.03.2026 08:32';
const testFrequencyLabel = 'Текущий месяц';

/// Test fixture for [VolumeResponseDto].
VolumeResponseDto createVolumeResponseDto({
  VolumeStatisticsDto? data,
}) => VolumeResponseDto(
  data: data ?? createVolumeStatisticsDto(),
);

/// Test fixture for [VolumeStatisticsDto].
VolumeStatisticsDto createVolumeStatisticsDto({
  bool hasData = true,
  ProfileExerciseInfoDto? exercise,
  int? averageScorePercent = testVolumeAverageScorePercent,
  String? averageScoreLabel = testVolumeAverageScoreLabel,
  VolumePeriodDto? period,
  List<VolumeChartItemDto>? chart,
}) => VolumeStatisticsDto(
  hasData: hasData,
  exercise: exercise ?? createProfileExerciseInfoDto(),
  averageScore: 66.7,
  averageScorePercent: averageScorePercent,
  averageScoreLabel: averageScoreLabel,
  period: period ?? createVolumePeriodDto(),
  summary: VolumeSummaryDto(
    totalVolume: 5225,
    workoutCount: 3,
    averageVolumePerWorkout: 1741.7,
  ),
  chart:
      chart ??
      [
        VolumeChartItemDto(name: 'Пн', totalVolume: 3500, date: '2026-03-16'),
        VolumeChartItemDto(name: 'Вт', totalVolume: 1500, date: '2026-03-17'),
      ],
);

/// Test fixture for [ProfileExerciseInfoDto].
ProfileExerciseInfoDto createProfileExerciseInfoDto({
  int id = testVolumeExerciseId,
  String title = testVolumeExerciseTitle,
  String muscleGroup = 'Пресс',
}) => ProfileExerciseInfoDto(
  id: id,
  title: title,
  muscleGroup: muscleGroup,
);

/// Test fixture for [VolumePeriodDto].
VolumePeriodDto createVolumePeriodDto({
  String start = testVolumePeriodStart,
  String end = testVolumePeriodEnd,
  String label = testVolumePeriodLabel,
  int? weekOffset = testVolumeWeekOffset,
  bool canGoPrevious = true,
  bool canGoNext = false,
}) => VolumePeriodDto(
  start: start,
  end: end,
  label: label,
  weekNumber: 4,
  weekOffset: weekOffset,
  canGoPrevious: canGoPrevious,
  canGoNext: canGoNext,
);

/// Test fixture for [TrendResponseDto].
TrendResponseDto createTrendResponseDto({
  TrendStatisticsDto? data,
}) => TrendResponseDto(
  data: data ?? createTrendStatisticsDto(),
);

/// Test fixture for [TrendStatisticsDto].
TrendStatisticsDto createTrendStatisticsDto({
  bool hasData = true,
  TrendWorkoutInfoDto? workout,
  int? averageScorePercent = 100,
  String? averageScoreLabel = 'Отлично',
  List<TrendChartItemDto>? chart,
}) => TrendStatisticsDto(
  hasData: hasData,
  workout: workout ?? createTrendWorkoutInfoDto(),
  averageScore: 100,
  averageScorePercent: averageScorePercent,
  averageScoreLabel: averageScoreLabel,
  chart:
      chart ??
      [
        TrendChartItemDto(
          exerciseNumber: 1,
          exerciseId: 1,
          exerciseName: 'Жим штанги лежа',
          reaction: 'good',
          score: 100,
          scorePercent: 100,
          scoreLabel: 'Отлично',
          weightUsed: '60.0',
          setsCompleted: 3,
          repsCompleted: 10,
          setsPlanned: 3,
          repsPlanned: 10,
        ),
      ],
  availableWorkouts: [
    AvailableWorkoutDto(
      id: testTrendWorkoutId,
      title: testTrendWorkoutTitle,
      date: '18.03.2026',
      isCurrent: true,
    ),
  ],
);

/// Test fixture for [TrendWorkoutInfoDto].
TrendWorkoutInfoDto createTrendWorkoutInfoDto({
  int id = testTrendWorkoutId,
  int workoutId = 6,
  String title = testTrendWorkoutTitle,
  String completedAt = '2026-03-18',
  String completedAtFormatted = testTrendWorkoutCompletedFormatted,
}) => TrendWorkoutInfoDto(
  id: id,
  workoutId: workoutId,
  title: title,
  completedAt: completedAt,
  completedAtFormatted: completedAtFormatted,
  durationMinutes: 42,
);

/// Test fixture for [FrequencyResponseDto].
FrequencyResponseDto createFrequencyResponseDto({
  FrequencyStatisticsDto? data,
}) => FrequencyResponseDto(
  data: data ?? createFrequencyStatisticsDto(),
);

/// Test fixture for [FrequencyStatisticsDto].
FrequencyStatisticsDto createFrequencyStatisticsDto({
  bool hasData = true,
  FrequencyPeriodInfoDto? periodInfo,
  bool includePeriodInfo = true,
  List<FrequencyChartItemDto>? chart,
  double? averagePerWeek = 2.3,
}) => FrequencyStatisticsDto(
  hasData: hasData,
  periodInfo: includePeriodInfo
      ? periodInfo ??
            FrequencyPeriodInfoDto(
              type: 'month',
              offset: 0,
              label: testFrequencyLabel,
              itemsCount: 4,
            )
      : null,
  summary: FrequencySummaryDto(
    totalWorkouts: 10,
    averagePerWeek: averagePerWeek,
    currentStreak: 0,
    longestStreak: 1,
    weeklyGoal: 4,
  ),
  chart:
      chart ??
      [
        FrequencyChartItemDto(
          weekIndex: 0,
          weekNumber: 1,
          label: 'Нед 1',
          shortLabel: '1',
          startDate: '2026-02-23',
          endDate: '2026-03-01',
          count: 1,
          goal: 4,
        ),
        FrequencyChartItemDto(
          weekIndex: 1,
          weekNumber: 2,
          label: 'Нед 2',
          shortLabel: '2',
          startDate: '2026-03-02',
          endDate: '2026-03-08',
          count: 3,
          goal: 4,
        ),
      ],
);

/// Test fixture for [ProfileExercisesResponseDto].
ProfileExercisesResponseDto createProfileExercisesResponseDto({
  List<ProfileExerciseItemDto>? data,
}) => ProfileExercisesResponseDto(
  data:
      data ??
      [
        ProfileExerciseItemDto(
          id: testVolumeExerciseId,
          name: testVolumeExerciseTitle,
          lastUsed: '2026-03-19',
          lastUsedFormatted: '19.03.2026',
        ),
      ],
);

/// Test fixture for [ProfileWorkoutsResponseDto].
ProfileWorkoutsResponseDto createProfileWorkoutsResponseDto({
  List<ProfileWorkoutItemDto>? data,
}) => ProfileWorkoutsResponseDto(
  data:
      data ??
      [
        ProfileWorkoutItemDto(
          id: testTrendWorkoutId,
          workoutId: 6,
          title: testTrendWorkoutTitle,
          completedAt: '2026-03-18',
          completedAtFormatted: '18.03.2026',
          durationMinutes: 42,
        ),
      ],
);

/// Test fixture for Dio bad response exception used in statistics tests.
DioException createProfileStatisticsDioBadResponseException({
  required String path,
  required int statusCode,
  required String code,
  String message = 'error_message',
  Map<String, List<String>>? errors,
}) {
  final requestOptions = RequestOptions(path: path);
  final data = <String, dynamic>{
    'code': code,
    'message': message,
  };
  if (errors != null) {
    data['errors'] = errors;
  }
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
  );
}
