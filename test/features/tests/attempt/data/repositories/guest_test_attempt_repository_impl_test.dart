import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/complete_guest_test_request_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/save_guest_test_result_request_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/repositories/guest_test_attempt_repository_impl.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/repositories/test_attempt_repository.dart';
import 'package:moveup_flutter/features/tests/data/remote/tests_api_client.dart';

import '../../../catalog/support/testings_dto_fixtures.dart';
import '../../support/test_attempt_dto_fixtures.dart';
import 'guest_test_attempt_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<TestsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockTestsApiClient apiClient;
  late TestAttemptRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockTestsApiClient();
    repository = GuestTestAttemptRepositoryImpl(logger, apiClient);
  });

  group('GuestTestAttemptRepositoryImpl', () {
    group('GuestTestAttemptRepositoryImpl.startTest', () {
      test('returns success(start) when api succeeds', () async {
        final responseDto = createStartGuestTestResponseDto();
        final expectedStart = createTestAttemptStart();
        when(apiClient.startGuestTest(8)).thenAnswer((_) async => responseDto);

        final result = await repository.startTest(8);

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedStart);

        verify(apiClient.startGuestTest(8)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns TestsRequestFailure when api returns server error', () async {
        final exception = createTestsDioBadResponseException(
          path: '/guest/tests/8/start',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.startGuestTest(8)).thenThrow(exception);

        final result = await repository.startTest(8);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<TestsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.startGuestTest(8)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownTestsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.startGuestTest(8)).thenThrow(exception);

        final result = await repository.startTest(8);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownTestsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.startGuestTest(8)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('GuestTestAttemptRepositoryImpl.saveResult', () {
      test('returns success(result) when api succeeds with next exercise', () async {
        final responseDto = createSaveGuestTestResultResponseDto(
          nextExercise: createTestingExerciseDto(id: 17, orderNumber: 2),
          allExercisesCompleted: false,
        );
        final expectedResult = createTestAttemptNextExerciseResult();
        when(apiClient.saveGuestTestResult(any, any)).thenAnswer((_) async => responseDto);

        final result = await repository.saveResult(
          attemptId: 'guest_attempt_1',
          testingExerciseId: 16,
          resultValue: 2,
        );

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedResult);

        final captured = verify(
          apiClient.saveGuestTestResult(captureAny, captureAny),
        ).captured;
        expect(captured.first, 'guest_attempt_1');
        expect((captured.last as SaveGuestTestResultRequestDto).toJson(), {
          'testing_exercise_id': 16,
          'result_value': 2,
        });
        verifyNoMoreInteractions(apiClient);
      });

      test('returns success(result) when all exercises are completed', () async {
        final responseDto = createSaveGuestTestResultResponseDto(
          allExercisesCompleted: true,
          message: 'Все упражнения выполнены. Введите пульс для завершения теста.',
        );
        final expectedResult = createTestAttemptAwaitingPulseResult();
        when(apiClient.saveGuestTestResult(any, any)).thenAnswer((_) async => responseDto);

        final result = await repository.saveResult(
          attemptId: 'guest_attempt_1',
          testingExerciseId: 16,
          resultValue: 4,
        );

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedResult);

        verify(apiClient.saveGuestTestResult(any, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownTestsFailure when api returns malformed payload', () async {
        final responseDto = createSaveGuestTestResultResponseDto();
        when(apiClient.saveGuestTestResult(any, any)).thenAnswer((_) async => responseDto);

        final result = await repository.saveResult(
          attemptId: 'guest_attempt_1',
          testingExerciseId: 16,
          resultValue: 4,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownTestsFailure>());
        expect(result.failure!.parentException, isA<StateError>());

        verify(apiClient.saveGuestTestResult(any, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('GuestTestAttemptRepositoryImpl.completeTest', () {
      test('returns success(void) when api succeeds', () async {
        when(apiClient.completeGuestTest(any, any)).thenAnswer((_) async {});

        final result = await repository.completeTest(
          attemptId: 'guest_attempt_1',
          pulse: 151,
        );

        expect(result.isSuccess, isTrue);

        final captured = verify(apiClient.completeGuestTest(captureAny, captureAny)).captured;
        expect(captured.first, 'guest_attempt_1');
        expect((captured.last as CompleteGuestTestRequestDto).toJson(), {
          'pulse': 151,
        });
        verifyNoMoreInteractions(apiClient);
      });

      test('returns TestsValidationFailure when api returns 422', () async {
        final exception = createTestsDioBadResponseException(
          path: '/guest/test-attempts/guest_attempt_1/complete',
          statusCode: 422,
          code: 'validation_failed',
          errors: const {
            'pulse': ['Пульс должен быть от 30 до 220'],
          },
        );
        when(apiClient.completeGuestTest(any, any)).thenThrow(exception);

        final result = await repository.completeTest(
          attemptId: 'guest_attempt_1',
          pulse: 151,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<TestsValidationFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.completeGuestTest(any, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownTestsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.completeGuestTest(any, any)).thenThrow(exception);

        final result = await repository.completeTest(
          attemptId: 'guest_attempt_1',
          pulse: 151,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownTestsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.completeGuestTest(any, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
