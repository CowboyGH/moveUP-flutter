import 'dart:ui';

import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';

/// Shows a shared action dialog with blur backdrop.
Future<void> showAppActionDialog(
  BuildContext context, {
  required String title,
  String? description,
  required Widget primaryAction,
  Widget? secondaryAction,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColorTheme.of(context).onSurface.withValues(alpha: 0.16),
    builder: (dialogContext) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AppActionDialog(
        title: title,
        description: description,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
      ),
    ),
  );
}

/// Shared action dialog with one or two action buttons.
class AppActionDialog extends StatelessWidget {
  /// Dialog title.
  final String title;

  /// Optional description shown above the actions.
  final String? description;

  /// Primary action button.
  final Widget primaryAction;

  /// Optional secondary action button.
  final Widget? secondaryAction;

  /// Creates an instance of [AppActionDialog].
  const AppActionDialog({
    required this.title,
    required this.primaryAction,
    this.description,
    this.secondaryAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final hasDescription = description?.trim().isNotEmpty ?? false;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: colorTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.title.copyWith(
                fontSize: 18,
                height: 27 / 18,
                fontWeight: FontWeight.w500,
                color: colorTheme.onSurface,
              ),
            ),
            const SizedBox(height: 40),
            if (hasDescription) ...[
              Text(
                description!,
                textAlign: TextAlign.center,
                style: textTheme.body.copyWith(
                  fontSize: 14,
                  height: 21 / 14,
                  color: colorTheme.onSurface,
                ),
              ),
              const SizedBox(height: 36),
            ],
            primaryAction,
            if (secondaryAction != null) ...[
              const SizedBox(height: 12),
              secondaryAction!,
            ],
          ],
        ),
      ),
    );
  }
}
