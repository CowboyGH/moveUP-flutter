import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/save_card_payload.dart';
import '../entities/saved_card.dart';

/// Repository interface for saved cards operations.
abstract interface class CardsRepository {
  /// Returns saved cards for the authenticated user.
  Future<Result<List<SavedCard>, CardsFailure>> getCards();

  /// Saves a new card using the provided [payload].
  Future<Result<void, CardsFailure>> saveCard({
    required SaveCardPayload payload,
  });

  /// Marks a saved card as default.
  Future<Result<void, CardsFailure>> setDefaultCard(int cardId);

  /// Deletes a saved card by [cardId].
  Future<Result<void, CardsFailure>> deleteCard(int cardId);
}
