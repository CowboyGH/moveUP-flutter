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
