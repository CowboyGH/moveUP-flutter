import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/cards/cards_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/cards/domain/repositories/cards_repository.dart';
import 'package:moveup_flutter/features/cards/presentation/cubits/delete_card_cubit.dart';

import 'delete_card_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CardsRepository>()])
void main() {
  late MockCardsRepository repository;
  late DeleteCardCubit cubit;

  setUp(() {
    repository = MockCardsRepository();
    cubit = DeleteCardCubit(repository);
    provideDummy<Result<void, CardsFailure>>(
      const Success<void, CardsFailure>(null),
    );
  });

  group('DeleteCardCubit', () {
    const cardsFailure = CardsRequestFailure('error_message');

    blocTest<DeleteCardCubit, DeleteCardState>(
      'emits succeed when delete succeeds',
      setUp: () => when(
        repository.deleteCard(2),
      ).thenAnswer((_) async => const Success<void, CardsFailure>(null)),
      build: () => cubit,
      act: (cubit) => cubit.deleteCard(2),
      expect: () => const [
        DeleteCardState.inProgress(2),
        DeleteCardState.succeed(),
      ],
      verify: (_) => verify(repository.deleteCard(2)).called(1),
    );

    blocTest<DeleteCardCubit, DeleteCardState>(
      'emits failed when delete fails',
      setUp: () => when(
        repository.deleteCard(2),
      ).thenAnswer((_) async => const Failure<void, CardsFailure>(cardsFailure)),
      build: () => cubit,
      act: (cubit) => cubit.deleteCard(2),
      expect: () => const [
        DeleteCardState.inProgress(2),
        DeleteCardState.failed(cardsFailure),
      ],
      verify: (_) => verify(repository.deleteCard(2)).called(1),
    );

    blocTest<DeleteCardCubit, DeleteCardState>(
      'emits inProgress only once when deleteCard is called twice',
      setUp: () => when(
        repository.deleteCard(2),
      ).thenAnswer((_) async => const Success<void, CardsFailure>(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.deleteCard(2);
        cubit.deleteCard(2);
      },
      expect: () => const [
        DeleteCardState.inProgress(2),
        DeleteCardState.succeed(),
      ],
      verify: (_) => verify(repository.deleteCard(2)).called(1),
    );
  });
}
