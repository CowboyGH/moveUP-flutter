import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/subscriptions/data/dto/subscription_payment_request_dto.dart';
import 'package:moveup_flutter/features/subscriptions/data/remote/subscription_payment_api_client.dart';
import 'package:moveup_flutter/features/subscriptions/data/remote/subscriptions_api_client.dart';
import 'package:moveup_flutter/features/subscriptions/data/repositories/subscriptions_repository_impl.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';

import '../../support/subscriptions_dto_fixtures.dart';
import 'subscriptions_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<SubscriptionsApiClient>(),
  MockSpec<SubscriptionPaymentApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockSubscriptionsApiClient apiClient;
  late MockSubscriptionPaymentApiClient paymentApiClient;
  late SubscriptionsRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockSubscriptionsApiClient();
    paymentApiClient = MockSubscriptionPaymentApiClient();
    repository = SubscriptionsRepositoryImpl(logger, apiClient, paymentApiClient);
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
        expect(result.success!.first.name, '1 месяц');

        verify(apiClient.getSubscriptions()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('filters out inactive subscriptions from the catalog payload', () async {
        final responseDto = createSubscriptionsResponseDto(includeInactive: true);
        final expectedItems = createSubscriptionCatalogItems();
        when(apiClient.getSubscriptions()).thenAnswer((_) async => responseDto);

        final result = await repository.getSubscriptions();

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedItems);
        expect(result.success!.any((item) => item.id == 3), isFalse);

        verify(apiClient.getSubscriptions()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns success(item) when requested id exists in active catalog payload', () async {
        final responseDto = createSubscriptionResponseDto();
        final expectedItem = createSubscriptionCatalogItems().last;
        when(apiClient.getSubscriptionById(expectedItem.id)).thenAnswer((_) async => responseDto);

        final result = await repository.getSubscriptionById(expectedItem.id);

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedItem);

        verify(apiClient.getSubscriptionById(expectedItem.id)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns SubscriptionsNotFoundFailure when api returns not found', () async {
        final exception = createSubscriptionsDioBadResponseException(
          path: '/subscriptions/999',
          statusCode: 404,
          code: 'not_found',
        );
        when(apiClient.getSubscriptionById(999)).thenThrow(exception);

        final result = await repository.getSubscriptionById(999);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<SubscriptionsNotFoundFailure>());
        expect(result.failure!.parentException, isNull);

        verify(apiClient.getSubscriptionById(999)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test(
        'returns SubscriptionsNotFoundFailure when requested subscription is inactive',
        () async {
          final responseDto = createSubscriptionResponseDto(isActive: false);
          when(apiClient.getSubscriptionById(3)).thenAnswer((_) async => responseDto);

          final result = await repository.getSubscriptionById(3);

          expect(result.isFailure, isTrue);
          expect(result.failure, isA<SubscriptionsNotFoundFailure>());

          verify(apiClient.getSubscriptionById(3)).called(1);
          verifyNever(logger.e(any, any, any));
          verifyNoMoreInteractions(apiClient);
        },
      );

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
        verifyNever(logger.e(any, any, any));
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

    group('SubscriptionsRepositoryImpl.paySubscription', () {
      test('returns success when payment api succeeds', () async {
        when(paymentApiClient.paySubscription(any)).thenAnswer((_) async {});

        final result = await repository.paySubscription(
          payload: testSubscriptionPaymentPayload,
        );

        expect(result.isSuccess, isTrue);
        verify(
          paymentApiClient.paySubscription(
            argThat(
              isA<SubscriptionPaymentRequestDto>()
                  .having((request) => request.subscriptionId, 'subscriptionId', 2)
                  .having((request) => request.saveCard, 'saveCard', true)
                  .having((request) => request.useSavedCard, 'useSavedCard', false)
                  .having((request) => request.cardNumber, 'cardNumber', '4111111111111111')
                  .having((request) => request.cardHolder, 'cardHolder', 'IVAN IVANOV')
                  .having((request) => request.expiryMonth, 'expiryMonth', '12')
                  .having((request) => request.expiryYear, 'expiryYear', '2028')
                  .having((request) => request.cvv, 'cvv', '123'),
            ),
          ),
        ).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(paymentApiClient);
      });

      test('returns SubscriptionsRequestFailure when payment api returns server error', () async {
        final exception = createSubscriptionsDioBadResponseException(
          path: '/payment/subscription',
          statusCode: 500,
        );
        when(paymentApiClient.paySubscription(any)).thenThrow(exception);

        final result = await repository.paySubscription(
          payload: testSubscriptionPaymentPayload,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<SubscriptionsRequestFailure>());
        expect(result.failure!.parentException, isNull);

        verify(paymentApiClient.paySubscription(any)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(paymentApiClient);
      });

      test(
        'returns sanitized SubscriptionsValidationFailure on payment validation error',
        () async {
          final exception = createSubscriptionsDioBadResponseException(
            path: '/payment/subscription',
            statusCode: 422,
            code: 'validation_failed',
            message: 'validation_failed',
            errors: {
              'cvv': ['invalid_cvv'],
            },
          );
          when(paymentApiClient.paySubscription(any)).thenThrow(exception);

          final result = await repository.paySubscription(
            payload: testSubscriptionPaymentPayload,
          );

          expect(result.isFailure, isTrue);
          expect(result.failure, isA<SubscriptionsValidationFailure>());
          expect(result.failure!.message, 'invalid_cvv');
          expect(result.failure!.parentException, isNull);

          verify(paymentApiClient.paySubscription(any)).called(1);
          verifyNever(logger.e(any, any, any));
          verifyNoMoreInteractions(paymentApiClient);
        },
      );

      test(
        'returns UnknownSubscriptionsFailure when payment throws unexpected exception',
        () async {
          final exception = Exception('unexpected_payment_error');
          when(paymentApiClient.paySubscription(any)).thenThrow(exception);

          final result = await repository.paySubscription(
            payload: testSubscriptionPaymentPayload,
          );

          expect(result.isFailure, isTrue);
          expect(result.failure, isA<UnknownSubscriptionsFailure>());
          expect(result.failure!.parentException, exception);

          verify(paymentApiClient.paySubscription(any)).called(1);
          verify(logger.e(any, exception, any)).called(1);
          verifyNoMoreInteractions(paymentApiClient);
        },
      );
    });

    group('SubscriptionsRepositoryImpl.cancelSubscription', () {
      test('returns success when cancel api succeeds', () async {
        when(apiClient.cancelSubscription()).thenAnswer((_) async {});

        final result = await repository.cancelSubscription();

        expect(result.isSuccess, isTrue);
        verify(apiClient.cancelSubscription()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns SubscriptionsRequestFailure when cancel api returns server error', () async {
        final exception = createSubscriptionsDioBadResponseException(
          path: '/cancel-subscription',
          statusCode: 500,
        );
        when(apiClient.cancelSubscription()).thenThrow(exception);

        final result = await repository.cancelSubscription();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<SubscriptionsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.cancelSubscription()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownSubscriptionsFailure when cancel throws unexpected exception', () async {
        final exception = Exception('unexpected_cancel_error');
        when(apiClient.cancelSubscription()).thenThrow(exception);

        final result = await repository.cancelSubscription();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownSubscriptionsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.cancelSubscription()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
