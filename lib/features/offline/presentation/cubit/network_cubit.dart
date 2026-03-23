import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/services/network/network_service.dart';

part 'network_cubit.freezed.dart';
part 'network_state.dart';

/// Global cubit that tracks app-level connectivity state for navigation.
final class NetworkCubit extends Cubit<NetworkState> {
  final NetworkService _networkService;
  StreamSubscription<bool>? _subscription;

  /// Creates an instance of [NetworkCubit].
  NetworkCubit(this._networkService) : super(const NetworkState.initial());

  /// Starts connectivity monitoring and emits the initial resolved state.
  ///
  /// Does nothing when the cubit is already initialized or closed.
  Future<void> init() async {
    if (isClosed || _subscription != null) return;

    _subscription = _networkService.connectionStream.listen(_onConnectionChanged);

    final hasNetwork = await _networkService.hasNetwork();
    _onConnectionChanged(hasNetwork);
  }

  void _onConnectionChanged(bool hasNetwork) {
    if (isClosed) return;

    final nextState = hasNetwork
        ? const NetworkState.connected()
        : const NetworkState.disconnected();

    if (state == nextState) return;
    emit(nextState);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
