import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/debug/presentation/debug_screen.dart';
import '../di/di.dart';
import '../utils/analytics/app_analytics.dart';
import 'analytics_route_observer.dart';
import 'router_paths.dart';

/// Determines the redirect path based on the current [authState] and [state].
String? _redirect(AuthState authState, GoRouterState state) {
  final isAuthScreen = state.matchedLocation.startsWith(AppRoutePaths.authPrefix);

  return authState.maybeWhen(
    authenticated: (user) {
      if (isAuthScreen) return AppRoutePaths.debugPath;
      return null;
    },
    unauthenticated: () {
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
    orElse: () => null,
  );
}

/// The application's router using GoRouter.
final router = GoRouter(
  initialLocation: AppRoutePaths.signInPath,
  observers: [
    AnalyticsRouteObserver(di<AppAnalytics>()),
  ],
  redirect: (_, state) => _redirect(di<AuthBloc>().state, state),
  refreshListenable: GoRouterAuthRefreshStream(di<AuthBloc>().stream),
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

/// A [ChangeNotifier] that listens to a [Stream] and notifies listeners on new events.
class GoRouterAuthRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterAuthRefreshStream] that listens to the provided [stream].
  GoRouterAuthRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
