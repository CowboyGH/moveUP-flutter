import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

/// Retrofit API client for making authentication requests.
@RestApi()
abstract class AuthApiClient {
  /// Creates an instance of [AuthApiClient].
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;
}
