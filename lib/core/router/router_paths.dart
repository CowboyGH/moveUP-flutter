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
}
