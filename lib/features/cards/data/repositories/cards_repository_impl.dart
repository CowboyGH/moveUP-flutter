import 'package:dio/dio.dart';

import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/save_card_payload.dart';
import '../../domain/entities/saved_card.dart';
import '../../domain/repositories/cards_repository.dart';
import '../dto/save_card_request_dto.dart';
import '../mappers/cards_failure_mapper.dart';
import '../mappers/saved_card_mapper.dart';
import '../remote/cards_api_client.dart';

/// Implementation of [CardsRepository].
final class CardsRepositoryImpl implements CardsRepository {
  final AppLogger _logger;
  final CardsApiClient _apiClient;

  /// Creates an instance of [CardsRepositoryImpl].
  CardsRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<List<SavedCard>, CardsFailure>> getCards() async {
    try {
      final response = await _apiClient.getCards();
      final defaultCards = <SavedCard>[];
      final regularCards = <SavedCard>[];

      for (final item in response.data.map((item) => item.toEntity())) {
        if (item.isDefault) {
          defaultCards.add(item);
        } else {
          regularCards.add(item);
        }
      }

      return Result.success([...defaultCards, ...regularCards]);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toCardsFailure());
    } catch (e, s) {
      _logger.e('GetCards failed with unexpected error', e, s);
      return Result.failure(
        UnknownCardsFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, CardsFailure>> saveCard({
    required SaveCardPayload payload,
  }) async {
    try {
      await _apiClient.saveCard(
        SaveCardRequestDto(
          cardNumber: payload.cardNumber,
          cardHolder: payload.cardHolder,
          expiryMonth: payload.expiryMonth,
          expiryYear: payload.expiryYear,
        ),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toCardsFailure());
    } catch (e, s) {
      _logger.e('SaveCard failed with unexpected error', e, s);
      return Result.failure(
        UnknownCardsFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, CardsFailure>> setDefaultCard(int cardId) async {
    try {
      await _apiClient.setDefaultCard(cardId);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toCardsFailure());
    } catch (e, s) {
      _logger.e('SetDefaultCard failed with unexpected error', e, s);
      return Result.failure(
        UnknownCardsFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, CardsFailure>> deleteCard(int cardId) async {
    try {
      await _apiClient.deleteCard(cardId);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toCardsFailure());
    } catch (e, s) {
      _logger.e('DeleteCard failed with unexpected error', e, s);
      return Result.failure(
        UnknownCardsFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
