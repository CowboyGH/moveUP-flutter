import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_service.dart';

/// Implementation of [NetworkService] using connectivity_plus package.
final class NetworkServiceImpl implements NetworkService {
  final Connectivity _connectivity;

  final _controller = StreamController<bool>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool? _lastHasNetwork;

  /// Creates an instance of [NetworkServiceImpl].
  NetworkServiceImpl(this._connectivity) {
    _subscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _emit(!results.contains(ConnectivityResult.none));
  }

  /// Emits [hasNetwork] to [connectionStream] when it changes.
  void _emit(bool hasNetwork) {
    if (_lastHasNetwork == hasNetwork) return;
    _lastHasNetwork = hasNetwork;
    if (!_controller.isClosed) _controller.add(hasNetwork);
  }

  @override
  Future<void> init() async {
    _emit(await hasNetwork());
  }

  @override
  Future<bool> hasNetwork() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get connectionStream => _controller.stream;

  @override
  bool get isConnected => _lastHasNetwork ?? false;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}
