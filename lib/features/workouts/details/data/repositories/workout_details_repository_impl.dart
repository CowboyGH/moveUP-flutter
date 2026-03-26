import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../../data/mappers/workout_details_mapper.dart';
import '../../../data/mappers/workouts_failure_mapper.dart';
import '../../../data/remote/workouts_api_client.dart';
import '../../domain/entities/workout_details_item.dart';
import '../../domain/repositories/workout_details_repository.dart';

/// Implementation of [WorkoutDetailsRepository].
final class WorkoutDetailsRepositoryImpl implements WorkoutDetailsRepository {
  /// Logger for tracking workout details operations and errors.
  final AppLogger _logger;

  /// API client for workouts requests.
  final WorkoutsApiClient _apiClient;

  /// Creates an instance of [WorkoutDetailsRepositoryImpl].
  WorkoutDetailsRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<List<WorkoutDetailsItem>, WorkoutsFailure>> getWorkoutDetails(
    int userWorkoutId,
  ) async {
    try {
      final response = await _apiClient.getWorkoutDetails(userWorkoutId);
      return Result.success(response.data.toEntities());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('GetWorkoutDetails failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }
}
