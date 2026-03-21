import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';

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
        errorWidget: (_, _, _) => const _ImagePlaceholder(
          icon: Icons.image_not_supported_outlined,
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final IconData icon;
  const _ImagePlaceholder({this.icon = Icons.image_outlined});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Icon(
          icon,
          size: 64,
          color: AppColorTheme.of(context).disabled,
        ),
      ),
    );
  }
}
