import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../../data/mappers/workout_overview_mapper.dart';
import '../../../data/mappers/workouts_failure_mapper.dart';
import '../../../data/remote/workouts_api_client.dart';
import '../../domain/entities/workout_overview_item.dart';
import '../../domain/repositories/workouts_overview_repository.dart';

/// Implementation of [WorkoutsOverviewRepository].
final class WorkoutsOverviewRepositoryImpl implements WorkoutsOverviewRepository {
  /// Logger for tracking workouts overview operations and errors.
  final AppLogger _logger;

  /// API client for workouts overview requests.
  final WorkoutsApiClient _apiClient;

  /// Creates an instance of [WorkoutsOverviewRepositoryImpl].
  WorkoutsOverviewRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<List<WorkoutOverviewItem>, WorkoutsFailure>> getWorkouts() async {
    try {
      final response = await _apiClient.getWorkouts();
      final items = [
        ...response.data.started,
        ...response.data.assigned,
      ].map((item) => item.toEntity()).toList(growable: false);
      return Result.success(items);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('GetWorkouts failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }
}
