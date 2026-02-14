import 'package:firebase_analytics/firebase_analytics.dart';

import 'app_analytics.dart';

/// Implementation of [AppAnalytics].
final class FirebaseAnalyticsImpl implements AppAnalytics {
  final FirebaseAnalytics _analytics;

  /// Creates an instance of [FirebaseAnalyticsImpl].
  FirebaseAnalyticsImpl(this._analytics);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async =>
      await _analytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> logScreenView(String screenName) async =>
      await _analytics.logScreenView(screenName: screenName);
}
