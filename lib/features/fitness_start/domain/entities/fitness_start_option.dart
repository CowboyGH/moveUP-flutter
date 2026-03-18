import 'package:equatable/equatable.dart';

/// Domain option used by Fitness Start selection steps.
class FitnessStartOption extends Equatable {
  /// Unique option identifier.
  final int id;

  /// Human-readable option name.
  final String name;

  /// Creates an instance of [FitnessStartOption].
  const FitnessStartOption({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
