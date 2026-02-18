import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

/// Retrofit API client for making HTTP requests.
@RestApi()
abstract class ApiClient {
  /// Creates an instance of [ApiClient].
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;
}
