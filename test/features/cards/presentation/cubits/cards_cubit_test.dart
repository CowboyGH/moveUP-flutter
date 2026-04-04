import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/cards/cards_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/cards/domain/entities/saved_card.dart';
import 'package:moveup_flutter/features/cards/domain/repositories/cards_repository.dart';
import 'package:moveup_flutter/features/cards/presentation/cubits/cards_cubit.dart';

import '../../support/cards_dto_fixtures.dart';
import 'cards_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CardsRepository>()])
void main() {
  late MockCardsRepository repository;
  late CardsCubit cubit;

  setUp(() {
    repository = MockCardsRepository();
    cubit = CardsCubit(repository);
    provideDummy<Result<List<SavedCard>, CardsFailure>>(
      Success<List<SavedCard>, CardsFailure>(createSavedCards()),
    );
  });

  group('CardsCubit', () {
    blocTest<CardsCubit, CardsState>(
      'loads cards when request succeeds',
      setUp: () => when(repository.getCards()).thenAnswer(
        (_) async => Success<List<SavedCard>, CardsFailure>(createSavedCards()),
      ),
      build: () => cubit,
      act: (cubit) => cubit.loadCards(),
      expect: () => [
        const CardsState(isLoading: true),
        CardsState(cards: createSavedCards()),
      ],
      verify: (_) => verify(repository.getCards()).called(1),
    );

    blocTest<CardsCubit, CardsState>(
      'emits failed state when request fails',
      setUp: () => when(repository.getCards()).thenAnswer(
        (_) async => const Failure<List<SavedCard>, CardsFailure>(
          CardsRequestFailure('error_message'),
        ),
      ),
      build: () => cubit,
      act: (cubit) => cubit.loadCards(),
      expect: () => const [
        CardsState(isLoading: true),
        CardsState(failure: CardsRequestFailure('error_message')),
      ],
      verify: (_) => verify(repository.getCards()).called(1),
    );

    blocTest<CardsCubit, CardsState>(
      'emits loading only once when loadCards is called twice',
      setUp: () => when(repository.getCards()).thenAnswer(
        (_) async => Success<List<SavedCard>, CardsFailure>(createSavedCards()),
      ),
      build: () => cubit,
      act: (cubit) {
        cubit.loadCards();
        cubit.loadCards();
      },
      expect: () => [
        const CardsState(isLoading: true),
        CardsState(cards: createSavedCards()),
      ],
      verify: (_) => verify(repository.getCards()).called(1),
    );

    blocTest<CardsCubit, CardsState>(
      'keeps previous cards while refresh is in progress',
      setUp: () => when(repository.getCards()).thenAnswer(
        (_) async => Success<List<SavedCard>, CardsFailure>(createSavedCards()),
      ),
      build: () => cubit,
      seed: () => CardsState(cards: createSavedCards()),
      act: (cubit) => cubit.loadCards(),
      expect: () => [
        CardsState(
          isLoading: true,
          cards: createSavedCards(),
        ),
        CardsState(cards: createSavedCards()),
      ],
      verify: (_) => verify(repository.getCards()).called(1),
    );
  });
}
