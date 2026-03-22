import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Tests catalog application error.
sealed class TestsFailure extends AppFailure {
  /// Creates an instance of [TestsFailure].
  const TestsFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Tests request failed because of infrastructure or network conditions.
final class TestsRequestFailure extends TestsFailure {
  /// Creates an instance of [TestsRequestFailure].
  const TestsRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Tests validation failed because the provided input is invalid.
final class TestsValidationFailure extends TestsFailure {
  /// Creates an instance of [TestsValidationFailure].
  const TestsValidationFailure({
    String message = AppStrings.testsValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Unknown tests failure.
final class UnknownTestsFailure extends TestsFailure {
  /// Creates an instance of [UnknownTestsFailure].
  const UnknownTestsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.testsUnknown);
}
