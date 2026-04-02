import 'package:json_annotation/json_annotation.dart';

part 'subscription_payment_request_dto.g.dart';

/// DTO for submitting a subscription payment with manual card details.
@JsonSerializable(createFactory: false)
class SubscriptionPaymentRequestDto {
  /// Subscription identifier.
  @JsonKey(name: 'subscription_id')
  final int subscriptionId;

  /// Whether the card should be saved.
  @JsonKey(name: 'save_card')
  final bool saveCard;

  /// Whether a saved card should be used.
  @JsonKey(name: 'use_saved_card')
  final bool useSavedCard;

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

  /// Card CVV.
  final String cvv;

  /// Creates an instance of [SubscriptionPaymentRequestDto].
  SubscriptionPaymentRequestDto({
    required this.subscriptionId,
    required this.saveCard,
    required this.useSavedCard,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
  });

  /// Converts [SubscriptionPaymentRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$SubscriptionPaymentRequestDtoToJson(this);
}
