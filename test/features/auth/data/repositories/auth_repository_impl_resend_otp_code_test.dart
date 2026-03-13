import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/resend_verification_code_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/entities/otp_resend_flow.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_resend_otp_code_test.mocks.dart';

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

  group('AuthRepositoryImpl.resendOtpCode', () {
    const email = 'test@mail.com';
    const emailVerificationFlow = OtpResendFlow.emailVerification;
    const resetPasswordFlow = OtpResendFlow.resetPassword;

    test('returns success when api resend-verification-code succeeds', () async {
      // Arrange
      when(apiClient.resendVerificationCode(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.resendOtpCode(email, emailVerificationFlow);

      // Assert
      expect(result.isSuccess, isTrue);

      _verifyResendVerificationCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'email': ['The email field is required.'],
      };
      final exception = createDioBadResponseException(
        path: '/resend-verification-code',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.resendVerificationCode(any)).thenThrow(exception);

      // Act
      final result = await repository.resendOtpCode(email, emailVerificationFlow);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.parentException, isA<DioException>());
      expect((failure as ValidationFailedFailure).fieldErrors, errors);

      _verifyResendVerificationCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.resendVerificationCode(any)).thenThrow(unknownException);

      // Act
      final result = await repository.resendOtpCode(email, emailVerificationFlow);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyResendVerificationCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns success when api resend-reset-code succeeds', () async {
      // Arrange
      when(apiClient.resendResetCode(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.resendOtpCode(email, resetPasswordFlow);

      // Assert
      expect(result.isSuccess, isTrue);

      _verifyResendResetCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api resend-reset-code returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'email': ['The email field is required.'],
      };
      final exception = createDioBadResponseException(
        path: '/resend-reset-code',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.resendResetCode(any)).thenThrow(exception);

      // Act
      final result = await repository.resendOtpCode(email, resetPasswordFlow);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.parentException, isA<DioException>());
      expect((failure as ValidationFailedFailure).fieldErrors, errors);

      _verifyResendResetCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when api resend-reset-code throws unexpected exception', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.resendResetCode(any)).thenThrow(unknownException);

      // Act
      final result = await repository.resendOtpCode(email, resetPasswordFlow);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyResendResetCodeRequest(apiClient, email);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyResendVerificationCodeRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
) {
  final captured =
      verify(apiClient.resendVerificationCode(captureAny)).captured.single
          as ResendVerificationCodeRequestDto;
  expect(captured.email, expectedEmail);
}

void _verifyResendResetCodeRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
) {
  final captured =
      verify(apiClient.resendResetCode(captureAny)).captured.single
          as ResendVerificationCodeRequestDto;
  expect(captured.email, expectedEmail);
}
