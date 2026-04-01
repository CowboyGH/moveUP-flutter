import 'package:equatable/equatable.dart';

/// Single-select option used by the profile parameters section.
final class ProfileParametersOption extends Equatable {
  /// Option identifier.
  final int id;

  /// Human-readable option name.
  final String name;

  /// Creates an instance of [ProfileParametersOption].
  const ProfileParametersOption({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
