import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page_builder.dart';
import '../../features/auth/presentation/pages/legal_document_page.dart';
import '../../features/auth/presentation/pages/legal_document_type.dart';
import '../../features/auth/presentation/pages/reset_password_page_builder.dart';
import '../../features/auth/presentation/pages/reset_password_route_args.dart';
import '../../features/auth/presentation/pages/sign_in_page_builder.dart';
import '../../features/auth/presentation/pages/sign_up_page_builder.dart';
import '../../features/auth/presentation/pages/verify_email_page_builder.dart';
import '../../features/auth/presentation/pages/verify_email_route_args.dart';
import '../../features/auth/presentation/pages/verify_reset_code_page_builder.dart';
import '../../features/debug/presentation/debug_screen.dart';
import '../../features/fitness_start/presentation/pages/fitness_start_quiz_page_builder.dart';
import '../../features/fitness_start/presentation/pages/fitness_start_test_attempt_page_builder.dart';
import '../../features/fitness_start/presentation/pages/fitness_start_tests_page_builder.dart';
import '../../features/root/presentation/pages/root_screen.dart';
import '../../uikit/themes/colors/app_color_theme.dart';
import '../../uikit/themes/text/app_text_theme.dart';
import '../../features/offline/presentation/cubit/network_cubit.dart';
import '../../features/offline/presentation/pages/offline_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/di.dart';
import '../utils/analytics/app_analytics.dart';
import 'analytics_route_observer.dart';
import 'router_paths.dart';

final NetworkCubit _networkCubit = di<NetworkCubit>();
final AuthSessionCubit _sessionCubit = di<AuthSessionCubit>();
bool _isStartupSplashCompleted = false;

/// Minimum time the startup splash route should remain visible.
const startupSplashDuration = Duration(milliseconds: 1500);

/// Marks the startup splash as completed and re-runs redirects.
void completeStartupSplash() {
  if (_isStartupSplashCompleted) return;

  _isStartupSplashCompleted = true;
  router.refresh();
}

bool _isGuestCompletedAllowedPath(String path) =>
    path == AppRoutePaths.signUpPath ||
    path == AppRoutePaths.signInPath ||
    path == AppRoutePaths.verifyEmailPath ||
    path == AppRoutePaths.forgotPasswordPath ||
    path == AppRoutePaths.verifyResetCodePath ||
    path == AppRoutePaths.resetPasswordPath ||
    path == AppRoutePaths.legalDocumentPath;

/// Determines the redirect path based on the current [networkState], [authState] and [state].
String? _redirect(
  NetworkState networkState,
  AuthSessionState authState,
  GoRouterState state,
) {
  final isOfflineScreen = state.matchedLocation.startsWith(AppRoutePaths.offlinePath);
  final isSplashScreen = state.matchedLocation == AppRoutePaths.splashPath;
  final isStartupSplashLocked = isSplashScreen && !_isStartupSplashCompleted;

  if (isStartupSplashLocked) return null;

  return networkState.when(
    initial: () => null,
    disconnected: () {
      if (isOfflineScreen) return null;
      return AppRoutePaths.offlinePath;
    },
    connected: () {
      if (isOfflineScreen) return _redirectFromOffline(authState);
      return _redirectByAuth(authState, state);
    },
  );
}

String? _redirectFromOffline(AuthSessionState authState) {
  return authState.when(
    initial: () => AppRoutePaths.splashPath,
    checking: () => AppRoutePaths.splashPath,
    restoreFailed: () => AppRoutePaths.signInPath,
    guestResumeAvailable: () => AppRoutePaths.signInPath,
    guest: () => AppRoutePaths.fitnessStartQuizPath,
    guestCompletedOnboarding: () => AppRoutePaths.signUpPath,
    authenticated: (_) => AppRoutePaths.debugPath,
    unauthenticated: () => AppRoutePaths.signInPath,
  );
}

String? _redirectByAuth(
  AuthSessionState authState,
  GoRouterState state,
) {
  final isSplashScreen = state.matchedLocation == AppRoutePaths.splashPath;
  final isAuthScreen = state.matchedLocation.startsWith(AppRoutePaths.authPrefix);
  final isFitnessStartScreen = state.matchedLocation.startsWith(AppRoutePaths.fitnessStartPrefix);
  return authState.when(
    initial: () {
      if (isSplashScreen) return null;
      return AppRoutePaths.splashPath;
    },
    checking: () {
      if (isSplashScreen) return null;
      return AppRoutePaths.splashPath;
    },
    restoreFailed: () {
      if (isSplashScreen) return AppRoutePaths.signInPath;
      if (state.matchedLocation == AppRoutePaths.signUpPath) {
        return AppRoutePaths.fitnessStartQuizPath;
      }
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
    guestResumeAvailable: () {
      final shouldRedirectToSignIn =
          isSplashScreen || state.matchedLocation != AppRoutePaths.signInPath;
      return shouldRedirectToSignIn ? AppRoutePaths.signInPath : null;
    },
    guest: () {
      if (isSplashScreen) return AppRoutePaths.fitnessStartQuizPath;
      if (isFitnessStartScreen) return null;
      return AppRoutePaths.fitnessStartQuizPath;
    },
    guestCompletedOnboarding: () {
      if (isSplashScreen) return AppRoutePaths.signUpPath;
      if (_isGuestCompletedAllowedPath(state.matchedLocation)) return null;
      return AppRoutePaths.signUpPath;
    },
    authenticated: (user) {
      if (isSplashScreen || isAuthScreen || isFitnessStartScreen) {
        return AppRoutePaths.trainingsPath;
      }
      return null;
    },
    unauthenticated: () {
      if (isSplashScreen) return AppRoutePaths.signInPath;
      if (state.matchedLocation == AppRoutePaths.signUpPath) {
        return AppRoutePaths.fitnessStartQuizPath;
      }
      if (isAuthScreen) return null;
      return AppRoutePaths.signInPath;
    },
  );
}

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

/// The application's router using GoRouter.
final router = GoRouter(
  initialLocation: AppRoutePaths.splashPath,
  observers: [AnalyticsRouteObserver(di<AppAnalytics>())],
  redirect: (_, state) => _redirect(_networkCubit.state, _sessionCubit.state, state),
  refreshListenable: CombinedRouterRefreshListenable(
    _sessionCubit.stream,
    _networkCubit.stream,
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutePaths.testsPath,
              builder: (_, _) => const _RootPlaceholderScreen(
                screenName: AppStrings.testsTab,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutePaths.trainingsPath,
              builder: (_, _) => const _RootPlaceholderScreen(
                screenName: AppStrings.trainingsTab,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutePaths.profilePath,
              builder: (_, _) => const _RootPlaceholderScreen(
                screenName: AppStrings.profileTab,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutePaths.splashPath,
      builder: (_, _) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutePaths.debugPath,
      builder: (context, state) => const DebugScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.offlinePath,
      builder: (context, state) => const OfflinePage(),
    ),
    GoRoute(
      path: AppRoutePaths.signInPath,
      builder: (_, _) => const SignInPageBuilder(),
    ),
    GoRoute(
      path: AppRoutePaths.signUpPath,
      builder: (_, _) => const SignUpPageBuilder(),
    ),
    GoRoute(
      path: AppRoutePaths.legalDocumentPath,
      redirect: (context, state) {
        final extra = state.extra;
        if (extra is! LegalDocumentType) {
          return AppRoutePaths.signUpPath;
        }
        return null;
      },
      builder: (_, state) => LegalDocumentPage(
        legalDocumentType: state.extra as LegalDocumentType,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.forgotPasswordPath,
      builder: (_, _) => const ForgotPasswordPageBuilder(),
    ),
    GoRoute(
      path: AppRoutePaths.verifyResetCodePath,
      redirect: (_, state) {
        final extra = state.extra;
        if (extra is! String || extra.trim().isEmpty) {
          return AppRoutePaths.forgotPasswordPath;
        }
        return null;
      },
      builder: (_, state) => VerifyResetCodePageBuilder(
        email: (state.extra as String).trim(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.resetPasswordPath,
      redirect: (_, state) {
        final extra = state.extra;
        if (extra is! ResetPasswordRouteArgs) {
          return AppRoutePaths.forgotPasswordPath;
        }
        if (extra.email.trim().isEmpty || extra.code.trim().isEmpty) {
          return AppRoutePaths.forgotPasswordPath;
        }
        return null;
      },
      builder: (_, state) {
        final args = state.extra as ResetPasswordRouteArgs;
        return ResetPasswordPageBuilder(
          email: args.email.trim(),
          code: args.code.trim(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.verifyEmailPath,
      redirect: (_, state) {
        final extra = state.extra;
        if (extra is! VerifyEmailRouteArgs || extra.email.trim().isEmpty) {
          return AppRoutePaths.signUpPath;
        }
        return null;
      },
      builder: (_, state) {
        final args = state.extra as VerifyEmailRouteArgs;
        return VerifyEmailPageBuilder(
          email: args.email.trim(),
          resendOnOpen: args.resendOnOpen,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.fitnessStartQuizPath,
      builder: (_, _) => const FitnessStartQuizPageBuilder(),
    ),
    GoRoute(
      path: AppRoutePaths.fitnessStartTestsPath,
      redirect: (_, state) {
        if (state.extra == AppRoutePaths.fitnessStartQuizPath) {
          return null;
        }
        return AppRoutePaths.fitnessStartQuizPath;
      },
      builder: (_, _) => const FitnessStartTestsPageBuilder(),
    ),
    GoRoute(
      path: AppRoutePaths.fitnessStartTestAttemptPath,
      redirect: (_, state) {
        final testingId = int.tryParse(state.pathParameters['testingId'] ?? '');
        if (testingId == null || testingId <= 0) {
          return AppRoutePaths.fitnessStartTestsPath;
        }
        return null;
      },
      builder: (_, state) => FitnessStartTestAttemptPageBuilder(
        testingId: int.parse(state.pathParameters['testingId']!),
      ),
    ),
  ],
);

/// A [ChangeNotifier] that notifies listeners when [stream] emits.
class CombinedRouterRefreshListenable<T, S> extends ChangeNotifier {
  late final StreamSubscription<T> _firstSubscription;
  late final StreamSubscription<S> _secondSubscription;

  /// Creates a [CombinedRouterRefreshListenable] for the provided streams.
  CombinedRouterRefreshListenable(Stream<T> firstStream, Stream<S> secondStream) {
    _firstSubscription = firstStream.listen((_) => notifyListeners());
    _secondSubscription = secondStream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _firstSubscription.cancel();
    _secondSubscription.cancel();
    super.dispose();
  }
}

final class _RootPlaceholderScreen extends StatelessWidget {
  final String screenName;

  const _RootPlaceholderScreen({required this.screenName});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      body: Center(
        child: Text(
          screenName,
          style: textTheme.title.copyWith(color: colorTheme.onSurface),
        ),
      ),
    );
  }
}
