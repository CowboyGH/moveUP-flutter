import '../../domain/entities/subscription_catalog_item.dart';
import '../dto/subscription_catalog_item_dto.dart';
import 'subscription_image_url_mapper.dart';

/// Extension that maps [SubscriptionCatalogItemDto] to [SubscriptionCatalogItem].
extension SubscriptionCatalogItemMapper on SubscriptionCatalogItemDto {
  /// Converts DTO to a domain entity.
  SubscriptionCatalogItem toEntity() => SubscriptionCatalogItem(
    id: id,
    description: description,
    price: price,
    durationDays: int.tryParse(durationDays.trim()) ?? 0,
    imageUrl: normalizeSubscriptionImageUrl(image),
  );
}
