part of 'network_cubit.dart';

/// States for [NetworkCubit].
@freezed
class NetworkState with _$NetworkState {
  /// Initial state before connectivity is resolved for the first time.
  const factory NetworkState.initial() = _Initial;

  /// Device has at least one available network interface.
  ///
  /// This does not guarantee that the backend is reachable.
  const factory NetworkState.connected() = _Connected;

  /// Device has no available network interface.
  const factory NetworkState.disconnected() = _Disconnected;
}
