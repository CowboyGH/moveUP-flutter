import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/subscriptions/data/remote/subscriptions_api_client.dart';
import 'package:moveup_flutter/features/subscriptions/data/repositories/subscriptions_repository_impl.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';

import '../../support/subscriptions_dto_fixtures.dart';
import 'subscriptions_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<SubscriptionsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockSubscriptionsApiClient apiClient;
  late SubscriptionsRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockSubscriptionsApiClient();
    repository = SubscriptionsRepositoryImpl(logger, apiClient);
  });

  group('SubscriptionsRepositoryImpl', () {
    group('SubscriptionsRepositoryImpl.getSubscriptions', () {
      test('returns success(items) when api succeeds', () async {
        final responseDto = createSubscriptionsResponseDto();
        final expectedItems = createSubscriptionCatalogItems();
        when(apiClient.getSubscriptions()).thenAnswer((_) async => responseDto);

        final result = await repository.getSubscriptions();

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedItems);
        expect(result.success!.first.imageUrl, expectedItems.first.imageUrl);
        expect(result.success!.first.durationDays, 30);

        verify(apiClient.getSubscriptions()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns SubscriptionsRequestFailure when api returns server error', () async {
        final exception = createSubscriptionsDioBadResponseException(
          path: '/subscriptions',
          statusCode: 500,
        );
        when(apiClient.getSubscriptions()).thenThrow(exception);

        final result = await repository.getSubscriptions();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<SubscriptionsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getSubscriptions()).called(1);
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownSubscriptionsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.getSubscriptions()).thenThrow(exception);

        final result = await repository.getSubscriptions();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownSubscriptionsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getSubscriptions()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
