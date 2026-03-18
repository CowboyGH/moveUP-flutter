import '../../../../core/constants/app_strings.dart';

/// Validators for Fitness Start form fields.
abstract final class FitnessStartValidators {
  static const _minAge = 14;
  static const _maxAge = 90;
  static const _minWeight = 40;
  static const _maxWeight = 130;
  static const _minHeight = 140;
  static const _maxHeight = 210;

  /// Validates age input.
  static String? age(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return AppStrings.fitnessStartAgeRequired;
    }

    final parsedValue = int.tryParse(trimmedValue);
    if (parsedValue == null) {
      return AppStrings.fitnessStartAgeInvalid;
    }
    if (parsedValue < _minAge || parsedValue > _maxAge) {
      return AppStrings.fitnessStartAgeRange;
    }

    return null;
  }

  /// Validates weight input.
  static String? weight(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return AppStrings.fitnessStartWeightRequired;
    }

    final parsedValue = double.tryParse(trimmedValue.replaceAll(',', '.'));
    if (parsedValue == null) {
      return AppStrings.fitnessStartWeightInvalid;
    }
    if (parsedValue < _minWeight || parsedValue > _maxWeight) {
      return AppStrings.fitnessStartWeightRange;
    }

    return null;
  }

  /// Validates height input.
  static String? height(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return AppStrings.fitnessStartHeightRequired;
    }

    final parsedValue = int.tryParse(trimmedValue);
    if (parsedValue == null) {
      return AppStrings.fitnessStartHeightInvalid;
    }
    if (parsedValue < _minHeight || parsedValue > _maxHeight) {
      return AppStrings.fitnessStartHeightRange;
    }

    return null;
  }
}
