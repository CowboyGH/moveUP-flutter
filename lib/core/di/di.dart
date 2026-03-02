import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../features/auth/data/remote/auth_api_client.dart';
import '../network/dio_setup.dart';
import '../services/network/network_service.dart';
import '../services/network/network_service_impl.dart';
import '../services/token_storage/secure_token_storage.dart';
import '../services/token_storage/token_storage.dart';
import '../utils/analytics/app_analytics.dart';
import '../utils/analytics/debug_analytics_impl.dart';
import '../utils/logger/app_logger.dart';
import '../utils/logger/app_logger_impl.dart';
import '../utils/logger/logger_setup.dart';

/// Global instance of the GetIt service locator for dependency management.
final di = GetIt.instance;

/// Initializes application dependencies in the global [di] container.
Future<void> setupDI() async {
  // Logger
  di.registerLazySingleton<Logger>(() => createLogger());
  di.registerLazySingleton<AppLogger>(() => AppLoggerImpl(di<Logger>()));

  // Analytics
  di.registerLazySingleton<AppAnalytics>(() => DebugAnalyticsImpl(di<AppLogger>()));

  // Connectivity
  di.registerLazySingleton<Connectivity>(() => Connectivity());
  di.registerLazySingleton<NetworkService>(
    () => NetworkServiceImpl(di<Connectivity>()),
    dispose: (param) => param.dispose(),
  );

  // Token Storage
  di.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(const FlutterSecureStorage()),
  );

  // Auth API Client
  di.registerLazySingleton<Dio>(
    () => createDioClient(
      logger: di<AppLogger>(),
      tokenStorage: di<TokenStorage>(),
    ),
  );
  di.registerLazySingleton<AuthApiClient>(() => AuthApiClient(di<Dio>()));

  await di.allReady();
}
