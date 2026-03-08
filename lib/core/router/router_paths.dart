/// Contains all the route paths used for app navigation.
abstract class AppRoutePaths {
  /// Route path for the debug screen.
  static const debugPath = '/debug';

  /// Prefix for all authentication-related routes.
  static const authPrefix = '/auth';

  /// Route path for the sign-in page.
  static const signInPath = '$authPrefix/sign-in';

  /// Route path for the sign-up page.
  static const signUpPath = '$authPrefix/sign-up';

  /// Route path for the forgot-password page.
  static const forgotPasswordPath = '$authPrefix/forgot-password';

  /// Route path for the verify-reset-code page.
  static const verifyResetCodePath = '$forgotPasswordPath/verify-code';

  /// Route path for the reset-password page.
  static const resetPasswordPath = '$forgotPasswordPath/reset';

  /// Route path for the verify-email page.
  static const verifyEmailPath = '$authPrefix/verify-email';
}
