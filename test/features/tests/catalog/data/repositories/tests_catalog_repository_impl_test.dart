import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/tests/catalog/data/remote/tests_api_client.dart';
import 'package:moveup_flutter/features/tests/catalog/data/repositories/tests_catalog_repository_impl.dart';
import 'package:moveup_flutter/features/tests/catalog/domain/repositories/tests_catalog_repository.dart';

import '../../support/testings_dto_fixtures.dart';
import 'tests_catalog_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<TestsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockTestsApiClient apiClient;
  late TestsCatalogRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockTestsApiClient();
    repository = TestsCatalogRepositoryImpl(logger, apiClient);
  });

  group('TestsCatalogRepositoryImpl', () {
    group('TestsCatalogRepositoryImpl.getTestings', () {
      test('returns success(items) when api succeeds', () async {
        // Arrange
        final responseDto = createTestingsResponseDto();
        final expectedItems = createTestingCatalogItems();
        when(apiClient.getTestings()).thenAnswer((_) async => responseDto);

        // Act
        final result = await repository.getTestings();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, hasLength(2));
        expect(result.success!.first.id, expectedItems.first.id);
        expect(result.success!.first.title, expectedItems.first.title);
        expect(result.success!.first.durationMinutes, expectedItems.first.durationMinutes);
        expect(result.success!.first.imageUrl, expectedItems.first.imageUrl);
        expect(result.success!.first.categories, expectedItems.first.categories);
        expect(result.success!.first.exercisesCount, expectedItems.first.exercisesCount);

        verify(apiClient.getTestings()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns TestsRequestFailure when api returns server error', () async {
        // Arrange
        final exception = createTestsDioBadResponseException(
          path: '/testings',
          statusCode: 500,
          code: 'server_error',
        );
        when(apiClient.getTestings()).thenThrow(exception);

        // Act
        final result = await repository.getTestings();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<TestsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getTestings()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownTestsFailure when unexpected exception occurs', () async {
        // Arrange
        final exception = Exception('unexpected_error');
        when(apiClient.getTestings()).thenThrow(exception);

        // Act
        final result = await repository.getTestings();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownTestsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getTestings()).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
