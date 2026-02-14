import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../services/network/network_service.dart';
import '../services/network/network_service_impl.dart';
import '../utils/analytics/app_analytics.dart';
import '../utils/analytics/debug_analytics_impl.dart';
import '../utils/analytics/firebase_analytics_impl.dart';
import '../utils/logger/app_logger.dart';
import '../utils/logger/app_logger_impl.dart';
import '../utils/logger/logger_setup.dart';

/// Global instance of the GetIt service locator for dependency management.
final di = GetIt.instance;

/// Initializes the application's dependencies using GetIt.
Future<void> setupDI() async {
  // Logger
  di.registerLazySingleton<Logger>(() => createLogger());
  di.registerLazySingleton<AppLogger>(() => AppLoggerImpl(di<Logger>()));

  // Firebase Analytics
  di.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  di.registerLazySingleton<AppAnalytics>(
    () => kReleaseMode
        ? FirebaseAnalyticsImpl(di<FirebaseAnalytics>())
        : DebugAnalyticsImpl(di<AppLogger>()),
  );

  // Authentication
  di.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  di.registerSingletonAsync<GoogleSignIn>(() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    return googleSignIn;
  });
  di.registerSingletonWithDependencies<AuthRepository>(
    () => AuthRepositoryImpl(
      di<AppLogger>(),
      di<FirebaseAuth>(),
      di<GoogleSignIn>(),
    ),
    dependsOn: [GoogleSignIn],
  );
  di.registerLazySingleton(() => AuthBloc(di<AppAnalytics>(), di<AuthRepository>()));

  /// Connectivity
  di.registerLazySingleton<Connectivity>(() => Connectivity());
  di.registerLazySingleton<NetworkService>(
    () => NetworkServiceImpl(di<Connectivity>()),
    dispose: (param) => param.dispose(),
  );

  await di.allReady();
}
