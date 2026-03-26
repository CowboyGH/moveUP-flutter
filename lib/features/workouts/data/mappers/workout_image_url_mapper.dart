import '../../../../core/network/api_paths.dart';

/// Normalizes relative backend workout image paths into absolute URLs.
String normalizeWorkoutImageUrl(String rawImage) {
  final image = rawImage.trim();
  if (image.isEmpty) return '';
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image;
  }

  final normalizedPath = image.replaceFirst(RegExp(r'^/+'), '');
  final storagePath = normalizedPath.startsWith('storage/')
      ? normalizedPath
      : 'storage/$normalizedPath';
  return Uri.parse(ApiPaths.baseUrl).resolve(storagePath).toString();
}
