// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

/// The text styles used in the app.
abstract class AppTextStyle {
  static const _fontFamily = 'Montserrat';

  static const display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w600,
  );

  static const title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w400,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 21 / 14,
    fontWeight: FontWeight.w400,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    height: 15 / 10,
    fontWeight: FontWeight.w400,
  );

  static const label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w500,
  );

  static const button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w600,
  );
}
