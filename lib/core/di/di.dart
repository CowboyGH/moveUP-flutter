import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/auth/data/remote/auth_api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/fitness_start/data/remote/fitness_start_api_client.dart';
import '../../features/fitness_start/data/repositories/fitness_start_repository_impl.dart';
import '../../features/fitness_start/domain/repositories/fitness_start_repository.dart';
import '../../features/offline/presentation/cubit/network_cubit.dart';
import '../../features/tests/attempt/data/repositories/guest_test_attempt_repository_impl.dart';
import '../../features/tests/attempt/domain/repositories/test_attempt_repository.dart';
import '../../features/tests/catalog/data/repositories/tests_catalog_repository_impl.dart';
import '../../features/tests/catalog/domain/repositories/tests_catalog_repository.dart';
import '../../features/tests/data/remote/tests_api_client.dart';
import '../network/api_paths.dart';
import '../network/dio_setup.dart';
import '../services/fitness_start_progress_storage/fitness_start_progress_storage.dart';
import '../services/fitness_start_progress_storage/hive_fitness_start_progress_storage.dart';
import '../services/guest_session_storage/cookie_jar_guest_session_storage.dart';
import '../services/guest_session_storage/guest_session_storage.dart';
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
  final fitnessStartProgressBox = await Hive.openBox<dynamic>(
    HiveFitnessStartProgressStorage.boxName,
  );
  final supportDirectory = await getApplicationSupportDirectory();
  final cookiesDirectory = Directory(
    '${supportDirectory.path}/guest_cookies',
  );
  final cookieJar = PersistCookieJar(
    storage: FileStorage(cookiesDirectory.path),
  );

  // Logger
  di.registerLazySingleton<Logger>(() => createLogger());
  di.registerLazySingleton<AppLogger>(() => AppLoggerImpl(di<Logger>()));

  // Analytics
  di.registerLazySingleton<AppAnalytics>(() => DebugAnalyticsImpl(di<AppLogger>()));

  // Connectivity
  di.registerLazySingleton<Connectivity>(() => Connectivity());
  di.registerLazySingleton<NetworkService>(
    () => NetworkServiceImpl(di<Connectivity>()),
    dispose: (service) => service.dispose(),
  );
  di.registerLazySingleton<NetworkCubit>(
    () => NetworkCubit(di<NetworkService>()),
    dispose: (cubit) => cubit.close(),
  );

  // Storages
  di.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(const FlutterSecureStorage()),
  );
  di.registerLazySingleton<FitnessStartProgressStorage>(
    () => HiveFitnessStartProgressStorage(fitnessStartProgressBox),
    dispose: (_) => fitnessStartProgressBox.close(),
  );
  di.registerLazySingleton<CookieJar>(() => cookieJar);
  di.registerLazySingleton<GuestSessionStorage>(
    () => CookieJarGuestSessionStorage(
      di<CookieJar>(),
      Uri.parse(ApiPaths.baseUrl),
    ),
  );

  // Authentication
  di.registerLazySingleton<Dio>(
    () => createDioClient(
      logger: di<AppLogger>(),
      tokenStorage: di<TokenStorage>(),
      cookieJar: di<CookieJar>(),
    ),
  );
  di.registerLazySingleton<AuthApiClient>(() => AuthApiClient(di<Dio>()));
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      di<AppLogger>(),
      di<AuthApiClient>(),
      di<TokenStorage>(),
    ),
  );

  // Fitness Start
  di.registerLazySingleton<FitnessStartApiClient>(() => FitnessStartApiClient(di<Dio>()));
  di.registerLazySingleton<FitnessStartRepository>(
    () => FitnessStartRepositoryImpl(
      di<AppLogger>(),
      di<FitnessStartApiClient>(),
    ),
  );
  di.registerLazySingleton<AuthSessionCubit>(
    () => AuthSessionCubit(
      di<AuthRepository>(),
      di<TokenStorage>(),
      di<FitnessStartProgressStorage>(),
      di<GuestSessionStorage>(),
      di<AppLogger>(),
    ),
    dispose: (cubit) => cubit.close(),
  );

  // Tests
  di.registerLazySingleton<TestsApiClient>(() => TestsApiClient(di<Dio>()));
  di.registerLazySingleton<TestsCatalogRepository>(
    () => TestsCatalogRepositoryImpl(
      di<AppLogger>(),
      di<TestsApiClient>(),
    ),
  );
  di.registerLazySingleton<TestAttemptRepository>(
    () => GuestTestAttemptRepositoryImpl(
      di<AppLogger>(),
      di<TestsApiClient>(),
    ),
  );
}
