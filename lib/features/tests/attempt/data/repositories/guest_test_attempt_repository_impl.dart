import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../../data/remote/tests_api_client.dart';
import '../../domain/entities/completed_test_attempt.dart';
import '../../domain/entities/test_attempt_result.dart';
import '../../domain/entities/test_attempt_start.dart';
import '../../domain/repositories/test_attempt_repository.dart';
import '../../../catalog/data/mappers/tests_failure_mapper.dart';
import '../dto/complete_guest_test_request_dto.dart';
import '../dto/save_guest_test_result_data_dto.dart';
import '../dto/save_guest_test_result_request_dto.dart';
import '../mappers/test_attempt_mapper.dart';

/// Guest implementation of [TestAttemptRepository].
final class GuestTestAttemptRepositoryImpl implements TestAttemptRepository {
  /// Logger for tracking guest test attempt operations.
  final AppLogger _logger;

  /// API client for tests catalog and guest attempts.
  final TestsApiClient _apiClient;

  /// Creates an instance of [GuestTestAttemptRepositoryImpl].
  GuestTestAttemptRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<TestAttemptStart, TestsFailure>> startTest(int testingId) async {
    try {
      final response = await _apiClient.startGuestTest(testingId);
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('StartGuestTest failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<TestAttemptResult, TestsFailure>> saveResult({
    required String attemptId,
    required int testingExerciseId,
    required int resultValue,
  }) async {
    try {
      final request = SaveGuestTestResultRequestDto(
        testingExerciseId: testingExerciseId,
        resultValue: resultValue,
      );
      final response = await _apiClient.saveGuestTestResult(attemptId, request);
      final payload = response.data;
      if (!_isValidGuestResultPayload(payload)) {
        final exception = StateError('Malformed guest test result payload.');
        _logger.e('SaveGuestTestResult returned malformed payload', exception);
        return Result.failure(UnknownTestsFailure(parentException: exception));
      }
      return Result.success(payload.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('SaveGuestTestResult failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<CompletedTestAttempt, TestsFailure>> completeTest({
    required String attemptId,
    required int pulse,
  }) async {
    try {
      final request = CompleteGuestTestRequestDto(pulse: pulse);
      final response = await _apiClient.completeGuestTest(attemptId, request);
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('CompleteGuestTest failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }
}

bool _isValidGuestResultPayload(SaveGuestTestResultDataDto payload) {
  if (!payload.saved) return false;

  final hasNextExercise = payload.nextExercise != null;
  final isCompleted = payload.allExercisesCompleted == true;

  if (hasNextExercise) {
    return !isCompleted;
  }

  return isCompleted;
}
