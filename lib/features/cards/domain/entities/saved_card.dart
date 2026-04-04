import 'package:equatable/equatable.dart';

/// Saved payment card returned by the cards endpoints.
final class SavedCard extends Equatable {
  /// Card identifier.
  final int id;

  /// Card holder name.
  final String holderName;

  /// Last four digits of the card number.
  final String lastFour;

  /// Card expiry month.
  final String expiryMonth;

  /// Card expiry year.
  final String expiryYear;

  /// Whether the card is the default one.
  final bool isDefault;

  /// Creates an instance of [SavedCard].
  const SavedCard({
    required this.id,
    required this.holderName,
    required this.lastFour,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  @override
  List<Object?> get props => [
    id,
    holderName,
    lastFour,
    expiryMonth,
    expiryYear,
    isDefault,
  ];
}
