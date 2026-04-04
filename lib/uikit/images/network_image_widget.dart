import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// Widget for displaying cached network images.
class NetworkImageWidget extends StatelessWidget {
  /// Image URL.
  final String imageUrl;

  /// Height.
  final double height;

  /// Creates an instance of [NetworkImageWidget].
  const NetworkImageWidget({
    required this.imageUrl,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => const _ImagePlaceholder(),
        errorWidget: (_, _, _) => const _ImagePlaceholder(),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.imagePlaceholder,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 64,
        ),
      ),
    );
  }
}
