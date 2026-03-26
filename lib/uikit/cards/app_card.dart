import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/colors/app_gradients.dart';

/// Shared gradient-outline card with configurable internal padding.
class AppCard extends StatelessWidget {
  /// Card content.
  final Widget child;

  /// Internal content padding.
  final EdgeInsetsGeometry contentPadding;

  /// Creates an instance of [AppCard].
  const AppCard({
    required this.child,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.secondaryLinear,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: colorTheme.secondary.withValues(alpha: 0.6),
            blurRadius: 3,
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: contentPadding,
          child: child,
        ),
      ),
    );
  }
}
