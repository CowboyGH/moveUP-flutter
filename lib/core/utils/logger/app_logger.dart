/// Abstract class for application logging.
abstract interface class AppLogger {
  /// Log a message at trace level.
  void t(String message, [Object? error, StackTrace? stackTrace]);

  /// Log a message at debug level.
  void d(String message, [Object? error, StackTrace? stackTrace]);

  /// Log a message at info level.
  void i(String message, [Object? error, StackTrace? stackTrace]);

  /// Log a message at warning level.
  void w(String message, [Object? error, StackTrace? stackTrace]);

  /// Log a message at error level.
  void e(String message, [Object? error, StackTrace? stackTrace]);

  /// Log a message at fatal level.
  void f(String message, [Object? error, StackTrace? stackTrace]);
}
