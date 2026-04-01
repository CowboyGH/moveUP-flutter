import 'package:equatable/equatable.dart';

import 'profile_parameters_gender.dart';

/// Bootstrap snapshot used to seed the profile parameters section.
final class ProfileParametersSnapshot extends Equatable {
  /// Goal display name.
  final String goal;

  /// Selected gender.
  final ProfileParametersGender gender;

  /// User age in years.
  final int age;

  /// User weight in kilograms.
  final double weight;

  /// User height in centimeters.
  final int height;

  /// Equipment display name.
  final String equipment;

  /// Preparation level display name.
  final String level;

  /// Creates an instance of [ProfileParametersSnapshot].
  const ProfileParametersSnapshot({
    required this.goal,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.equipment,
    required this.level,
  });

  @override
  List<Object?> get props => [goal, gender, age, weight, height, equipment, level];
}
