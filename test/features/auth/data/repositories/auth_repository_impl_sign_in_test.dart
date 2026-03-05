import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/login_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/login_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/login_session_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_sign_in_test.mocks.dart';

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

  group('AuthRepositoryImpl.signIn', () {
    const email = 'test@mail.com';
    const password = 'test_password';
    const accessToken = 'test_access_token';

    late LoginSessionDto loginSessionDto;
    late UserDto userDto;
    late LoginResponseDto loginResponseDto;

    setUp(() {
      loginSessionDto = createLoginSessionDto();
      userDto = createUserDto(email: email);
      loginResponseDto = createLoginResponseDto(
        accessToken: accessToken,
        session: loginSessionDto,
        user: userDto,
      );
    });

    test('returns success and stores access token when api login succeeds', () async {
      // Arrange
      when(apiClient.login(any)).thenAnswer((_) async => loginResponseDto);
      when(
        tokenStorage.saveAccessToken(accessToken),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.signIn(email, password);

      // Assert
      expect(result.isSuccess, isTrue);

      final user = result.success!;
      expect(user.id, 1);
      expect(user.name, 'name');
      expect(user.email, email);
      expect(user.avatar, 'avatar');

      _verifyLoginRequest(apiClient, email, password);
      verifyNoMoreInteractions(apiClient);

      verify(tokenStorage.saveAccessToken(accessToken)).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns InvalidCredentialsFailure when api returns 401 invalid_credentials', () async {
      // Arrange
      final exception = createDioBadResponseException(
        path: '/login',
        statusCode: 401,
        code: 'invalid_credentials',
        message: 'Invalid credentials',
      );
      when(apiClient.login(any)).thenThrow(exception);

      // Act
      final result = await repository.signIn(email, password);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure.parentException, isA<DioException>());
      expect(failure, isA<InvalidCredentialsFailure>());

      _verifyLoginRequest(apiClient, email, password);
      verifyNoMoreInteractions(apiClient);
      verifyNever(tokenStorage.saveAccessToken(accessToken));
    });

    test('returns UnknownAuthFailure when token storage fails', () async {
      // Arrange
      when(apiClient.login(any)).thenAnswer((_) async => loginResponseDto);
      final storageException = Exception('storage_failed');
      when(tokenStorage.saveAccessToken(accessToken)).thenThrow(storageException);

      // Act
      final result = await repository.signIn(email, password);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure.parentException, storageException);
      expect(failure, isA<UnknownAuthFailure>());

      _verifyLoginRequest(apiClient, email, password);
      verifyNoMoreInteractions(apiClient);
      verify(tokenStorage.saveAccessToken(accessToken)).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyLoginRequest(
  MockAuthApiClient apiClient,
  String expectedEmail,
  String expectedPassword,
) {
  final captured = verify(apiClient.login(captureAny)).captured.single as LoginRequestDto;
  expect(captured.email, expectedEmail);
  expect(captured.password, expectedPassword);
}
