import 'package:dio/dio.dart';

import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/profile_parameters/profile_parameters_data.dart';
import '../../domain/entities/profile_parameters/profile_parameters_references.dart';
import '../../domain/entities/profile_parameters/profile_parameters_submit_payload.dart';
import '../../domain/repositories/profile_parameters_repository.dart';
import '../mappers/profile_failure_mapper.dart';
import '../mappers/profile_parameters_mapper.dart';
import '../remote/profile_parameters_api_client.dart';

/// Implementation of [ProfileParametersRepository].
final class ProfileParametersRepositoryImpl implements ProfileParametersRepository {
  final AppLogger _logger;
  final ProfileParametersApiClient _apiClient;

  /// Creates an instance of [ProfileParametersRepositoryImpl].
  ProfileParametersRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<ProfileParametersReferences, ProfileFailure>> getReferences() async {
    try {
      final response = await _apiClient.getReferences();
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetProfileParametersReferences failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<ProfileParametersData, ProfileFailure>> getCurrentParameters() async {
    try {
      final response = await _apiClient.getCurrentParameters();
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetCurrentProfileParameters failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<ProfileParametersData, ProfileFailure>> saveParameters({
    required ProfileParametersData currentParameters,
    required int currentWeeklyGoal,
    required ProfileParametersSubmitPayload payload,
  }) async {
    final hasGoalChanges = payload.goalId != currentParameters.goalId;
    final hasAnthropometryChanges =
        payload.gender != currentParameters.gender ||
        payload.age != currentParameters.age ||
        payload.weight != currentParameters.weight ||
        payload.height != currentParameters.height ||
        payload.equipmentId != currentParameters.equipmentId;
    final hasLevelChanges = payload.levelId != currentParameters.levelId;
    final hasWeeklyGoalChanges = payload.weeklyGoal != currentWeeklyGoal;

    if (!hasGoalChanges && !hasAnthropometryChanges && !hasLevelChanges && !hasWeeklyGoalChanges) {
      return Result.success(currentParameters);
    }

    try {
      if (hasGoalChanges) {
        await _apiClient.saveGoal({'goal_id': payload.goalId});
      }
      if (hasAnthropometryChanges) {
        await _apiClient.saveAnthropometry({
          'gender': payload.gender.requestValue,
          'age': payload.age,
          'weight': payload.weight,
          'height': payload.height,
          'equipment_id': payload.equipmentId,
        });
      }
      if (hasLevelChanges) {
        await _apiClient.saveLevel({'level_id': payload.levelId});
      }
      if (hasWeeklyGoalChanges) {
        await _apiClient.updateWeeklyGoal({'weekly_goal': payload.weeklyGoal});
      }

      final refreshedResponse = await _apiClient.getCurrentParameters();
      return Result.success(refreshedResponse.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('SaveProfileParameters failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
