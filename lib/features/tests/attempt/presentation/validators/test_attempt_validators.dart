import '../../../../../core/constants/app_strings.dart';

/// Validators used by the test attempt UI.
abstract final class TestAttemptValidators {
  /// Validates pulse input after the last exercise.
  static String? pulse(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) return AppStrings.testsAttemptPulseRequired;

    final pulse = int.tryParse(trimmedValue);
    if (pulse == null) return AppStrings.testsAttemptPulseInvalid;
    if (pulse < 30 || pulse > 220) return AppStrings.testsAttemptPulseRange;

    return null;
  }
}
