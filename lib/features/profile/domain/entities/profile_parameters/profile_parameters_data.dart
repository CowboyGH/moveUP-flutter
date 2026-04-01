import 'package:equatable/equatable.dart';

import 'profile_parameters_gender.dart';

/// Canonical authenticated parameters payload for the profile form.
final class ProfileParametersData extends Equatable {
  /// Selected goal identifier.
  final int goalId;

  /// Selected equipment identifier.
  final int equipmentId;

  /// Selected preparation level identifier.
  final int levelId;

  /// Selected gender value.
  final ProfileParametersGender gender;

  /// User age in years.
  final int age;

  /// User weight in kilograms.
  final double weight;

  /// User height in centimeters.
  final int height;

  /// Goal display name.
  final String goalName;

  /// Equipment display name.
  final String equipmentName;

  /// Preparation level display name.
  final String levelName;

  /// Creates an instance of [ProfileParametersData].
  const ProfileParametersData({
    required this.goalId,
    required this.equipmentId,
    required this.levelId,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.goalName,
    required this.equipmentName,
    required this.levelName,
  });

  @override
  List<Object?> get props => [
    goalId,
    equipmentId,
    levelId,
    gender,
    age,
    weight,
    height,
    goalName,
    equipmentName,
    levelName,
  ];
}
