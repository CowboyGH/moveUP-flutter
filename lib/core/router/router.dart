import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/debug/presentation/debug_screen.dart';
import '../di/di.dart';
import '../utils/analytics/app_analytics.dart';
import 'analytics_route_observer.dart';
import 'router_paths.dart';

/// The application's router using GoRouter.
final router = GoRouter(
  initialLocation: AppRoutePaths.signInPath,
  observers: [AnalyticsRouteObserver(di<AppAnalytics>())],
  routes: [
    GoRoute(
      path: AppRoutePaths.debugPath,
      builder: (context, state) => const DebugScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.signInPath,
      builder: (_, _) => const SignInPage(),
    ),
  ],
);
