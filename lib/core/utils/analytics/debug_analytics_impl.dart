import '../logger/app_logger.dart';
import 'app_analytics.dart';

/// Implementation of [AppAnalytics].
final class DebugAnalyticsImpl implements AppAnalytics {
  final AppLogger _logger;

  /// Creates an instance of [DebugAnalyticsImpl].
  DebugAnalyticsImpl(this._logger);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async =>
      _logger.i('Event: $name, params: $parameters');

  @override
  Future<void> logScreenView(String screenName) async => _logger.i('ScreenView: $screenName');
}
