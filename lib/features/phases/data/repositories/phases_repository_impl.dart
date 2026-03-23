import 'package:dio/dio.dart';

import '../../../../core/failures/feature/phases/phases_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/repositories/phases_repository.dart';
import '../mappers/phases_failure_mapper.dart';
import '../remote/phases_api_client.dart';

/// Implementation of [PhasesRepository].
final class PhasesRepositoryImpl implements PhasesRepository {
  /// Logger for tracking phases operations and errors.
  final AppLogger _logger;

  /// API client for phases requests.
  final PhasesApiClient _apiClient;

  /// Creates an instance of [PhasesRepositoryImpl].
  PhasesRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<void, PhasesFailure>> updateWeeklyGoal(int weeklyGoal) async {
    try {
      await _apiClient.updateWeeklyGoal({'weekly_goal': weeklyGoal});
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toPhasesFailure());
    } catch (e, s) {
      _logger.e('UpdateWeeklyGoal failed with unexpected error', e, s);
      return Result.failure(UnknownPhasesFailure(parentException: e, stackTrace: s));
    }
  }
}
