import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/failures/network/network_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../../data/dto/save_exercise_result_data_dto.dart';
import '../../../data/dto/save_exercise_result_request_dto.dart';
import '../../../data/mappers/workout_execution_step_mapper.dart';
import '../../../data/mappers/workouts_failure_mapper.dart';
import '../../../data/remote/workouts_api_client.dart';
import '../../domain/entities/workout_execution_entry_mode.dart';
import '../../domain/entities/workout_execution_result.dart';
import '../../domain/entities/workout_execution_start.dart';
import '../../domain/entities/workout_execution_step.dart';
import '../../domain/entities/workout_exercise_reaction.dart';
import '../../domain/repositories/workout_execution_repository.dart';

/// Implementation of [WorkoutExecutionRepository].
final class WorkoutExecutionRepositoryImpl implements WorkoutExecutionRepository {
  final AppLogger _logger;
  final WorkoutsApiClient _apiClient;

  /// Creates an instance of [WorkoutExecutionRepositoryImpl].
  WorkoutExecutionRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<WorkoutExecutionStart, WorkoutsFailure>> startExecution({
    required int userWorkoutId,
    required WorkoutExecutionEntryMode entryMode,
  }) async {
    bool startsAssignedWorkout = false;
    try {
      final detailsResponse = await _apiClient.getWorkoutDetails(userWorkoutId);
      final details = detailsResponse.data;
      startsAssignedWorkout = details.status == 'assigned';

      final response = details.status == 'assigned'
          ? await _apiClient.startWorkout({
              'workout_id': details.workout.id,
              'with_warmup': entryMode == WorkoutExecutionEntryMode.warmup,
            })
          : switch (entryMode) {
              WorkoutExecutionEntryMode.warmup => await _apiClient.startWarmup(userWorkoutId),
              WorkoutExecutionEntryMode.workout => await _apiClient.completeWarmup(userWorkoutId),
            };

      final currentStep = response.data.toExecutionStep();
      return Result.success(
        WorkoutExecutionStart(
          userWorkoutId: response.data.userWorkoutId ?? userWorkoutId,
          currentStep: currentStep,
        ),
      );
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      if (startsAssignedWorkout && networkFailure is ConflictFailure) {
        return Result.failure(
          ActiveWorkoutExistsFailure(
            parentException: networkFailure.parentException,
            stackTrace: networkFailure.stackTrace,
          ),
        );
      }
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('StartExecution failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<WorkoutExecutionStep, WorkoutsFailure>> nextWarmup({
    required int userWorkoutId,
    required int currentWarmupId,
  }) async {
    try {
      final response = await _apiClient.nextWarmup(userWorkoutId, {
        'current_warmup_id': currentWarmupId,
      });
      final nextStep = response.data.toExecutionStep();
      return Result.success(nextStep);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('NextWarmup failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<WorkoutExerciseStep, WorkoutsFailure>> skipWarmup(int userWorkoutId) async {
    try {
      final response = await _apiClient.completeWarmup(userWorkoutId);
      final nextStep = response.data.toExecutionStep() as WorkoutExerciseStep;
      return Result.success(nextStep);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('SkipWarmup failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<WorkoutExecutionResult, WorkoutsFailure>> saveExerciseResult({
    required int userWorkoutId,
    required int exerciseId,
    required WorkoutExerciseReaction reaction,
    double? weightUsed,
  }) async {
    try {
      final response = await _apiClient.saveExerciseResult(
        userWorkoutId,
        SaveExerciseResultRequestDto(
          exerciseId: exerciseId,
          reaction: reaction.requestValue,
          weightUsed: weightUsed,
        ),
      );

      final data = response.data;
      if (data.allExercisesCompleted) {
        return Result.success(
          WorkoutExecutionResult(
            nextExercise: null,
            isAwaitingCompletion: true,
            adjustment: _mapLoadAdjustment(data.exerciseResult?.adjustments),
          ),
        );
      }

      final nextStep = data.nextExercise!.toExecutionStep() as WorkoutExerciseStep;
      return Result.success(
        WorkoutExecutionResult(
          nextExercise: nextStep,
          isAwaitingCompletion: false,
          adjustment: _mapLoadAdjustment(data.exerciseResult?.adjustments),
        ),
      );
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('SaveExerciseResult failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<void, WorkoutsFailure>> completeWorkout(int userWorkoutId) async {
    try {
      await _apiClient.completeWorkout(userWorkoutId);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toWorkoutsFailure());
    } catch (e, s) {
      _logger.e('CompleteWorkout failed with unexpected error', e, s);
      return Result.failure(UnknownWorkoutsFailure(parentException: e, stackTrace: s));
    }
  }
}

WorkoutLoadAdjustment? _mapLoadAdjustment(SaveExerciseResultAdjustmentDto? adjustment) {
  if (adjustment == null || !adjustment.applied || adjustment.type == null) {
    return null;
  }
  return WorkoutLoadAdjustment(
    type: adjustment.type!,
    percent: adjustment.percent,
    oldWeight: adjustment.oldWeight,
    newWeight: adjustment.newWeight,
  );
}
