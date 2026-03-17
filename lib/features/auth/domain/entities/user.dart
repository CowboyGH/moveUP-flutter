import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
class User extends Equatable {
  /// Unique identifier for the user.
  final int id;

  /// Name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Avatar of the user.
  final String? avatar;

  /// Creates an instance of [User].
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, avatar];
}
