// API Client
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/logger/app_logger.dart';
import 'api_paths.dart';
import 'interceptors/logging_interceptor.dart';

/// Creates and configures a Dio HTTP client.
Dio createDioClient({required AppLogger logger}) {
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

  if (kDebugMode) {
    dio.interceptors.addAll([
      LoggingInterceptor(logger),
    ]);
  }

  return dio;
}
