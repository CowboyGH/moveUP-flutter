import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/cards/cards_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/cards/domain/repositories/cards_repository.dart';
import 'package:moveup_flutter/features/cards/presentation/cubits/set_default_card_cubit.dart';

import 'set_default_card_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CardsRepository>()])
void main() {
  late MockCardsRepository repository;
  late SetDefaultCardCubit cubit;

  setUp(() {
    repository = MockCardsRepository();
    cubit = SetDefaultCardCubit(repository);
    provideDummy<Result<void, CardsFailure>>(
      const Success<void, CardsFailure>(null),
    );
  });

  group('SetDefaultCardCubit', () {
    const cardsFailure = CardsRequestFailure('error_message');

    blocTest<SetDefaultCardCubit, SetDefaultCardState>(
      'emits succeed when setDefault succeeds',
      setUp: () => when(repository.setDefaultCard(2)).thenAnswer(
        (_) async => const Success<void, CardsFailure>(null),
      ),
      build: () => cubit,
      act: (cubit) => cubit.setDefaultCard(2),
      expect: () => const [
        SetDefaultCardState.inProgress(2),
        SetDefaultCardState.succeed(),
      ],
      verify: (_) => verify(repository.setDefaultCard(2)).called(1),
    );

    blocTest<SetDefaultCardCubit, SetDefaultCardState>(
      'emits failed when setDefault fails',
      setUp: () => when(
        repository.setDefaultCard(2),
      ).thenAnswer((_) async => const Failure<void, CardsFailure>(cardsFailure)),
      build: () => cubit,
      act: (cubit) => cubit.setDefaultCard(2),
      expect: () => const [
        SetDefaultCardState.inProgress(2),
        SetDefaultCardState.failed(cardsFailure),
      ],
      verify: (_) => verify(repository.setDefaultCard(2)).called(1),
    );

    blocTest<SetDefaultCardCubit, SetDefaultCardState>(
      'emits inProgress only once when setDefaultCard is called twice',
      setUp: () => when(repository.setDefaultCard(2)).thenAnswer(
        (_) async => const Success<void, CardsFailure>(null),
      ),
      build: () => cubit,
      act: (cubit) {
        cubit.setDefaultCard(2);
        cubit.setDefaultCard(2);
      },
      expect: () => const [
        SetDefaultCardState.inProgress(2),
        SetDefaultCardState.succeed(),
      ],
      verify: (_) => verify(repository.setDefaultCard(2)).called(1),
    );
  });
}
