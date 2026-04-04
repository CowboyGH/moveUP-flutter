import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/profile_statistics/frequency_period.dart';
import '../entities/profile_statistics/profile_current_phase_summary.dart';
import '../entities/profile_statistics/frequency_statistics_data.dart';
import '../entities/profile_statistics/profile_exercise_option.dart';
import '../entities/profile_statistics/profile_workout_option.dart';
import '../entities/profile_statistics/trend_statistics_data.dart';
import '../entities/profile_statistics/volume_statistics_data.dart';

/// Repository interface for profile statistics operations.
abstract interface class ProfileStatisticsRepository {
  /// Returns frequency summary used by the current phase section.
  Future<Result<ProfileCurrentPhaseSummary, ProfileFailure>> getCurrentPhaseSummary();

  /// Returns volume statistics for the selected exercise and week offset.
  Future<Result<VolumeStatisticsData, ProfileFailure>> getVolume({
    int? exerciseId,
    int? weekOffset,
  });

  /// Returns trend statistics for the selected workout.
  Future<Result<TrendStatisticsData, ProfileFailure>> getTrend({
    int? workoutId,
  });

  /// Returns frequency statistics for the selected period and offset.
  Future<Result<FrequencyStatisticsData, ProfileFailure>> getFrequency({
    required FrequencyPeriod period,
    required int offset,
  });

  /// Returns exercise selector options.
  Future<Result<List<ProfileExerciseOption>, ProfileFailure>> getExercises();

  /// Returns workout selector options.
  Future<Result<List<ProfileWorkoutOption>, ProfileFailure>> getWorkouts();
}
