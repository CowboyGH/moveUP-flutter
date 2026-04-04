import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/cards/cards_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/cards/domain/repositories/cards_repository.dart';
import 'package:moveup_flutter/features/cards/presentation/cubits/save_card_cubit.dart';

import '../../support/cards_dto_fixtures.dart';
import 'save_card_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CardsRepository>()])
void main() {
  late MockCardsRepository repository;
  late SaveCardCubit cubit;

  setUp(() {
    repository = MockCardsRepository();
    cubit = SaveCardCubit(repository);
    provideDummy<Result<void, CardsFailure>>(
      const Success<void, CardsFailure>(null),
    );
  });

  group('SaveCardCubit', () {
    const cardsFailure = CardsRequestFailure('error_message');

    blocTest<SaveCardCubit, SaveCardState>(
      'emits succeed when save succeeds',
      setUp: () => when(
        repository.saveCard(payload: testSaveCardPayload),
      ).thenAnswer((_) async => const Success<void, CardsFailure>(null)),
      build: () => cubit,
      act: (cubit) => cubit.saveCard(payload: testSaveCardPayload),
      expect: () => const [
        SaveCardState.inProgress(),
        SaveCardState.succeed(),
      ],
      verify: (_) => verify(repository.saveCard(payload: testSaveCardPayload)).called(1),
    );

    blocTest<SaveCardCubit, SaveCardState>(
      'emits failed when save fails',
      setUp: () => when(
        repository.saveCard(payload: testSaveCardPayload),
      ).thenAnswer((_) async => const Failure<void, CardsFailure>(cardsFailure)),
      build: () => cubit,
      act: (cubit) => cubit.saveCard(payload: testSaveCardPayload),
      expect: () => const [
        SaveCardState.inProgress(),
        SaveCardState.failed(cardsFailure),
      ],
      verify: (_) => verify(repository.saveCard(payload: testSaveCardPayload)).called(1),
    );

    blocTest<SaveCardCubit, SaveCardState>(
      'emits inProgress only once when saveCard is called twice',
      setUp: () => when(
        repository.saveCard(payload: testSaveCardPayload),
      ).thenAnswer((_) async => const Success<void, CardsFailure>(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.saveCard(payload: testSaveCardPayload);
        cubit.saveCard(payload: testSaveCardPayload);
      },
      expect: () => const [
        SaveCardState.inProgress(),
        SaveCardState.succeed(),
      ],
      verify: (_) => verify(repository.saveCard(payload: testSaveCardPayload)).called(1),
    );
  });
}
