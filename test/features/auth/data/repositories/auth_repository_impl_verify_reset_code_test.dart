import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/verify_reset_code_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_verify_reset_code_test.mocks.dart';

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

  group('AuthRepositoryImpl.verifyResetCode', () {
    const email = 'test@mail.com';
    const code = '123456';

    test('returns success when api verify-reset-code succeeds', () async {
      // Arrange
      when(apiClient.verifyResetCode(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.verifyResetCode(email, code);

      // Assert
      expect(result.isSuccess, isTrue);

      _verifyVerifyResetCodeRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 400 validation_failed', () async {
      // Arrange
      final exception = createDioBadResponseException(
        path: '/verify-reset-code',
        statusCode: 400,
        code: 'validation_failed',
      );
      when(apiClient.verifyResetCode(any)).thenThrow(exception);

      // Act
      final result = await repository.verifyResetCode(email, code);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.parentException, isA<DioException>());

      _verifyVerifyResetCodeRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.verifyResetCode(any)).thenThrow(unknownException);

      // Act
      final result = await repository.verifyResetCode(email, code);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyVerifyResetCodeRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyVerifyResetCodeRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
  String expectedCode,
) {
  final captured =
      verify(apiClient.verifyResetCode(captureAny)).captured.single as VerifyResetCodeRequestDto;
  expect(captured.email, expectedEmail);
  expect(captured.code, expectedCode);
}
