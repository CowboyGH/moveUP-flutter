import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/verify_email_auth_data_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/verify_email_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/verify_email_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_verify_email_test.mocks.dart';

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

  group('AuthRepositoryImpl.verifyEmail', () {
    const email = 'test@mail.com';
    const code = '123456';
    const accessToken = 'test_access_token';

    late UserDto userDto;
    late VerifyEmailResponseDto verifyEmailResponseDto;

    setUp(() {
      userDto = createUserDto(email: email, avatar: null);
      verifyEmailResponseDto = _createVerifyEmailResponseDto(user: userDto);
    });

    test('returns success(user) and stores access token when api verify-email succeeds', () async {
      // Arrange
      when(apiClient.verifyEmail(any)).thenAnswer((_) async => verifyEmailResponseDto);
      when(tokenStorage.saveAccessToken(accessToken)).thenAnswer((_) async {});

      // Act
      final result = await repository.verifyEmail(email, code);

      // Assert
      expect(result.isSuccess, isTrue);

      final user = result.success!;
      expect(user.id, userDto.id);
      expect(user.name, userDto.name);
      expect(user.email, userDto.email);
      expect(user.avatar, userDto.avatar);

      _verifyVerifyEmailRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verify(tokenStorage.saveAccessToken(accessToken)).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'code': ['The code field is required.'],
      };
      final exception = createDioBadResponseException(
        path: '/verify-email',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.verifyEmail(any)).thenThrow(exception);

      // Act
      final result = await repository.verifyEmail(email, code);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<ValidationFailedFailure>());
      expect(failure.parentException, isA<DioException>());
      expect((failure as ValidationFailedFailure).fieldErrors, errors);

      _verifyVerifyEmailRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.verifyEmail(any)).thenThrow(unknownException);

      // Act
      final result = await repository.verifyEmail(email, code);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyVerifyEmailRequest(apiClient, email, code);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

VerifyEmailResponseDto _createVerifyEmailResponseDto({
  bool success = true,
  String message = 'Email успешно подтвержден.',
  String accessToken = 'test_access_token',
  String tokenType = 'bearer',
  int expiresIn = 3600,
  required UserDto user,
}) => VerifyEmailResponseDto(
  success: success,
  message: message,
  data: VerifyEmailAuthDataDto(
    accessToken: accessToken,
    tokenType: tokenType,
    expiresIn: expiresIn,
    user: user,
  ),
);

void _verifyVerifyEmailRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
  String expectedCode,
) {
  final captured =
      verify(apiClient.verifyEmail(captureAny)).captured.single as VerifyEmailRequestDto;
  expect(captured.email, expectedEmail);
  expect(captured.code, expectedCode);
}
