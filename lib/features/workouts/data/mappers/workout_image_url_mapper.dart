import '../../../../core/network/mappers/image_url_mapper.dart';

/// Normalizes relative backend workout image paths into absolute URLs.
String normalizeWorkoutImageUrl(String rawImage) => normalizeBackendImageUrl(rawImage);
