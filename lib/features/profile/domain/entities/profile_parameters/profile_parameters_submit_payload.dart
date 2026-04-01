import 'package:equatable/equatable.dart';

import 'profile_parameters_gender.dart';

/// Typed form payload submitted from the profile parameters section.
final class ProfileParametersSubmitPayload extends Equatable {
  /// Selected goal identifier.
  final int goalId;

  /// Selected gender value.
  final ProfileParametersGender gender;

  /// User age in years.
  final int age;

  /// User weight in kilograms.
  final double weight;

  /// User height in centimeters.
  final int height;

  /// Selected equipment identifier.
  final int equipmentId;

  /// Selected preparation level identifier.
  final int levelId;

  /// Weekly training goal.
  final int weeklyGoal;

  /// Creates an instance of [ProfileParametersSubmitPayload].
  const ProfileParametersSubmitPayload({
    required this.goalId,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.equipmentId,
    required this.levelId,
    required this.weeklyGoal,
  });

  @override
  List<Object?> get props => [
    goalId,
    gender,
    age,
    weight,
    height,
    equipmentId,
    levelId,
    weeklyGoal,
  ];
}
