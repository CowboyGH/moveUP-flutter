/// Abstract class for app analytics functionality.
abstract interface class AppAnalytics {
  /// Logs an event with the given name and parameters.
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  /// Logs a screen view with the given screen name.
  Future<void> logScreenView(String screenName);
}
