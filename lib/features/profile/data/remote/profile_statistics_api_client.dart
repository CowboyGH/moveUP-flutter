import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/stats/frequency_response_dto.dart';
import '../dto/stats/profile_exercises_response_dto.dart';
import '../dto/stats/profile_statistics_overview_response_dto.dart';
import '../dto/stats/profile_workouts_response_dto.dart';
import '../dto/stats/trend_response_dto.dart';
import '../dto/stats/volume_response_dto.dart';

part 'profile_statistics_api_client.g.dart';

/// Retrofit API client for authenticated profile statistics requests.
@RestApi()
abstract class ProfileStatisticsApiClient {
  /// Creates an instance of [ProfileStatisticsApiClient].
  factory ProfileStatisticsApiClient(
    Dio dio, {
    String? baseUrl,
  }) = _ProfileStatisticsApiClient;

  /// Returns aggregate profile statistics overview.
  @GET(ApiPaths.profileStatistics)
  Future<ProfileStatisticsOverviewResponseDto> getOverview();

  /// Returns volume statistics for the authenticated profile.
  @GET(ApiPaths.profileStatisticsVolume)
  Future<VolumeResponseDto> getVolume({
    @Query('exercise_id') int? exerciseId,
    @Query('week_offset') int? weekOffset,
  });

  /// Returns trend statistics for the authenticated profile.
  @GET(ApiPaths.profileStatisticsTrend)
  Future<TrendResponseDto> getTrend({
    @Query('workout_id') int? workoutId,
  });

  /// Returns frequency statistics for the authenticated profile.
  @GET(ApiPaths.profileStatisticsFrequency)
  Future<FrequencyResponseDto> getFrequency({
    @Query('period') String? period,
    @Query('offset') int? offset,
  });

  /// Returns available exercises for the profile statistics selector.
  @GET(ApiPaths.profileStatisticsExercises)
  Future<ProfileExercisesResponseDto> getExercises();

  /// Returns available workouts for the profile statistics selector.
  @GET(ApiPaths.profileStatisticsWorkouts)
  Future<ProfileWorkoutsResponseDto> getWorkouts();
}
