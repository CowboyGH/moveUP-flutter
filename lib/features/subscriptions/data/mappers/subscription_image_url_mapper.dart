import '../../../../core/network/mappers/image_url_mapper.dart';

/// Normalizes relative backend subscription image paths into absolute URLs.
String normalizeSubscriptionImageUrl(String rawImage) => normalizeBackendImageUrl(rawImage);
