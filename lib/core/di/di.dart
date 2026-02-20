import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../features/auth/data/remote/auth_api_client.dart';
import '../network/api_paths.dart';
import '../services/network/network_service.dart';
import '../services/network/network_service_impl.dart';
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

  // API Client
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.baseUrl,
      headers: const <String, dynamic>{
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  di.registerLazySingleton(() => dio);
  di.registerLazySingleton(() => AuthApiClient(di<Dio>()));

  if (kDebugMode) {
    final logger = di<AppLogger>();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d('-> ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d(
            '<- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final request = error.requestOptions;
          logger.w(
            'x ${error.response?.statusCode ?? '-'} ${error.type} ${request.method} ${request.uri} ${error.message ?? ''}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  await di.allReady();
}
