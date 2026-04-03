// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import 'app_text_style.dart';

/// The text theme of the app.
@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  /// Retrieves the [AppTextTheme] from the current [BuildContext].
  static AppTextTheme of(BuildContext context) =>
      Theme.of(context).extension<AppTextTheme>() ?? _throwThemeNotFound(context);

  final TextStyle display;
  final TextStyle title;
  final TextStyle appBarTitle;
  final TextStyle sectionTitle;
  final TextStyle body;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle button;

  const AppTextTheme._({
    required this.display,
    required this.title,
    required this.appBarTitle,
    required this.sectionTitle,
    required this.body,
    required this.bodyMedium,
    required this.bodySmall,
    required this.label,
    required this.button,
  });

  const AppTextTheme.base()
    : display = AppTextStyle.display,
      title = AppTextStyle.title,
      appBarTitle = AppTextStyle.appBarTitle,
      sectionTitle = AppTextStyle.sectionTitle,
      body = AppTextStyle.body,
      bodyMedium = AppTextStyle.bodyMedium,
      bodySmall = AppTextStyle.bodySmall,
      label = AppTextStyle.label,
      button = AppTextStyle.button;

  @override
  ThemeExtension<AppTextTheme> copyWith({
    TextStyle? display,
    TextStyle? title,
    TextStyle? appBarTitle,
    TextStyle? sectionTitle,
    TextStyle? body,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? button,
  }) {
    return AppTextTheme._(
      display: display ?? this.display,
      title: title ?? this.title,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      body: body ?? this.body,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      button: button ?? this.button,
    );
  }

  @override
  ThemeExtension<AppTextTheme> lerp(covariant ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) {
      return this;
    }
    return AppTextTheme._(
      display: TextStyle.lerp(display, other.display, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}

Never _throwThemeNotFound(BuildContext context) =>
    throw Exception('$AppTextTheme not found in $context');
