import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../images/svg_picture_widget.dart';
import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';

/// Shows a shared feedback dialog with blur backdrop.
Future<T?> showAppFeedbackDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  bool isBarrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: isBarrierDismissible,
    barrierColor: AppColorTheme.of(context).onSurface.withValues(alpha: 0.16),
    builder: (context) => PopScope(
      canPop: isBarrierDismissible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AppFeedbackDialog(
          title: title,
          message: message,
        ),
      ),
    ),
  );
}

/// Shared auth-style alert dialog.
class AppFeedbackDialog extends StatelessWidget {
  /// Dialog title.
  final String title;

  /// Dialog subtitle text.
  final String message;

  /// Creates an instance of [AppFeedbackDialog].
  const AppFeedbackDialog({
    required this.title,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: colorTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: colorTheme.error,
                borderRadius: BorderRadius.circular(40),
              ),
              child: SvgPictureWidget.icon(
                AppAssets.iconExclamationPoint,
                fit: BoxFit.scaleDown,
                color: colorTheme.onError,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.title.copyWith(
                fontSize: 16,
                height: 24 / 16,
                fontWeight: FontWeight.w600,
                color: colorTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium.copyWith(color: colorTheme.hint),
            ),
          ],
        ),
      ),
    );
  }
}
