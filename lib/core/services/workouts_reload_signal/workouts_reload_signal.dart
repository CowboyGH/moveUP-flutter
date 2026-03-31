import 'dart:async';

/// Shared broadcast signal used to trigger workouts overview reloads.
final class WorkoutsReloadSignal {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  /// Stream of reload notifications.
  Stream<void> get stream => _controller.stream;

  /// Emits a workouts reload notification.
  void notify() {
    if (_controller.isClosed) return;
    _controller.add(null);
  }

  /// Closes the signal stream.
  Future<void> dispose() => _controller.close();
}
