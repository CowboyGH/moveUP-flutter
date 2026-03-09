import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/forgot_password_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/forgot_password_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_forgot_password_test.mocks.dart';

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

  group('AuthRepositoryImpl.forgotPassword', () {
    const email = 'test@mail.com';

    late ForgotPasswordResponseDto forgotPasswordResponseDto;

    setUp(() {
      forgotPasswordResponseDto = ForgotPasswordResponseDto(
        success: true,
        message: 'success_message',
      );
    });

    test('returns success when api forgot-password succeeds', () async {
      // Arrange
      when(apiClient.forgotPassword(any)).thenAnswer((_) async => forgotPasswordResponseDto);

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isSuccess, isTrue);

      _verifyForgotPasswordRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'email': ['The email field is required.'],
      };
      final exception = createDioBadResponseException(
        path: '/forgot-password',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.forgotPassword(any)).thenThrow(exception);

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure.parentException, isA<DioException>());
      expect(failure, isA<ValidationFailedFailure>());
      expect((failure as ValidationFailedFailure).fieldErrors, errors);

      _verifyForgotPasswordRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.forgotPassword(any)).thenThrow(unknownException);

      // Act
      final result = await repository.forgotPassword(email);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyForgotPasswordRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyForgotPasswordRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
) {
  final captured =
      verify(apiClient.forgotPassword(captureAny)).captured.single as ForgotPasswordRequestDto;
  expect(captured.email, expectedEmail);
}
