import 'package:equatable/equatable.dart';

/// Single-select option for the profile statistics exercise selector.
final class ProfileExerciseOption extends Equatable {
  /// Exercise identifier.
  final int id;

  /// Exercise title.
  final String name;

  /// Optional formatted last usage label.
  final String? lastUsedFormatted;

  /// Creates an instance of [ProfileExerciseOption].
  const ProfileExerciseOption({
    required this.id,
    required this.name,
    required this.lastUsedFormatted,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    lastUsedFormatted,
  ];
}
