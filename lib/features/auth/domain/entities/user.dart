import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
class User extends Equatable {
  /// Unique identifier of the user.
  final String uid;

  /// Email address.
  final String email;

  /// Creates an instance of [User].
  const User({
    required this.uid,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, email];
}
