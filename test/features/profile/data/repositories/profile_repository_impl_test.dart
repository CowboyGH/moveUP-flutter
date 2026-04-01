import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/data/dto/change_password_request_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/update_profile_request_dto.dart';
import 'package:moveup_flutter/features/profile/data/remote/profile_api_client.dart';
import 'package:moveup_flutter/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_gender.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_phase_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';

import '../../support/profile_dto_fixtures.dart';
import 'profile_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<ProfileApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockProfileApiClient apiClient;
  late ProfileRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockProfileApiClient();
    repository = ProfileRepositoryImpl(logger, apiClient);
  });

  group('ProfileRepositoryImpl', () {
    group('getUser', () {
      test('returns success(user) when api succeeds', () async {
        // Arrange
        final responseDto = createProfileUserResponseDto();
        when(apiClient.getProfile()).thenAnswer((_) async => responseDto);

        // Act
        final result = await repository.getUser();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, createProfileUser());

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api returns server error', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/profile',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getUser();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getUser();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('updateUser', () {
      test('returns currentUser without network calls when nothing changed', () async {
        // Arrange
        const currentUser = User(
          id: testProfileUserId,
          name: testProfileUserName,
          email: testProfileUserEmail,
          avatar: testProfileUserAvatar,
        );

        // Act
        final result = await repository.updateUser(
          currentUser: currentUser,
          name: testProfileUserName,
          email: testProfileUserEmail,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, currentUser);
        verifyNever(apiClient.getProfile());
        verifyNever(apiClient.updateProfile(any));
        verifyNever(apiClient.uploadAvatar(any));
        verifyNever(apiClient.changePassword(any));
      });

      test('updates name and email only', () async {
        // Arrange
        const currentUser = User(
          id: testProfileUserId,
          name: testProfileUserName,
          email: testProfileUserEmail,
          avatar: testProfileUserAvatar,
        );
        final refreshedUser = createProfileUserDto(
          name: 'test_name',
          email: 'test@mail.com',
        );
        when(apiClient.updateProfile(any)).thenAnswer((_) async {});
        when(
          apiClient.getProfile(),
        ).thenAnswer((_) async => createProfileUserResponseDto(user: refreshedUser));

        // Act
        final result = await repository.updateUser(
          currentUser: currentUser,
          name: 'test_name',
          email: 'test@mail.com',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createProfileUser(
            name: 'test_name',
            email: 'test@mail.com',
          ),
        );

        final captured =
            verify(apiClient.updateProfile(captureAny)).captured.single as UpdateProfileRequestDto;
        expect(captured.name, 'test_name');
        expect(captured.email, 'test@mail.com');
        verifyNever(apiClient.uploadAvatar(any));
        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('updates avatar only', () async {
        // Arrange
        const currentUser = User(
          id: testProfileUserId,
          name: testProfileUserName,
          email: testProfileUserEmail,
        );
        final tempDirectory = await Directory.systemTemp.createTemp('test');
        final avatarFile = File('${tempDirectory.path}/avatar.jpg');
        await avatarFile.writeAsString('avatar');
        when(apiClient.uploadAvatar(any)).thenAnswer((_) async {});
        when(apiClient.getProfile()).thenAnswer(
          (_) async => createProfileUserResponseDto(
            user: createProfileUserDto(avatarUrl: 'new-avatar.jpg'),
          ),
        );

        addTearDown(() async {
          await tempDirectory.delete(recursive: true);
        });

        // Act
        final result = await repository.updateUser(
          currentUser: currentUser,
          name: currentUser.name,
          email: currentUser.email,
          avatarPath: avatarFile.path,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success!.avatar, 'new-avatar.jpg');

        verify(apiClient.uploadAvatar(any)).called(1);
        verifyNever(apiClient.updateProfile(any));
        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('updates avatar and text fields in one save flow', () async {
        // Arrange
        const currentUser = User(
          id: testProfileUserId,
          name: testProfileUserName,
          email: testProfileUserEmail,
        );
        final tempDirectory = await Directory.systemTemp.createTemp('profile_repository_test');
        final avatarFile = File('${tempDirectory.path}/avatar.jpg');
        await avatarFile.writeAsString('avatar');
        when(apiClient.uploadAvatar(any)).thenAnswer((_) async {});
        when(apiClient.updateProfile(any)).thenAnswer((_) async {});
        when(apiClient.getProfile()).thenAnswer(
          (_) async => createProfileUserResponseDto(
            user: createProfileUserDto(
              name: 'test_name',
              email: 'test@mail.com',
              avatarUrl: 'new-avatar.jpg',
            ),
          ),
        );

        addTearDown(() async {
          await tempDirectory.delete(recursive: true);
        });

        // Act
        final result = await repository.updateUser(
          currentUser: currentUser,
          name: 'test_name',
          email: 'test@mail.com',
          avatarPath: avatarFile.path,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          createProfileUser(
            name: 'test_name',
            email: 'test@mail.com',
            avatar: 'new-avatar.jpg',
          ),
        );

        verify(apiClient.uploadAvatar(any)).called(1);
        verify(apiClient.updateProfile(any)).called(1);
        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('getStatsHistorySnapshot', () {
      test('returns snapshot from cache after getUser succeeds', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            subscriptions: createProfileSubscriptionsDto(),
            workouts: createProfileWorkoutsDto(),
            tests: createProfileTestsDto(),
          ),
        );

        // Act
        final getUserResult = await repository.getUser();
        final historyResult = await repository.getStatsHistorySnapshot();

        // Assert
        expect(getUserResult.isSuccess, isTrue);
        expect(historyResult.isSuccess, isTrue);
        expect(historyResult.success, createProfileStatsHistorySnapshot());

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns latest sorted workout and test when cache is empty', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            subscriptions: createProfileSubscriptionsDto(),
            workouts: createProfileWorkoutsDto(
              history: [
                createProfileWorkoutHistoryItemDto(
                  id: 1,
                  title: 'older workout',
                  completedAt: '2026-03-10 10:30:00',
                ),
                createProfileWorkoutHistoryItemDto(
                  id: 2,
                  title: 'latest workout',
                ),
              ],
            ),
            tests: createProfileTestsDto(
              history: [
                createProfileTestHistoryItemDto(
                  attemptId: 1,
                  title: 'older test',
                  completedAt: '2026-03-12 15:20:00',
                ),
                createProfileTestHistoryItemDto(
                  attemptId: 2,
                  title: 'latest test',
                ),
              ],
            ),
          ),
        );

        // Act
        final result = await repository.getStatsHistorySnapshot();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          const ProfileStatsHistorySnapshot(
            activeSubscription: ProfileActiveSubscriptionSnapshot(
              id: testProfileSubscriptionId,
              name: testProfileSubscriptionName,
              price: testProfileSubscriptionPrice,
              startDate: testProfileSubscriptionStartDate,
              endDate: testProfileSubscriptionEndDate,
            ),
            latestWorkout: ProfileLatestWorkoutSnapshot(
              id: 2,
              title: 'latest workout',
              completedAt: '2026-03-15 10:30:00',
            ),
            latestTest: ProfileLatestTestSnapshot(
              attemptId: 2,
              title: 'latest test',
              completedAt: '2026-03-14 15:20:00',
            ),
          ),
        );

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('warms parameters cache from the same /profile response', () async {
        // Arrange
        when(apiClient.getProfile()).thenAnswer(
          (_) async => createProfileUserResponseDto(
            subscriptions: createProfileSubscriptionsDto(),
            workouts: createProfileWorkoutsDto(),
            tests: createProfileTestsDto(),
            parameters: createProfileParametersInProfileDto(),
          ),
        );

        // Act
        final historyResult = await repository.getStatsHistorySnapshot();
        final parametersResult = await repository.getParametersSnapshot();

        // Assert
        expect(historyResult.isSuccess, isTrue);
        expect(parametersResult.isSuccess, isTrue);
        expect(parametersResult.success, createProfileParametersSnapshot());

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api returns server error', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/profile',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getStatsHistorySnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getStatsHistorySnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('getPhaseSnapshot', () {
      test('returns snapshot from cache after getUser succeeds', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            phase: createProfilePhaseDto(),
          ),
        );

        // Act
        final getUserResult = await repository.getUser();
        final phaseResult = await repository.getPhaseSnapshot();

        // Assert
        expect(getUserResult.isSuccess, isTrue);
        expect(phaseResult.isSuccess, isTrue);
        expect(phaseResult.success, createProfilePhaseSnapshot());

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns phase snapshot from /profile when cache is empty', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            phase: createProfilePhaseDto(
              currentPhase: createProfileCurrentPhaseDto(
                id: 12,
                name: 'B2',
              ),
            ),
          ),
        );

        // Act
        final result = await repository.getPhaseSnapshot();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          const ProfilePhaseSnapshot(
            hasProgress: true,
            currentPhaseName: 'B2',
          ),
        );

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api returns server error', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/profile',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getPhaseSnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getPhaseSnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('getParametersSnapshot', () {
      test('returns snapshot from cache after getUser succeeds', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            parameters: createProfileParametersInProfileDto(),
          ),
        );

        // Act
        final getUserResult = await repository.getUser();
        final parametersResult = await repository.getParametersSnapshot();

        // Assert
        expect(getUserResult.isSuccess, isTrue);
        expect(parametersResult.isSuccess, isTrue);
        expect(parametersResult.success, createProfileParametersSnapshot());

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns parameters snapshot from /profile when cache is empty', () async {
        // Arrange
        when(
          apiClient.getProfile(),
        ).thenAnswer(
          (_) async => createProfileUserResponseDto(
            parameters: createProfileParametersInProfileDto(
              goal: 'Снижение веса',
              gender: 'male',
              age: 24,
              weight: 73.5,
              height: 180,
              equipment: 'Зал',
              level: 'Начинающий',
            ),
          ),
        );

        // Act
        final result = await repository.getParametersSnapshot();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.success,
          const ProfileParametersSnapshot(
            goal: 'Снижение веса',
            gender: ProfileParametersGender.male,
            age: 24,
            weight: 73.5,
            height: 180,
            equipment: 'Зал',
            level: 'Начинающий',
          ),
        );

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('does not refetch when server parameters are null', () async {
        // Arrange
        when(apiClient.getProfile()).thenAnswer(
          (_) async => createProfileUserResponseDto(),
        );

        // Act
        final firstResult = await repository.getParametersSnapshot();
        final secondResult = await repository.getParametersSnapshot();

        // Assert
        expect(firstResult.isSuccess, isTrue);
        expect(firstResult.success, isNull);
        expect(secondResult.isSuccess, isTrue);
        expect(secondResult.success, isNull);

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileRequestFailure when api returns server error', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/profile',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getParametersSnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getProfile()).thenThrow(exception);

        // Act
        final result = await repository.getParametersSnapshot();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getProfile()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('changePassword', () {
      test('returns success when api succeeds', () async {
        // Arrange
        when(apiClient.changePassword(any)).thenAnswer((_) async {});

        // Act
        final result = await repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        );

        // Assert
        expect(result.isSuccess, isTrue);
        final captured =
            verify(apiClient.changePassword(captureAny)).captured.single
                as ChangePasswordRequestDto;
        expect(captured.oldPassword, 'oldPass123');
        expect(captured.newPassword, 'newPass123');
        expect(captured.newPasswordConfirmation, 'newPass123');
        verifyNoMoreInteractions(apiClient);
      });

      test('returns ProfileValidationFailure when api returns 422', () async {
        // Arrange
        final exception = createProfileDioBadResponseException(
          path: '/api/profile/change-password',
          statusCode: 422,
          code: 'validation_failed',
          errors: const {
            'test': ['message'],
          },
        );
        when(apiClient.changePassword(any)).thenThrow(exception);

        // Act
        final result = await repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ProfileValidationFailure>());
        expect(result.failure!.message, 'message');
        expect(result.failure!.parentException, exception);

        verify(apiClient.changePassword(any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownProfileFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.changePassword(any)).thenThrow(exception);

        // Act
        final result = await repository.changePassword(
          oldPassword: 'oldPass123',
          newPassword: 'newPass123',
          newPasswordConfirmation: 'newPass123',
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownProfileFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.changePassword(any)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
