/// Abstraction for clearing persisted guest backend session data.
abstract interface class GuestSessionStorage {
  /// Clears any guest session data persisted locally.
  Future<void> clear();
}
