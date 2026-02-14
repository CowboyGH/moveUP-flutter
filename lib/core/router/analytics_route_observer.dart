import 'package:flutter/material.dart';

import '../utils/analytics/app_analytics.dart';

/// A universal navigation observer that sends screen view events
/// to the application's analytics abstraction.
class AnalyticsRouteObserver extends NavigatorObserver {
  final AppAnalytics _analytics;

  /// Creates an instance of [AnalyticsRouteObserver].
  AnalyticsRouteObserver(this._analytics);

  @override
  void didPush(Route route, Route? previousRoute) {
    _logScreen(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) _logScreen(previousRoute);

    super.didPop(route, previousRoute);
  }

  void _logScreen(Route route) {
    final screenName = route.settings.name;

    if (screenName == null) return;

    _analytics.logScreenView(screenName);
  }
}
