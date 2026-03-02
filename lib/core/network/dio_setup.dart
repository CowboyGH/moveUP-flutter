import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/token_storage/token_storage.dart';
import '../utils/logger/app_logger.dart';
import 'api_paths.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Creates and configures a Dio HTTP client.
Dio createDioClient({
  required AppLogger logger,
  required TokenStorage tokenStorage,
}) {
  final baseOptions = BaseOptions(
    baseUrl: ApiPaths.baseUrl,
    headers: const <String, dynamic>{
      Headers.acceptHeader: Headers.jsonContentType,
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 10),
  );

  /// Main Dio instance for all API calls.
  final dio = Dio(baseOptions);

  /// Separate Dio instance for token refresh only to avoid interceptor loops.
  final refreshDio = Dio(baseOptions);

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage,
      dio,
      refreshCall: (accessToken) {
        return refreshDio.post<dynamic>(
          ApiPaths.refresh,
          options: Options(
            headers: {
              ...refreshDio.options.headers,
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LoggingInterceptor(logger));
  }

  return dio;
}
