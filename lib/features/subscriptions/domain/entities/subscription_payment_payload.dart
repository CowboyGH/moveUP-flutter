import 'package:equatable/equatable.dart';

/// Typed payment payload submitted from the subscription payment dialog.
final class SubscriptionPaymentPayload extends Equatable {
  /// Subscription identifier.
  final int subscriptionId;

  /// Whether the submitted card should be saved.
  final bool saveCard;

  /// Card number without spaces.
  final String cardNumber;

  /// Card holder name.
  final String cardHolder;

  /// Expiry month.
  final String expiryMonth;

  /// Expiry year.
  final String expiryYear;

  /// Card CVV.
  final String cvv;

  /// Creates an instance of [SubscriptionPaymentPayload].
  const SubscriptionPaymentPayload({
    required this.subscriptionId,
    required this.saveCard,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
  });

  @override
  List<Object?> get props => [
    subscriptionId,
    saveCard,
    cardNumber,
    cardHolder,
    expiryMonth,
    expiryYear,
    cvv,
  ];
}
