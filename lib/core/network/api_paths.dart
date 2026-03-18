import '../env/env.dart';

/// API paths used in the application.
abstract class ApiPaths {
  /// The base URL for the API.
  static final String baseUrl = Env.apiUrl;

  /// Shared API prefix for backend endpoints.
  static const String apiPrefix = 'api/';

  /// The endpoint for refreshing the access token.
  static const String refresh = '${apiPrefix}refresh';

  /// The endpoint for signing in.
  static const String login = '${apiPrefix}login';

  /// The endpoint for registering a new user.
  static const String register = '${apiPrefix}register';

  /// The endpoint for logging out.
  static const String logout = '${apiPrefix}logout';

  /// The endpoint for requesting password recovery.
  static const String forgotPassword = '${apiPrefix}forgot-password';

  /// The endpoint for verifying email.
  static const String verifyEmail = '${apiPrefix}verify-email';

  /// The endpoint for resending verification code.
  static const String resendVerificationCode = '${apiPrefix}resend-verification-code';

  /// The endpoint for resending reset code.
  static const String resendResetCode = '${apiPrefix}resend-reset-code';

  /// The endpoint for verifying reset code.
  static const String verifyResetCode = '${apiPrefix}verify-reset-code';

  /// The endpoint for resetting password.
  static const String resetPassword = '${apiPrefix}reset-password';

  /// The endpoint for the current user profile.
  static const String me = '${apiPrefix}me';

  /// The endpoint for all user-parameters references.
  static const String userParameterReferences = '${apiPrefix}user-parameters/references';

  /// The endpoint for saving user training goal.
  static const String userParameterGoal = '${apiPrefix}user-parameters/goal';

  /// The endpoint for saving user anthropometry.
  static const String userParameterAnthropometry = '${apiPrefix}user-parameters/anthropometry';

  /// The endpoint for saving user fitness level.
  static const String userParameterLevel = '${apiPrefix}user-parameters/level';
}
