import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../../catalog/data/mappers/tests_failure_mapper.dart';
import '../../../data/remote/tests_api_client.dart';
import '../../domain/entities/test_attempt_result.dart';
import '../../domain/entities/test_attempt_start.dart';
import '../../domain/repositories/test_attempt_repository.dart';
import '../dto/complete_test_request_dto.dart';
import '../dto/save_test_result_request_dto.dart';
import '../mappers/test_attempt_mapper.dart';
import 'test_attempt_result_payload_validator.dart';

/// Authenticated implementation of [AuthenticatedTestAttemptRepository].
final class AuthenticatedTestAttemptRepositoryImpl implements AuthenticatedTestAttemptRepository {
  /// Logger for tracking authenticated test attempt operations.
  final AppLogger _logger;

  /// API client for tests catalog and attempts.
  final TestsApiClient _apiClient;

  /// Creates an instance of [AuthenticatedTestAttemptRepositoryImpl].
  AuthenticatedTestAttemptRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<TestAttemptStart, TestsFailure>> startTest(int testingId) async {
    try {
      final response = await _apiClient.startTest(testingId);
      return Result.success(response.data.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('StartTest failed with unexpected error', e, s);
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
      final request = SaveTestResultRequestDto(
        testingExerciseId: testingExerciseId,
        resultValue: resultValue,
      );
      final response = await _apiClient.saveTestResult(attemptId, request);
      final payload = response.data;
      if (!isValidTestAttemptResultPayload(payload)) {
        final exception = StateError('Malformed authenticated test result payload.');
        _logger.e('SaveTestResult returned malformed payload', exception);
        return Result.failure(UnknownTestsFailure(parentException: exception));
      }
      return Result.success(payload.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('SaveTestResult failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<void, TestsFailure>> completeTest({
    required String attemptId,
    required int pulse,
  }) async {
    try {
      final request = CompleteTestRequestDto(pulse: pulse);
      await _apiClient.completeTest(attemptId, request);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('CompleteTest failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }
}
