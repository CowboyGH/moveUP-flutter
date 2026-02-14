/// Abstract interface for monitoring network availability.
abstract interface class NetworkService {
  /// Stream that emits network availability changes.
  Stream<bool> get connectionStream;

  /// Latest known network availability value.
  bool get isConnected;

  /// Initializes the service, performing the initial connectivity check.
  Future<void> init();

  /// Performs a one-shot check of current network availability.
  Future<bool> hasNetwork();

  /// Releases resources (stream subscription, controllers).
  Future<void> dispose();
}
