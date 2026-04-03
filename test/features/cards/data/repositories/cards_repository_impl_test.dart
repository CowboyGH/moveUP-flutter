import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/cards/cards_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/cards/data/dto/save_card_request_dto.dart';
import 'package:moveup_flutter/features/cards/data/remote/cards_api_client.dart';
import 'package:moveup_flutter/features/cards/data/repositories/cards_repository_impl.dart';
import 'package:moveup_flutter/features/cards/domain/repositories/cards_repository.dart';

import '../../support/cards_dto_fixtures.dart';
import 'cards_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<CardsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockCardsApiClient apiClient;
  late CardsRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockCardsApiClient();
    repository = CardsRepositoryImpl(logger, apiClient);
  });

  group('CardsRepositoryImpl', () {
    group('CardsRepositoryImpl.getCards', () {
      test('returns success(cards) when api succeeds', () async {
        final responseDto = createSavedCardsResponseDto();
        final expectedCards = createSavedCards();
        when(apiClient.getCards()).thenAnswer((_) async => responseDto);

        final result = await repository.getCards();

        expect(result.isSuccess, isTrue);
        expect(result.success, expectedCards);
        expect(result.success!.first.isDefault, isTrue);

        verify(apiClient.getCards()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('keeps default card first in returned cards list', () async {
        final responseDto = createSavedCardsResponseDto();
        when(apiClient.getCards()).thenAnswer((_) async => responseDto);

        final result = await repository.getCards();

        expect(result.isSuccess, isTrue);
        expect(result.success!.map((card) => card.id), [1, 2]);

        verify(apiClient.getCards()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns CardsRequestFailure when api returns server error', () async {
        final exception = createCardsDioBadResponseException(
          path: '/payment/cards',
          statusCode: 500,
        );
        when(apiClient.getCards()).thenThrow(exception);

        final result = await repository.getCards();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<CardsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getCards()).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownCardsFailure when unexpected exception occurs', () async {
        final exception = Exception('unexpected_error');
        when(apiClient.getCards()).thenThrow(exception);

        final result = await repository.getCards();

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownCardsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.getCards()).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('CardsRepositoryImpl.saveCard', () {
      test('returns success when save api succeeds', () async {
        when(apiClient.saveCard(any)).thenAnswer((_) async {});

        final result = await repository.saveCard(payload: testSaveCardPayload);

        expect(result.isSuccess, isTrue);
        verify(
          apiClient.saveCard(
            argThat(
              isA<SaveCardRequestDto>()
                  .having((request) => request.cardNumber, 'cardNumber', '4111111111111111')
                  .having((request) => request.cardHolder, 'cardHolder', 'IVAN IVANOV')
                  .having((request) => request.expiryMonth, 'expiryMonth', '12')
                  .having((request) => request.expiryYear, 'expiryYear', '2029'),
            ),
          ),
        ).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns CardsValidationFailure on validation error', () async {
        final exception = createCardsDioBadResponseException(
          path: '/payment/cards/save',
          statusCode: 422,
          code: 'validation_failed',
          message: 'validation_failed',
          errors: {
            'card_number': ['Введите корректный номер карты'],
            'card_holder': ['Введите имя держателя'],
          },
        );
        when(apiClient.saveCard(any)).thenThrow(exception);

        final result = await repository.saveCard(payload: testSaveCardPayload);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<CardsValidationFailure>());
        expect(
          result.failure!.message,
          'Введите корректный номер карты\nВведите имя держателя',
        );

        verify(apiClient.saveCard(any)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns CardsRequestFailure when save api returns server error', () async {
        final exception = createCardsDioBadResponseException(
          path: '/payment/cards/save',
          statusCode: 500,
        );
        when(apiClient.saveCard(any)).thenThrow(exception);

        final result = await repository.saveCard(payload: testSaveCardPayload);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<CardsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.saveCard(any)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownCardsFailure when save throws unexpected exception', () async {
        final exception = Exception('unexpected_save_error');
        when(apiClient.saveCard(any)).thenThrow(exception);

        final result = await repository.saveCard(payload: testSaveCardPayload);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownCardsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.saveCard(any)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('CardsRepositoryImpl.setDefaultCard', () {
      test('returns success when default api succeeds', () async {
        when(apiClient.setDefaultCard(2)).thenAnswer((_) async {});

        final result = await repository.setDefaultCard(2);

        expect(result.isSuccess, isTrue);
        verify(apiClient.setDefaultCard(2)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns CardsRequestFailure when default api returns server error', () async {
        final exception = createCardsDioBadResponseException(
          path: '/payment/cards/2/default',
          statusCode: 500,
        );
        when(apiClient.setDefaultCard(2)).thenThrow(exception);

        final result = await repository.setDefaultCard(2);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<CardsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.setDefaultCard(2)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownCardsFailure when default throws unexpected exception', () async {
        final exception = Exception('unexpected_default_error');
        when(apiClient.setDefaultCard(2)).thenThrow(exception);

        final result = await repository.setDefaultCard(2);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownCardsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.setDefaultCard(2)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });

    group('CardsRepositoryImpl.deleteCard', () {
      test('returns success when delete api succeeds', () async {
        when(apiClient.deleteCard(2)).thenAnswer((_) async {});

        final result = await repository.deleteCard(2);

        expect(result.isSuccess, isTrue);
        verify(apiClient.deleteCard(2)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns CardsRequestFailure when delete api returns server error', () async {
        final exception = createCardsDioBadResponseException(
          path: '/payment/cards/2',
          statusCode: 500,
        );
        when(apiClient.deleteCard(2)).thenThrow(exception);

        final result = await repository.deleteCard(2);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<CardsRequestFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.deleteCard(2)).called(1);
        verifyNever(logger.e(any, any, any));
        verifyNoMoreInteractions(apiClient);
      });

      test('returns UnknownCardsFailure when delete throws unexpected exception', () async {
        final exception = Exception('unexpected_delete_error');
        when(apiClient.deleteCard(2)).thenThrow(exception);

        final result = await repository.deleteCard(2);

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnknownCardsFailure>());
        expect(result.failure!.parentException, exception);

        verify(apiClient.deleteCard(2)).called(1);
        verify(logger.e(any, exception, any)).called(1);
        verifyNoMoreInteractions(apiClient);
      });
    });
  });
}
