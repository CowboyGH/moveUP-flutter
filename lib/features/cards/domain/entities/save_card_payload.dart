import 'package:equatable/equatable.dart';

/// Typed payload submitted from the save-card dialog.
final class SaveCardPayload extends Equatable {
  /// Card number without spaces.
  final String cardNumber;

  /// Card holder name.
  final String cardHolder;

  /// Expiry month.
  final String expiryMonth;

  /// Expiry year.
  final String expiryYear;

  /// Creates an instance of [SaveCardPayload].
  const SaveCardPayload({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
  });

  @override
  List<Object?> get props => [
    cardNumber,
    cardHolder,
    expiryMonth,
    expiryYear,
  ];
}
