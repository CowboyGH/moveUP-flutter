import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/logout_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_logout_test.mocks.dart';

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

  group('AuthRepositoryImpl.logout', () {
    late LogoutResponseDto logoutResponseDto;

    setUp(() {
      logoutResponseDto = LogoutResponseDto(
        success: true,
        message: 'success_message',
      );
    });

    test('returns success and deletes token when api logout succeeds', () async {
      // Arrange
      when(apiClient.logout()).thenAnswer((_) async => logoutResponseDto);
      when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isSuccess, isTrue);

      verify(apiClient.logout()).called(1);
      verifyNoMoreInteractions(apiClient);
      verify(tokenStorage.deleteAccessToken()).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnauthorizedAuthFailure and deletes token when api returns 401 unauthorized', () async {
      // Arrange
      final exception = createDioBadResponseException(
        path: '/logout',
        statusCode: 401,
        code: 'unauthorized',
      );
      when(apiClient.logout()).thenThrow(exception);
      when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnauthorizedAuthFailure>());
      expect(failure.parentException, isA<DioException>());

      verify(apiClient.logout()).called(1);
      verifyNoMoreInteractions(apiClient);
      verify(tokenStorage.deleteAccessToken()).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.logout()).thenThrow(unknownException);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      verify(apiClient.logout()).called(1);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}
