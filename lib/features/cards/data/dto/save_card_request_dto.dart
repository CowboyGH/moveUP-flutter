import 'package:json_annotation/json_annotation.dart';

part 'save_card_request_dto.g.dart';

/// DTO for saving a new payment card.
@JsonSerializable(createFactory: false)
class SaveCardRequestDto {
  /// Manual card number.
  @JsonKey(name: 'card_number')
  final String cardNumber;

  /// Manual card holder name.
  @JsonKey(name: 'card_holder')
  final String cardHolder;

  /// Card expiry month.
  @JsonKey(name: 'expiry_month')
  final String expiryMonth;

  /// Card expiry year.
  @JsonKey(name: 'expiry_year')
  final String expiryYear;

  /// Creates an instance of [SaveCardRequestDto].
  SaveCardRequestDto({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
  });

  /// Converts [SaveCardRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$SaveCardRequestDtoToJson(this);
}
