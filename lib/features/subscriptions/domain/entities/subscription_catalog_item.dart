import 'package:equatable/equatable.dart';

/// Catalog item returned by the subscriptions endpoint.
final class SubscriptionCatalogItem extends Equatable {
  /// Subscription identifier.
  final int id;

  /// Subscription marketing name from catalog.
  final String name;

  /// Subscription description.
  final String description;

  /// Subscription price.
  final String price;

  /// Normalized subscription image URL.
  final String imageUrl;

  /// Creates an instance of [SubscriptionCatalogItem].
  const SubscriptionCatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
  ];
}
