part of 'profile_statistics_cubit.dart';

/// State for [ProfileStatisticsCubit].
@freezed
abstract class ProfileStatisticsState with _$ProfileStatisticsState {
  /// Creates an instance of [ProfileStatisticsState].
  const factory ProfileStatisticsState({
    @Default(false) bool isLoading,
    @Default(ProfileStatisticsMode.volume) ProfileStatisticsMode mode,
    @Default(ProfileHistoryTab.subscriptions) ProfileHistoryTab selectedHistoryTab,
    int? selectedExerciseId,
    int? selectedWorkoutId,
    @Default(FrequencyPeriod.month) FrequencyPeriod selectedFrequencyPeriod,
    @Default(0) int selectedFrequencyOffset,
    ProfileStatsHistorySnapshot? historySnapshot,
    VolumeStatisticsData? volumeData,
    FrequencyStatisticsData? frequencyData,
    TrendStatisticsData? trendData,
    @Default(<ProfileExerciseOption>[]) List<ProfileExerciseOption> exerciseOptions,
    @Default(<ProfileWorkoutOption>[]) List<ProfileWorkoutOption> workoutOptions,
    ProfileFailure? failure,
  }) = _ProfileStatisticsState;
}
