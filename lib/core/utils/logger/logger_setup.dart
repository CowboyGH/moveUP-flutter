import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Creates and configures the [Logger] instance based on the environment.
Logger createLogger() {
  const isRelease = kReleaseMode;
  final printer = isRelease
      ? PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 100,
          colors: false,
          printEmojis: false,
        )
      : PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 100,
          colors: false,
        );
  return Logger(
    level: isRelease ? Level.warning : Level.debug,
    printer: printer,
  );
}
