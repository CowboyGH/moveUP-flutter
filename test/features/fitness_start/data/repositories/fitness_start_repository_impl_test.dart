import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/fitness_start/fitness_start_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/fitness_start/data/dto/save_user_parameter_step_response_dto.dart';
import 'package:moveup_flutter/features/fitness_start/data/remote/fitness_start_api_client.dart';
import 'package:moveup_flutter/features/fitness_start/data/repositories/fitness_start_repository_impl.dart';
import 'package:moveup_flutter/features/fitness_start/domain/entities/fitness_start_gender.dart';
import 'package:moveup_flutter/features/fitness_start/domain/repositories/fitness_start_repository.dart';

import '../../support/fitness_start_dto_fixtures.dart';
import 'fitness_start_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<FitnessStartApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockFitnessStartApiClient apiClient;
  late FitnessStartRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockFitnessStartApiClient();
    repository = FitnessStartRepositoryImpl(logger, apiClient);
  });

  group('FitnessStartRepositoryImpl', () {
    group('FitnessStartRepositoryImpl.getReferences', () {
      test('returns success(references) when api succeeds', () async {
        final responseDto = createFitnessStartReferencesResponseDto();
        final expectedReferences = createFitnessStartReferences();
        when(apiClient.getReferences()).thenAnswer((_) async => responseDto);

        final result = await repository.getReferences();

        expect(result.isSuccess, isTrue);
        expect(result.success!.goals, hasLength(2));
        expect(result.success!.levels, hasLength(2));
        expect(result.success!.equipment, hasLength(2));
        expect(result.success!.goals.first, expectedReferences.goals.first);
        expect(result.success!.levels.first, expectedReferences.levels.first);
        expect(result.success!.equipment.first, expectedReferences.equipment.first);

        verify(apiClient.getReferences()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns FitnessStartRequestFailure when api returns server error', () async {
        final exception = createFitnessStartDioBadResponseException(
          path: '/user-parameters/references',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getReferences()).thenThrow(exception);

        final result = await repository.getReferences();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<FitnessStartRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getReferences()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownFitnessStartFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.getReferences()).thenThrow(exception);

        final result = await repository.getReferences();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownFitnessStartFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getReferences()).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('FitnessStartRepositoryImpl.saveGoal', () {
      test('returns success when api succeeds', () async {
        when(
          apiClient.saveGoal(any),
        ).thenAnswer((_) async => SaveUserParameterStepResponseDto());

        final result = await repository.saveGoal(1);

        expect(result.isSuccess, isTrue);

        final captured =
            verify(apiClient.saveGoal(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'goal_id': 1});
        verifyNoMoreInteractions(apiClient);
      });

      test('returns FitnessStartValidationFailure when api returns 422', () async {
        final exception = createFitnessStartDioBadResponseException(
          path: '/user-parameters/goal',
          statusCode: 422,
          code: 'validation_failed',
          errors: const {
            'goal_id': ['error_message'],
          },
        );
        when(apiClient.saveGoal(any)).thenThrow(exception);

        final result = await repository.saveGoal(1);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<FitnessStartValidationFailure>());
        expect(result.failure!.message, 'error_message');

        final captured =
            verify(apiClient.saveGoal(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'goal_id': 1});
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownFitnessStartFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.saveGoal(any)).thenThrow(exception);

        final result = await repository.saveGoal(1);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownFitnessStartFailure>());
        expect(result.failure!.parentException, exception);

        final captured =
            verify(apiClient.saveGoal(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'goal_id': 1});
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('FitnessStartRepositoryImpl.saveAnthropometry', () {
      test('returns success when api succeeds', () async {
        when(apiClient.saveAnthropometry(any)).thenAnswer(
          (_) async => SaveUserParameterStepResponseDto(),
        );

        final result = await repository.saveAnthropometry(
          gender: FitnessStartGender.male,
          age: 27,
          weight: 73.5,
          height: 180,
          equipmentId: 5,
        );

        expect(result.isSuccess, isTrue);

        final captured =
            verify(
                  apiClient.saveAnthropometry(captureAny),
                ).captured.single
                as Map<String, dynamic>;
        expect(captured, {
          'gender': 'male',
          'age': 27,
          'weight': 73.5,
          'height': 180,
          'equipment_id': 5,
        });
        verifyNoMoreInteractions(apiClient);
      });

      test('returns FitnessStartValidationFailure when api returns 422', () async {
        final exception = createFitnessStartDioBadResponseException(
          path: '/user-parameters/anthropometry',
          statusCode: 422,
          code: 'validation_failed',
          errors: const {
            'age': ['Поле age обязательно'],
          },
        );
        when(apiClient.saveAnthropometry(any)).thenThrow(exception);

        final result = await repository.saveAnthropometry(
          gender: FitnessStartGender.female,
          age: 24,
          weight: 55,
          height: 168,
          equipmentId: 6,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<FitnessStartValidationFailure>());
        expect(result.failure!.message, 'Поле age обязательно');

        final captured =
            verify(
                  apiClient.saveAnthropometry(captureAny),
                ).captured.single
                as Map<String, dynamic>;
        expect(captured['gender'], 'female');
        expect(captured['equipment_id'], 6);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownFitnessStartFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.saveAnthropometry(any)).thenThrow(exception);

        final result = await repository.saveAnthropometry(
          gender: FitnessStartGender.male,
          age: 30,
          weight: 80,
          height: 185,
          equipmentId: 5,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownFitnessStartFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.saveAnthropometry(any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('FitnessStartRepositoryImpl.saveLevel', () {
      test('returns success when api succeeds', () async {
        when(
          apiClient.saveLevel(any),
        ).thenAnswer((_) async => SaveUserParameterStepResponseDto());

        final result = await repository.saveLevel(3);

        expect(result.isSuccess, isTrue);

        final captured =
            verify(apiClient.saveLevel(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'level_id': 3});
        verifyNoMoreInteractions(apiClient);
      });

      test('returns FitnessStartValidationFailure when api returns 422', () async {
        final exception = createFitnessStartDioBadResponseException(
          path: '/user-parameters/level',
          statusCode: 422,
          code: 'validation_failed',
          errors: const {
            'level_id': ['Поле level_id обязательно'],
          },
        );
        when(apiClient.saveLevel(any)).thenThrow(exception);

        final result = await repository.saveLevel(3);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<FitnessStartValidationFailure>());
        expect(result.failure!.message, 'Поле level_id обязательно');

        final captured =
            verify(apiClient.saveLevel(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'level_id': 3});
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownFitnessStartFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.saveLevel(any)).thenThrow(exception);

        final result = await repository.saveLevel(3);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownFitnessStartFailure>());
        expect(result.failure!.parentException, exception);

        final captured =
            verify(apiClient.saveLevel(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'level_id': 3});
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
