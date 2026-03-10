// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

/// Gradient tokens from the design palette.
abstract class AppGradients {
  static const secondaryLinear = LinearGradient(
    stops: [0.0, 0.4, 0.72, 1.0],
    colors: [
      Color(0x003BA3A4),
      Color(0xFF3BA3A4),
      Color(0x823A8383),
      Color(0x003BA3A4),
    ],
  );

  static const whiteLinear = LinearGradient(
    stops: [0.0, 1.0],
    colors: [
      Color(0x4DFFFFFF),
      Color(0xFFFFFFFF),
    ],
  );

  static const stroke05 = LinearGradient(
    stops: [0.0, 0.4, 0.7, 1.0],
    colors: [
      Color(0x00000000),
      Color(0xFFA4A4A4),
      Color(0x82545454),
      Color(0x00000000),
    ],
  );
}
