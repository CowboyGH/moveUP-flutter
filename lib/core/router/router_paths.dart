/// Contains all the route paths used for app navigation.
abstract class AppRoutePaths {
  /// Route path for the debug screen.
  static const debugPath = '/debug';

  /// Route path for the splash screen.
  static const splashPath = '/splash';
  
  /// Route path for the offline page.
  static const offlinePath = '/offline';

  /// Route path for the tests root tab.
  static const testsPath = '/tests';

  /// Route path for the trainings root tab.
  static const trainingsPath = '/trainings';

  /// Route path for the profile root tab.
  static const profilePath = '/profile';

  /// Prefix for all authentication-related routes.
  static const authPrefix = '/auth';

  /// Route path for the sign-in page.
  static const signInPath = '$authPrefix/sign-in';

  /// Route path for the sign-up page.
  static const signUpPath = '$authPrefix/sign-up';

  /// Route path for the legal-document page.
  static const legalDocumentPath = '$authPrefix/legal-document';

  /// Route path for the forgot-password page.
  static const forgotPasswordPath = '$authPrefix/forgot-password';

  /// Route path for the verify-reset-code page.
  static const verifyResetCodePath = '$forgotPasswordPath/verify-code';

  /// Route path for the reset-password page.
  static const resetPasswordPath = '$forgotPasswordPath/reset';

  /// Route path for the verify-email page.
  static const verifyEmailPath = '$authPrefix/verify-email';

  /// Prefix for the Fitness Start onboarding flow.
  static const fitnessStartPrefix = '/fitness-start';

  /// Route path for the Fitness Start quiz.
  static const fitnessStartQuizPath = '$fitnessStartPrefix/quiz';

  /// Route path for the next onboarding step that will show tests.
  static const fitnessStartTestsPath = '$fitnessStartPrefix/tests';

  /// Base route path for a concrete test attempt inside Fitness Start.
  static const fitnessStartTestAttemptBasePath = '$fitnessStartTestsPath/attempt';

  /// Route path pattern for a concrete test attempt inside Fitness Start.
  static const fitnessStartTestAttemptPath = '$fitnessStartTestAttemptBasePath/:testingId';

  /// Builds the concrete route path for a test attempt by [testingId].
  static String fitnessStartTestAttemptDetailsPath(int testingId) =>
      '$fitnessStartTestAttemptBasePath/$testingId';
}
