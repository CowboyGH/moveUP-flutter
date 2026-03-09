import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/auth/auth_failure.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/auth/data/dto/me_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';
import 'package:moveup_flutter/features/auth/data/remote/auth_api_client.dart';
import 'package:moveup_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:moveup_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../../support/auth_dto_fixtures.dart';
import 'auth_repository_impl_get_current_user_test.mocks.dart';

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

  group('AuthRepositoryImpl.getCurrentUser', () {
    late UserDto userDto;
    late MeResponseDto meResponseDto;

    setUp(() {
      userDto = createUserDto();
      meResponseDto = MeResponseDto(success: true, user: userDto);
    });

    test('returns success(user) when api me succeeds', () async {
      // Arrange
      when(apiClient.me()).thenAnswer((_) async => meResponseDto);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isSuccess, isTrue);

      final user = result.success!;
      expect(user.id, userDto.id);
      expect(user.name, userDto.name);
      expect(user.email, userDto.email);
      expect(user.avatar, userDto.avatar);

      verify(apiClient.me()).called(1);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnauthorizedAuthFailure when api returns 401 token_expired', () async {
      // Arrange
      final exception = createDioBadResponseException(
        path: '/me',
        statusCode: 401,
        code: 'token_expired',
      );
      when(apiClient.me()).thenThrow(exception);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<UnauthorizedAuthFailure>());

      verify(apiClient.me()).called(1);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('returns UnknownAuthFailure when unexpected exception occurs', () async {
      // Arrange
      final unknownException = Exception('unexpected_error');
      when(apiClient.me()).thenThrow(unknownException);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isFailure, isTrue);

      final failure = result.failure!;
      expect(failure, isA<UnknownAuthFailure>());
      expect(failure.parentException, unknownException);

      verify(apiClient.me()).called(1);
      verifyNoMoreInteractions(apiClient);
      verifyNoMoreInteractions(tokenStorage);
    });
  });
}
