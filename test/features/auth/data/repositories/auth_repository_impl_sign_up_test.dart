import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/register_request_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/register_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_sign_up_test.mocks.dart';

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

  group('AuthRepositoryImpl.signUp', () {
    const name = 'name';
    const email = 'test@mail.com';
    const password = 'test_password';

    late UserDto userDto;
    late RegisterResponseDto registerResponseDto;

    setUp(() {
      userDto = createUserDto(avatar: null);
      registerResponseDto = RegisterResponseDto(
        success: true,
        message: 'success_message',
        user: userDto,
      );
    });

    test('returns success(user) when api register succeeds', () async {
      // Arrange
      when(apiClient.register(any)).thenAnswer((_) async => registerResponseDto);

      // Act
      final result = await repository.signUp(name, email, password);

      // Assert
      expect(result.isSuccess, isTrue);

      final user = result.success!;
      expect(user.id, userDto.id);
      expect(user.name, userDto.name);
      expect(user.email, userDto.email);
      expect(user.avatar, isNull);

      _verifyRegisterRequest(apiClient, name, email, password);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns ValidationFailedFailure when api returns 422 validation_failed', () async {
      // Arrange
      const errors = <String, List<String>>{
        'email': ['Email field is required'],
      };
      final exception = createDioBadResponseException(
        path: '/register',
        statusCode: 422,
        code: 'validation_failed',
        errors: errors,
      );
      when(apiClient.register(any)).thenThrow(exception);

      // Act
      final result = await repository.signUp(name, email, password);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure.parentException, isA<DioException>());
      expect(failure, isA<ValidationFailedFailure>());
      expect((failure as ValidationFailedFailure).fieldErrors, errors);

      _verifyRegisterRequest(apiClient, name, email, password);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.register(any)).thenThrow(unknownException);

      // Act
      final result = await repository.signUp(name, email, password);

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      _verifyRegisterRequest(apiClient, name, email, password);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}

void _verifyRegisterRequest(
  MockAuthApiClient apiClient,
  String expectedName,
  String expectedEmail,
  String expectedPassword,
) {
  final captured = verify(apiClient.register(captureAny)).captured.single as RegisterRequestDto;
  expect(captured.name, expectedName);
  expect(captured.email, expectedEmail);
  expect(captured.password, expectedPassword);
}
