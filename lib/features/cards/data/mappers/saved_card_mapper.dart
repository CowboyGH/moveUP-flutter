import '../../domain/entities/saved_card.dart';
import '../dto/saved_card_dto.dart';

/// Maps [SavedCardDto] into the cards domain layer.
extension SavedCardMapper on SavedCardDto {
  /// Converts [SavedCardDto] to [SavedCard].
  SavedCard toEntity() => SavedCard(
    id: id,
    holderName: cardHolder,
    lastFour: cardLastFour,
    expiryMonth: expiryMonth,
    expiryYear: expiryYear,
    isDefault: isDefault,
  );
}
