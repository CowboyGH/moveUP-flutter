import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';

/// Profile-local network image widget with avatar-specific fallback artwork.
class ProfileAvatarImage extends StatelessWidget {
  /// Remote image URL.
  final String imageUrl;

  /// Height.
  final double height;

  /// Optional width.
  final double? width;

  /// Fit.
  final BoxFit fit;

  /// Creates an instance of [ProfileAvatarImage].
  const ProfileAvatarImage({
    required this.imageUrl,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (_, _) => _ProfileAvatarPlaceholder(
        height: height,
        width: width,
        fit: fit,
      ),
      errorWidget: (_, _, _) => _ProfileAvatarPlaceholder(
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}

final class _ProfileAvatarPlaceholder extends StatelessWidget {
  final double height;
  final double? width;
  final BoxFit fit;

  const _ProfileAvatarPlaceholder({
    required this.height,
    required this.width,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.avatarPlaceholder,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
        ),
      ),
    );
  }
}
