import 'package:equatable/equatable.dart';

/// Catalog item returned by the subscriptions endpoint.
final class SubscriptionCatalogItem extends Equatable {
  /// Subscription identifier.
  final int id;

  /// Subscription description.
  final String description;

  /// Subscription price.
  final String price;

  /// Subscription duration in days.
  final int durationDays;

  /// Normalized subscription image URL.
  final String imageUrl;

  /// Creates an instance of [SubscriptionCatalogItem].
  const SubscriptionCatalogItem({
    required this.id,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    description,
    price,
    durationDays,
    imageUrl,
  ];
}
