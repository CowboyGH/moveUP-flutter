import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
class User extends Equatable {
  /// Unique identifier of the user.
  final String uid;

  /// Email address.
  final String email;

  /// Display name (optional).
  final String? displayName;

  /// URL of the user's profile photo (optional).
  final String? photoUrl;

  /// Creates an instance of [User].
  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}
