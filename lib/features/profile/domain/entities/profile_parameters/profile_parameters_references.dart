import 'package:equatable/equatable.dart';

import 'profile_parameters_option.dart';

/// Reference data used to render the profile parameters form.
final class ProfileParametersReferences extends Equatable {
  /// Available goal options.
  final List<ProfileParametersOption> goals;

  /// Available preparation level options.
  final List<ProfileParametersOption> levels;

  /// Available equipment options.
  final List<ProfileParametersOption> equipment;

  /// Creates an instance of [ProfileParametersReferences].
  const ProfileParametersReferences({
    required this.goals,
    required this.levels,
    required this.equipment,
  });

  @override
  List<Object?> get props => [goals, levels, equipment];
}
