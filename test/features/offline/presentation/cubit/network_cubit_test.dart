import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/services/network/network_service.dart';
import 'package:moveup_flutter/features/offline/presentation/cubit/network_cubit.dart';

import 'network_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkService>()])
void main() {
  late MockNetworkService networkService;
  late NetworkCubit networkCubit;
  late StreamController<bool> controller;

  setUp(() {
    networkService = MockNetworkService();
    controller = StreamController<bool>.broadcast();

    when(networkService.connectionStream).thenAnswer((_) => controller.stream);
    networkCubit = NetworkCubit(networkService);
  });

  tearDown(() async {
    if (!networkCubit.isClosed) await networkCubit.close();
    await controller.close();
  });

  group('NetworkCubit', () {
    blocTest<NetworkCubit, NetworkState>(
      'initialize emits connected when hasNetwork returns true',
      setUp: () => when(
        networkService.hasNetwork(),
      ).thenAnswer((_) async => true),
      build: () => networkCubit,
      act: (cubit) => cubit.init(),
      expect: () => const [
        NetworkState.connected(),
      ],
      verify: (_) {
        verify(networkService.connectionStream).called(1);
        verify(networkService.hasNetwork()).called(1);
      },
    );

    blocTest<NetworkCubit, NetworkState>(
      'initialize emits disconnected when hasNetwork returns false',
      setUp: () => when(
        networkService.hasNetwork(),
      ).thenAnswer((_) async => false),
      build: () => networkCubit,
      act: (cubit) => cubit.init(),
      expect: () => const [
        NetworkState.disconnected(),
      ],
      verify: (_) {
        verify(networkService.connectionStream).called(1);
        verify(networkService.hasNetwork()).called(1);
      },
    );

    blocTest<NetworkCubit, NetworkState>(
      'connectionStream emits states in order after initialization',
      setUp: () => when(
        networkService.hasNetwork(),
      ).thenAnswer((_) async => false),
      build: () => networkCubit,
      act: (cubit) async {
        await cubit.init();
        controller.add(true);
        await pumpEventQueue();
        controller.add(false);
        await pumpEventQueue();
      },
      expect: () => const [
        NetworkState.disconnected(),
        NetworkState.connected(),
        NetworkState.disconnected(),
      ],
    );

    blocTest<NetworkCubit, NetworkState>(
      'connectionStream does not emit duplicate states for identical values',
      setUp: () {
        when(networkService.hasNetwork()).thenAnswer((_) async => true);
      },
      build: () => networkCubit,
      act: (cubit) async {
        await cubit.init();
        controller.add(true);
        await pumpEventQueue();
        controller.add(true);
        await pumpEventQueue();
        controller.add(false);
        await pumpEventQueue();
        controller.add(false);
        await pumpEventQueue();
      },
      expect: () => const [
        NetworkState.connected(),
        NetworkState.disconnected(),
      ],
    );

    test('initialize does not create duplicate subscriptions', () async {
      var listenCount = 0;
      final countingController = StreamController<bool>.broadcast(
        onListen: () => listenCount++,
      );
      when(networkService.connectionStream).thenAnswer((_) => countingController.stream);
      when(networkService.hasNetwork()).thenAnswer((_) async => true);

      await networkCubit.init();
      await networkCubit.init();

      verify(networkService.hasNetwork()).called(1);
      expect(listenCount, 1);

      await countingController.close();
    });

    test('initialize cleans up the subscription when hasNetwork throws', () async {
      var listenCount = 0;
      final countingController = StreamController<bool>.broadcast(
        onListen: () => listenCount++,
      );
      when(networkService.connectionStream).thenAnswer((_) => countingController.stream);
      when(networkService.hasNetwork()).thenThrow(Exception(''));

      await expectLater(networkCubit.init(), throwsException);
      await expectLater(networkCubit.init(), throwsException);

      expect(listenCount, 2);

      await countingController.close();
    });

    test('close stops reacting to further connectivity changes', () async {
      // Arrange
      when(networkService.hasNetwork()).thenAnswer((_) async => false);

      final emittedStates = <NetworkState>[];
      final subscription = networkCubit.stream.listen(emittedStates.add);
      addTearDown(subscription.cancel);

      // Act
      await networkCubit.init();
      await pumpEventQueue();
      emittedStates.clear();

      await networkCubit.close();

      controller.add(true);
      await pumpEventQueue();

      // Assert
      expect(emittedStates, isEmpty);
    });
  });
}
