import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration class.
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// The base URL for the API.
  @EnviedField(varName: 'API_URL')
  static final String apiUrl = _Env.apiUrl;
}
