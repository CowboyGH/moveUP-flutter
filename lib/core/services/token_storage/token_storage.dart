/// Interface for token storage.
abstract interface class TokenStorage {
  /// Reads access token from storage.
  Future<String?> getAccessToken();

  /// Saves access token to storage.
  Future<void> saveAccessToken(String token);

  /// Clears access token from storage.
  Future<void> deleteAccessToken();

  /// Checks whether access token exists in storage.
  Future<bool> hasAccessToken();
}
