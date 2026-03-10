import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget for displaying SVG images.
class SvgPictureWidget extends StatelessWidget {
  /// SVG path.
  final String svgPath;

  /// Icon color.
  final Color? color;

  /// Width.
  final double? width;

  /// Height.
  final double? height;

  /// Box fit.
  final BoxFit fit;

  /// Creates an instance of [SvgPictureWidget].
  const SvgPictureWidget(
    this.svgPath, {
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    super.key,
  });

  /// Creates an icon from `assets/icons`.
  const SvgPictureWidget.icon(
    String iconName, {
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    super.key,
  }) : svgPath = 'assets/icons/$iconName.svg';

  /// Creates a frame from `assets/images`.
  const SvgPictureWidget.frame(
    String imageName, {
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    super.key,
  }) : svgPath = 'assets/images/$imageName.svg';

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    final colorFilter = color == null
        ? null
        : ColorFilter.mode(
            color,
            BlendMode.srcIn,
          );
    return SvgPicture.asset(
      svgPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
    );
  }
}
