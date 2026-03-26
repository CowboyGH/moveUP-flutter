import 'package:dio/dio.dart';

import '../../../../core/failures/feature/fitness_start/fitness_start_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/fitness_start_gender.dart';
import '../../domain/entities/fitness_start_references.dart';
import '../../domain/repositories/fitness_start_repository.dart';
import '../mappers/fitness_start_failure_mapper.dart';
import '../mappers/fitness_start_references_mapper.dart';
import '../remote/fitness_start_api_client.dart';

/// Implementation of [FitnessStartRepository].
final class FitnessStartRepositoryImpl implements FitnessStartRepository {
  /// Logger for tracking fitness-start operations and errors.
  final AppLogger _logger;

  /// API client for making fitness-start requests to the backend.
  final FitnessStartApiClient _apiClient;

  /// Creates an instance of [FitnessStartRepositoryImpl].
  FitnessStartRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<FitnessStartReferences, FitnessStartFailure>> getReferences() async {
    try {
      final response = await _apiClient.getReferences();
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final failure = e.toNetworkFailure().toFitnessStartFailure();
      return Result.failure(failure);
    } catch (e, s) {
      _logger.e('GetReferences failed with unexpected error', e, s);
      return Result.failure(
        UnknownFitnessStartFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, FitnessStartFailure>> saveGoal(int goalId) async {
    try {
      await _apiClient.saveGoal({'goal_id': goalId});
      return const Result.success(null);
    } on DioException catch (e) {
      final failure = e.toNetworkFailure().toFitnessStartFailure();
      return Result.failure(failure);
    } catch (e, s) {
      _logger.e('SaveGoal failed with unexpected error', e, s);
      return Result.failure(
        UnknownFitnessStartFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, FitnessStartFailure>> saveAnthropometry({
    required FitnessStartGender gender,
    required int age,
    required double weight,
    required int height,
    required int equipmentId,
  }) async {
    try {
      await _apiClient.saveAnthropometry({
        'gender': gender.name,
        'age': age,
        'weight': weight,
        'height': height,
        'equipment_id': equipmentId,
      });
      return const Result.success(null);
    } on DioException catch (e) {
      final failure = e.toNetworkFailure().toFitnessStartFailure();
      return Result.failure(failure);
    } catch (e, s) {
      _logger.e('SaveAnthropometry failed with unexpected error', e, s);
      return Result.failure(
        UnknownFitnessStartFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, FitnessStartFailure>> saveLevel(int levelId) async {
    try {
      await _apiClient.saveLevel({'level_id': levelId});
      return const Result.success(null);
    } on DioException catch (e) {
      final failure = e.toNetworkFailure().toFitnessStartFailure();
      return Result.failure(failure);
    } catch (e, s) {
      _logger.e('SaveLevel failed with unexpected error', e, s);
      return Result.failure(
        UnknownFitnessStartFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
