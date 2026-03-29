import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../uikit/themes/colors/app_color_theme.dart';

/// Shows a profile-specific dialog with shared backdrop styling.
Future<T?> showProfileDialog<T>(
  BuildContext context, {
  required Widget child,
  required EdgeInsets insetPadding,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColorTheme.of(context).onSurface.withValues(alpha: 0.16),
    builder: (_) => PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: ProfileDialogShell(
          insetPadding: insetPadding,
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

  /// Dialog content.
  final Widget child;

  /// Creates an instance of [ProfileDialogShell].
  const ProfileDialogShell({
    required this.insetPadding,
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: child,
      ),
    );
  }
}
