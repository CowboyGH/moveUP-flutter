import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_starter_template/core/services/network/network_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
void main() {
  late Connectivity connectivity;

  setUp(() {
    connectivity = MockConnectivity();

    when(
      connectivity.onConnectivityChanged,
    ).thenAnswer((_) => const Stream<List<ConnectivityResult>>.empty());
  });

  group('NetworkServiceImpl', () {
    test('init sets isConnected=true when network is available (wifi)', () async {
      // Arrange
      when(
        connectivity.checkConnectivity(),
      ).thenAnswer((_) async => <ConnectivityResult>[ConnectivityResult.wifi]);

      final service = NetworkServiceImpl(connectivity);
      addTearDown(() async => await service.dispose());

      // Act
      await service.init();

      // Assert
      expect(service.isConnected, isTrue);
      verify(connectivity.checkConnectivity()).called(1);
    });

    test('init sets isConnected=false when no network is available (none)', () async {
      // Arrange
      when(
        connectivity.checkConnectivity(),
      ).thenAnswer((_) async => <ConnectivityResult>[ConnectivityResult.none]);

      final service = NetworkServiceImpl(connectivity);
      addTearDown(() async => await service.dispose());

      // Act
      await service.init();

      // Assert
      expect(service.isConnected, isFalse);
      verify(connectivity.checkConnectivity()).called(1);
    });

    test(
      'connectionStream emits true when connectivity changes to wifi',
      () async {
        // Arrange
        final controller = StreamController<List<ConnectivityResult>>();
        addTearDown(() async => await controller.close());

        when(connectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);

        final service = NetworkServiceImpl(connectivity);
        addTearDown(() async => await service.dispose());

        final events = <bool>[];
        final sub = service.connectionStream.listen(events.add);
        addTearDown(() async => await sub.cancel());

        // Act
        controller.add(<ConnectivityResult>[ConnectivityResult.wifi]);
        await pumpEventQueue();

        // Assert
        expect(events, <bool>[true]);
      },
    );

    test(
      'connectionStream emits values in order for multiple connectivity changes',
      () async {
        // Arrange
        final controller = StreamController<List<ConnectivityResult>>();

        addTearDown(() async => await controller.close());
        when(connectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);

        final service = NetworkServiceImpl(connectivity);
        addTearDown(() async => await service.dispose());

        final events = <bool>[];
        final sub = service.connectionStream.listen(events.add);
        addTearDown(() async => await sub.cancel());

        // Act
        controller.add(<ConnectivityResult>[ConnectivityResult.none]);
        await pumpEventQueue();

        controller.add(<ConnectivityResult>[ConnectivityResult.wifi]);
        await pumpEventQueue();

        controller.add(<ConnectivityResult>[ConnectivityResult.none]);
        await pumpEventQueue();

        // Assert
        expect(events, <bool>[false, true, false]);
      },
    );

    test('connectionStream does not emit duplicates when state does not change', () async {
      // Arrange
      final controller = StreamController<List<ConnectivityResult>>();
      addTearDown(() async => await controller.close());

      when(connectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);

      final service = NetworkServiceImpl(connectivity);
      addTearDown(() async => await service.dispose());

      final events = <bool>[];
      final sub = service.connectionStream.listen(events.add);
      addTearDown(() async => await sub.cancel());

      // Act
      controller.add(<ConnectivityResult>[ConnectivityResult.wifi]);
      await pumpEventQueue();

      controller.add(<ConnectivityResult>[ConnectivityResult.mobile]);
      await pumpEventQueue();

      controller.add(<ConnectivityResult>[ConnectivityResult.wifi]);
      await pumpEventQueue();

      // Assert
      expect(events, <bool>[true]);
    });

    test('dispose cancels subscription and stops emitting further updates', () async {
      // Arrange
      final controller = StreamController<List<ConnectivityResult>>();
      addTearDown(() async => await controller.close());

      when(connectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);

      final service = NetworkServiceImpl(connectivity);

      final events = <bool>[];
      final subscription = service.connectionStream.listen(events.add);
      addTearDown(() async => await subscription.cancel());

      // Act
      await service.dispose();

      controller.add(<ConnectivityResult>[ConnectivityResult.wifi]);
      await pumpEventQueue();

      // Assert
      expect(events, isEmpty);
    });
  });
}
