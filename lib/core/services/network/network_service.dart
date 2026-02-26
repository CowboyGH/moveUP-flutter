/// Abstract interface for monitoring device connectivity state.
///
/// Connectivity is inferred from available network interfaces and does not
/// guarantee internet reachability.
abstract interface class NetworkService {
  /// Stream that emits connectivity state changes.
  ///
  /// Emits `true` when at least one network interface is available,
  /// otherwise emits `false`.
  Stream<bool> get connectionStream;

  /// Latest known connectivity state.
  ///
  /// This value does not guarantee that external hosts are reachable.
  bool get isConnected;

  /// Initializes the service with an initial connectivity check.
  Future<void> init();

  /// Performs a one-shot connectivity check.
  Future<bool> hasNetwork();

  /// Releases resources (stream subscription, controllers).
  Future<void> dispose();
}
