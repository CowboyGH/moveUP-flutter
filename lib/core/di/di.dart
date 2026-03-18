import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../../features/auth/data/remote/auth_api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubits/auth_session_cubit.dart';
import '../../features/fitness_start/data/remote/fitness_start_api_client.dart';
import '../../features/fitness_start/data/repositories/fitness_start_repository_impl.dart';
import '../../features/fitness_start/domain/repositories/fitness_start_repository.dart';
import '../network/dio_setup.dart';
import '../services/network/network_service.dart';
import '../services/network/network_service_impl.dart';
import '../services/onboarding_flow_storage/hive_onboarding_flow_storage.dart';
import '../services/onboarding_flow_storage/onboarding_flow_storage.dart';
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
  final onboardingFlowBox = await Hive.openBox<dynamic>(HiveOnboardingFlowStorage.boxName);

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

  // Storages
  di.registerLazySingleton<TokenStorage>(
    () => SecureTokenStorage(const FlutterSecureStorage()),
  );
  di.registerLazySingleton<OnboardingFlowStorage>(
    () => HiveOnboardingFlowStorage(onboardingFlowBox),
    dispose: (_) => onboardingFlowBox.close(),
  );

  // Authentication
  di.registerLazySingleton<Dio>(
    () => createDioClient(
      logger: di<AppLogger>(),
      tokenStorage: di<TokenStorage>(),
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
      di<OnboardingFlowStorage>(),
      di<AppLogger>(),
    ),
    dispose: (cubit) => cubit.close(),
  );
}
