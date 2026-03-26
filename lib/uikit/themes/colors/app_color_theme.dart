// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The color theme of the app.
@immutable
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  /// Retrieves the [AppColorTheme] from the current [BuildContext].
  static AppColorTheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorTheme>() ?? _throwThemeNotFound(context);

  final Color primary;
  final Color secondary;
  final Color onPrimary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color hint;
  final Color darkHint;
  final Color outline;
  final Color error;
  final Color onError;
  final Color border;
  final Color disabled;
  final Color onDisabled;

  const AppColorTheme._({
    required this.primary,
    required this.secondary,
    required this.onPrimary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.hint,
    required this.darkHint,
    required this.outline,
    required this.error,
    required this.onError,
    required this.border,
    required this.disabled,
    required this.onDisabled,
  });

  const AppColorTheme.light()
    : primary = AppColors.primary900,
      secondary = AppColors.secondary900,
      onPrimary = AppColors.white,
      background = AppColors.white,
      onBackground = AppColors.black,
      surface = AppColors.white,
      onSurface = AppColors.black,
      hint = AppColors.grey700,
      darkHint = AppColors.grey800,
      outline = AppColors.grey500,
      error = AppColors.error,
      onError = AppColors.white,
      border = AppColors.primary700,
      disabled = AppColors.grey400,
      onDisabled = AppColors.white;

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? primary,
    Color? secondary,
    Color? onPrimary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? hint,
    Color? darkHint,
    Color? outline,
    Color? error,
    Color? onError,
    Color? border,
    Color? disabled,
    Color? onDisabled,
  }) {
    return AppColorTheme._(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      hint: hint ?? this.hint,
      darkHint: darkHint ?? this.darkHint,
      outline: outline ?? this.outline,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(covariant ThemeExtension<AppColorTheme>? other, double t) {
    if (other is! AppColorTheme) {
      return this;
    }
    return AppColorTheme._(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      darkHint: Color.lerp(darkHint, other.darkHint, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
    );
  }
}

Never _throwThemeNotFound(BuildContext context) =>
    throw Exception('$AppColorTheme not found in $context');
