import 'package:flutter/material.dart';

import 'colors/app_color_theme.dart';
import 'colors/app_colors.dart';
import 'text/app_text_theme.dart';

/// The main theme data for the app.
abstract class AppThemeData {
  static const _lightColorTheme = AppColorTheme.light();
  static const _textTheme = AppTextTheme.base();

  static const _fieldRadius = BorderRadius.all(Radius.circular(8));

  static const _enabledFieldBorder = OutlineInputBorder(
    borderRadius: _fieldRadius,
    borderSide: BorderSide(color: AppColors.primary700),
  );

  static const _errorFieldBorder = OutlineInputBorder(
    borderRadius: _fieldRadius,
    borderSide: BorderSide(color: AppColors.error),
  );

  static const _disabledFieldBorder = OutlineInputBorder(
    borderRadius: _fieldRadius,
    borderSide: BorderSide(color: AppColors.grey400),
  );

  /// The light theme of the app.
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Montserrat',
    colorScheme: ColorScheme.light(
      primary: _lightColorTheme.primary,
      secondary: _lightColorTheme.secondary,
      onPrimary: _lightColorTheme.onPrimary,
      surface: _lightColorTheme.surface,
      onSurface: _lightColorTheme.onSurface,
      error: _lightColorTheme.error,
      onError: _lightColorTheme.onError,
    ),
    scaffoldBackgroundColor: _lightColorTheme.background,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: _lightColorTheme.surface,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: _enabledFieldBorder,
      enabledBorder: _enabledFieldBorder,
      focusedBorder: _enabledFieldBorder,
      errorBorder: _errorFieldBorder,
      focusedErrorBorder: _errorFieldBorder,
      disabledBorder: _disabledFieldBorder,
      hintStyle: _textTheme.body.copyWith(color: _lightColorTheme.hint),
      errorMaxLines: 2,
      errorStyle: _textTheme.bodySmall.copyWith(color: _lightColorTheme.error),
      suffixIconConstraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) return _lightColorTheme.error;
        return _lightColorTheme.primary;
      }),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightColorTheme.onSurface,
        overlayColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _textTheme.body,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return _lightColorTheme.hint;
          if (states.contains(WidgetState.pressed)) return _lightColorTheme.secondary;
          return _lightColorTheme.onSurface;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(Size.square(24)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    splashFactory: NoSplash.splashFactory,
    extensions: [_lightColorTheme, _textTheme],
  );
}
