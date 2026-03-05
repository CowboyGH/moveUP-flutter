import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/auth/presentation/pages/sign_in_page_builder.dart';
import '../../features/debug/presentation/debug_screen.dart';
import '../di/di.dart';
import '../utils/analytics/app_analytics.dart';
import 'analytics_route_observer.dart';
import 'router_paths.dart';

final AuthSessionCubit _sessionCubit = di<AuthSessionCubit>();

/// Determines the redirect path based on the current [authState] and [state].
String? _regirect(AuthSessionState authState, GoRouterState state) {
  final isAuthScreen = state.matchedLocation.startsWith(AppRoutePaths.authPrefix);
  return authState.when(
    initial: () {
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
    checking: () {
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
    guest: () {
      if (isAuthScreen) return AppRoutePaths.debugPath;
      return null;
    },
    authenticated: (user) {
      if (isAuthScreen) return AppRoutePaths.debugPath;
      return null;
    },
    unauthenticated: () {
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
  );
}

/// The application's router using GoRouter.
final router = GoRouter(
  initialLocation: AppRoutePaths.signInPath,
  observers: [AnalyticsRouteObserver(di<AppAnalytics>())],
  redirect: (_, state) => _regirect(_sessionCubit.state, state),
  refreshListenable: GoRouterCubitRefreshStream(_sessionCubit.stream),
  routes: [
    GoRoute(
      path: AppRoutePaths.debugPath,
      builder: (context, state) => const DebugScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.signInPath,
      builder: (_, _) => const SignInPageBuilder(),
    ),
  ],
);

/// A [ChangeNotifier] that notifies listeners when [stream] emits.
class GoRouterCubitRefreshStream<T> extends ChangeNotifier {
  late final StreamSubscription<T> _subscription;

  /// Creates a [GoRouterCubitRefreshStream] for [stream].
  GoRouterCubitRefreshStream(Stream<T> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
