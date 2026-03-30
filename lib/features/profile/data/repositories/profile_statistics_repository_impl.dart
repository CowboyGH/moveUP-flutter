import 'package:dio/dio.dart';

import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/profile_statistics/frequency_period.dart';
import '../../domain/entities/profile_statistics/frequency_statistics_data.dart';
import '../../domain/entities/profile_statistics/profile_exercise_option.dart';
import '../../domain/entities/profile_statistics/profile_workout_option.dart';
import '../../domain/entities/profile_statistics/trend_statistics_data.dart';
import '../../domain/entities/profile_statistics/volume_statistics_data.dart';
import '../../domain/repositories/profile_statistics_repository.dart';
import '../mappers/profile_failure_mapper.dart';
import '../mappers/profile_statistics_mapper.dart';
import '../remote/profile_statistics_api_client.dart';

/// Implementation of [ProfileStatisticsRepository].
final class ProfileStatisticsRepositoryImpl implements ProfileStatisticsRepository {
  final AppLogger _logger;
  final ProfileStatisticsApiClient _apiClient;

  /// Creates an instance of [ProfileStatisticsRepositoryImpl].
  ProfileStatisticsRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<VolumeStatisticsData, ProfileFailure>> getVolume({
    int? exerciseId,
    int? weekOffset,
  }) async {
    try {
      final response = await _apiClient.getVolume(
        exerciseId: exerciseId,
        weekOffset: weekOffset,
      );
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetVolume failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<TrendStatisticsData, ProfileFailure>> getTrend({
    int? workoutId,
  }) async {
    try {
      final response = await _apiClient.getTrend(workoutId: workoutId);
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetTrend failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<FrequencyStatisticsData, ProfileFailure>> getFrequency({
    required FrequencyPeriod period,
    required int offset,
  }) async {
    try {
      final response = await _apiClient.getFrequency(
        period: period.requestValue,
        offset: offset,
      );
      return Result.success(
        response.data.toEntity(
          fallbackPeriod: period,
          fallbackOffset: offset,
        ),
      );
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetFrequency failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<List<ProfileExerciseOption>, ProfileFailure>> getExercises() async {
    try {
      final response = await _apiClient.getExercises();
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetExercises failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<List<ProfileWorkoutOption>, ProfileFailure>> getWorkouts() async {
    try {
      final response = await _apiClient.getWorkouts();
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetWorkouts failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
