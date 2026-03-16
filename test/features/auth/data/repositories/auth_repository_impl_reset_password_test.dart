import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/reset_password_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_reset_password_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<AuthApiClient>(),
  MockSpec<TokenStorage>(),
])
void main() {
  late MockAppLogger logger;
  late MockAuthApiClient apiClient;
  late MockTokenStorage tokenStorage;
  late AuthRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockAuthApiClient();
    tokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(logger, apiClient, tokenStorage);
  });

  group('AuthRepositoryImpl.resetPassword', () {
    const email = 'test@mail.com';
    const code = '123456';
    const password = 'test_password';
    const passwordConfirmation = 'test_password';

    test('returns success when api reset-password succeeds', () async {
      // Arrange
      when(apiClient.resetPassword(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.resetPassword(
        email,
        code,
        password,
        passwordConfirmation,
      );

      // Assert
      expect(result.isSuccess, isTrue);

      _verifyResetPasswordRequest(
        apiClient,
        email,
        code,
        password,
        passwordConfirmation,
      );
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'password': ['The password field is required.'],
      };
      final exception = createDioBadResponseException(
        path: '/reset-password',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.resetPassword(any)).thenThrow(exception);

      // Act
      final result = await repository.resetPassword(
        email,
        code,
        password,
        passwordConfirmation,
      );

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.parentException, isA<DioException>());
      expect(failure.message, 'The password field is required.');

      _verifyResetPasswordRequest(
        apiClient,
        email,
        code,
        password,
        passwordConfirmation,
      );
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.resetPassword(any)).thenThrow(unknownException);

      // Act
      final result = await repository.resetPassword(
        email,
        code,
        password,
        passwordConfirmation,
      );

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyResetPasswordRequest(
        apiClient,
        email,
        code,
        password,
        passwordConfirmation,
      );
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyResetPasswordRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
  String expectedCode,
  String expectedPassword,
  String expectedPasswordConfirmation,
) {
  final captured =
      verify(apiClient.resetPassword(captureAny)).captured.single as ResetPasswordRequestDto;
  expect(captured.email, expectedEmail);
  expect(captured.code, expectedCode);
  expect(captured.password, expectedPassword);
  expect(captured.passwordConfirmation, expectedPasswordConfirmation);
}
