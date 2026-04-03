import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/save_card_request_dto.dart';
import '../dto/saved_cards_response_dto.dart';

part 'cards_api_client.g.dart';

/// Retrofit API client for saved cards requests and commands.
@RestApi()
abstract class CardsApiClient {
  /// Creates an instance of [CardsApiClient].
  factory CardsApiClient(Dio dio, {String? baseUrl}) = _CardsApiClient;

  /// Returns all saved cards for the authenticated user.
  @GET(ApiPaths.paymentCards)
  Future<SavedCardsResponseDto> getCards();

  /// Saves a new card.
  @POST(ApiPaths.paymentCardsSave)
  Future<void> saveCard(@Body() SaveCardRequestDto request);

  /// Marks a card as default.
  @POST('${ApiPaths.paymentCards}/{cardId}/default')
  Future<void> setDefaultCard(@Path('cardId') int cardId);

  /// Deletes a saved card.
  @DELETE('${ApiPaths.paymentCards}/{cardId}')
  Future<void> deleteCard(@Path('cardId') int cardId);
}
