import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/profile/data/remote/profile_parameters_api_client.dart';
import 'package:moveup_flutter/features/profile/data/repositories/profile_parameters_repository_impl.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_gender.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_parameters_repository.dart';

import '../../support/profile_dto_fixtures.dart';
import '../../support/profile_parameters_dto_fixtures.dart';
import 'profile_parameters_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<ProfileParametersApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockProfileParametersApiClient apiClient;
  late ProfileParametersRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockProfileParametersApiClient();
    repository = ProfileParametersRepositoryImpl(logger, apiClient);
  });

  group('ProfileParametersRepositoryImpl', () {
    group('getReferences()', () {
      test('returns success(data) when api succeeds', () async {
        // Arrange
        when(
          apiClient.getReferences(),
        ).thenAnswer((_) async => createProfileParametersReferencesResponseDto());

        // Act
        final result = await repository.getReferences();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfileParametersReferences);

        verify(apiClient.getReferences()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api fails', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/user-parameters/references',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getReferences()).thenThrow(exception);

        // Act
        final result = await repository.getReferences();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getReferences()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getReferences()).thenThrow(exception);

        // Act
        final result = await repository.getReferences();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getReferences()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('getCurrentParameters()', () {
      test('returns success(data) when api succeeds', () async {
        // Arrange
        when(
          apiClient.getCurrentParameters(),
        ).thenAnswer((_) async => createProfileCurrentParametersResponseDto());

        // Act
        final result = await repository.getCurrentParameters();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfileParametersData);

        verify(apiClient.getCurrentParameters()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api fails', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/user-parameters/me',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getCurrentParameters()).thenThrow(exception);

        // Act
        final result = await repository.getCurrentParameters();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getCurrentParameters()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getCurrentParameters()).thenThrow(exception);

        // Act
        final result = await repository.getCurrentParameters();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getCurrentParameters()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('saveParameters()', () {
      test('returns refreshed data when only goal changed', () async {
        // Arrange
        when(apiClient.saveGoal(any)).thenAnswer((_) async {});
        when(apiClient.getCurrentParameters()).thenAnswer(
          (_) async => createProfileCurrentParametersResponseDto(
            data: createProfileCurrentParametersDto(goalId: testProfileParametersUpdatedGoalId),
          ),
        );

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.goalId, testProfileParametersUpdatedGoalId);
        expect(result.success!.goalName, testProfileParametersUpdatedGoalName);

        final captured =
            verify(apiClient.saveGoal(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'goal_id': testProfileParametersUpdatedGoalId});
        verify(apiClient.getCurrentParameters()).called(1);
        verifyNever(apiClient.saveAnthropometry(any));
        verifyNever(apiClient.saveLevel(any));
        verifyNever(apiClient.updateWeeklyGoal(any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns refreshed data when only anthropometry changed', () async {
        // Arrange
        when(apiClient.saveAnthropometry(any)).thenAnswer((_) async {});
        when(apiClient.getCurrentParameters()).thenAnswer(
          (_) async => createProfileCurrentParametersResponseDto(
            data: createProfileCurrentParametersDto(
              equipmentId: testProfileParametersUpdatedEquipmentId,
              gender: 'male',
              age: 24,
              weight: 73.5,
              height: 180,
            ),
          ),
        );

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            gender: ProfileParametersGender.male,
            age: 24,
            weight: 73.5,
            height: 180,
            equipmentId: testProfileParametersUpdatedEquipmentId,
          ),
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.gender, ProfileParametersGender.male);
        expect(result.success!.equipmentId, testProfileParametersUpdatedEquipmentId);

        final captured =
            verify(
                  apiClient.saveAnthropometry(captureAny),
                ).captured.single
                as Map<String, dynamic>;
        expect(captured, {
          'gender': 'male',
          'age': 24,
          'weight': 73.5,
          'height': 180,
          'equipment_id': testProfileParametersUpdatedEquipmentId,
        });
        verify(apiClient.getCurrentParameters()).called(1);
        verifyNever(apiClient.saveGoal(any));
        verifyNever(apiClient.saveLevel(any));
        verifyNever(apiClient.updateWeeklyGoal(any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns refreshed data when only level changed', () async {
        // Arrange
        when(apiClient.saveLevel(any)).thenAnswer((_) async {});
        when(apiClient.getCurrentParameters()).thenAnswer(
          (_) async => createProfileCurrentParametersResponseDto(
            data: createProfileCurrentParametersDto(levelId: testProfileParametersUpdatedLevelId),
          ),
        );

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            levelId: testProfileParametersUpdatedLevelId,
          ),
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.levelId, testProfileParametersUpdatedLevelId);
        expect(result.success!.levelName, testProfileParametersUpdatedLevelName);

        final captured =
            verify(apiClient.saveLevel(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'level_id': testProfileParametersUpdatedLevelId});
        verify(apiClient.getCurrentParameters()).called(1);
        verifyNever(apiClient.saveGoal(any));
        verifyNever(apiClient.saveAnthropometry(any));
        verifyNever(apiClient.updateWeeklyGoal(any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns refreshed data when only weekly goal changed', () async {
        // Arrange
        when(apiClient.updateWeeklyGoal(any)).thenAnswer((_) async {});
        when(
          apiClient.getCurrentParameters(),
        ).thenAnswer((_) async => createProfileCurrentParametersResponseDto());

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            weeklyGoal: testProfileParametersUpdatedWeeklyGoal,
          ),
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfileParametersData);

        final captured =
            verify(apiClient.updateWeeklyGoal(captureAny)).captured.single as Map<String, dynamic>;
        expect(captured, {'weekly_goal': testProfileParametersUpdatedWeeklyGoal});
        verify(apiClient.getCurrentParameters()).called(1);
        verifyNever(apiClient.saveGoal(any));
        verifyNever(apiClient.saveAnthropometry(any));
        verifyNever(apiClient.saveLevel(any));
        verifyNoMoreInteractions(apiClient);
      });

      test('calls changed endpoints in fixed order for combined changes', () async {
        // Arrange
        when(apiClient.saveGoal(any)).thenAnswer((_) async {});
        when(apiClient.saveAnthropometry(any)).thenAnswer((_) async {});
        when(apiClient.saveLevel(any)).thenAnswer((_) async {});
        when(apiClient.updateWeeklyGoal(any)).thenAnswer((_) async {});
        when(
          apiClient.getCurrentParameters(),
        ).thenAnswer((_) async => createProfileCurrentParametersResponseDto());

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
            gender: ProfileParametersGender.male,
            age: 24,
            weight: 73.5,
            height: 180,
            equipmentId: testProfileParametersUpdatedEquipmentId,
            levelId: testProfileParametersUpdatedLevelId,
            weeklyGoal: testProfileParametersUpdatedWeeklyGoal,
          ),
        );

        // Assert
        expect(result.isSuccess, isTrue);

        verifyInOrder([
          apiClient.saveGoal({'goal_id': testProfileParametersUpdatedGoalId}),
          apiClient.saveAnthropometry({
            'gender': 'male',
            'age': 24,
            'weight': 73.5,
            'height': 180,
            'equipment_id': testProfileParametersUpdatedEquipmentId,
          }),
          apiClient.saveLevel({'level_id': testProfileParametersUpdatedLevelId}),
          apiClient.updateWeeklyGoal({'weekly_goal': testProfileParametersUpdatedWeeklyGoal}),
          apiClient.getCurrentParameters(),
        ]);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns current data without requests when nothing changed', () async {
        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: testProfileParametersSubmitPayload,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, testProfileParametersData);
        verifyNever(apiClient.saveGoal(any));
        verifyNever(apiClient.saveAnthropometry(any));
        verifyNever(apiClient.saveLevel(any));
        verifyNever(apiClient.updateWeeklyGoal(any));
        verifyNever(apiClient.getCurrentParameters());
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.saveGoal(any)).thenThrow(exception);

        // Act
        final result = await repository.saveParameters(
          currentParameters: testProfileParametersData,
          currentWeeklyGoal: testProfileParametersWeeklyGoal,
          payload: createProfileParametersSubmitPayload(
            goalId: testProfileParametersUpdatedGoalId,
          ),
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.saveGoal(any)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
