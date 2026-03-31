import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';

/// Shows a profile-specific dialog with shared backdrop styling.
Future<T?> showProfileDialog<T>(
  BuildContext context, {
  required Widget child,
  required EdgeInsets insetPadding,
  EdgeInsets? contentPadding,
  bool isBarrierDismissible = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: isBarrierDismissible,
    barrierColor: AppColorTheme.of(context).onSurface.withValues(alpha: 0.16),
    builder: (_) => PopScope(
      canPop: isBarrierDismissible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: ProfileDialogShell(
          insetPadding: insetPadding,
          contentPadding: contentPadding,
          child: child,
        ),
      ),
    ),
  );
}

/// Shared rounded shell for profile dialogs.
class ProfileDialogShell extends StatelessWidget {
  /// Dialog outer insets.
  final EdgeInsets insetPadding;

  /// Dialog content padding.
  final EdgeInsets? contentPadding;

  /// Dialog content.
  final Widget child;

  /// Creates an instance of [ProfileDialogShell].
  const ProfileDialogShell({
    required this.insetPadding,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return Dialog(
      insetPadding: insetPadding,
      backgroundColor: colorTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: contentPadding,
        child: child,
      ),
    );
  }
}
