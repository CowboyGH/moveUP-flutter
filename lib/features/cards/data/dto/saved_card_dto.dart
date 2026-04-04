import 'package:json_annotation/json_annotation.dart';

part 'saved_card_dto.g.dart';

/// DTO for a saved payment card.
@JsonSerializable(createToJson: false)
class SavedCardDto {
  /// Card identifier.
  final int id;

  /// Card holder name.
  @JsonKey(name: 'card_holder')
  final String cardHolder;

  /// Last four digits of the card number.
  @JsonKey(name: 'card_last_four')
  final String cardLastFour;

  /// Expiry month.
  @JsonKey(name: 'expiry_month')
  final String expiryMonth;

  /// Expiry year.
  @JsonKey(name: 'expiry_year')
  final String expiryYear;

  /// Whether the card is default.
  @JsonKey(name: 'is_default')
  final bool isDefault;

  /// Creates an instance of [SavedCardDto].
  SavedCardDto({
    required this.id,
    required this.cardHolder,
    required this.cardLastFour,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  /// Creates a [SavedCardDto] from JSON.
  factory SavedCardDto.fromJson(Map<String, dynamic> json) => _$SavedCardDtoFromJson(json);
}
