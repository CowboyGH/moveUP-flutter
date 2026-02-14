import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/user.dart';

/// Extension for converting Firebase [fb.User] to domain [User] entity.
extension UserMapper on fb.User {
  /// Converts Firebase User to application domain [User] entity.
  User toEntity() {
    return User(
      uid: uid,
      email: email!,
      displayName: displayName,
      photoUrl: photoURL,
    );
  }
}
