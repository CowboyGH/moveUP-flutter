import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_catalog_item.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:moveup_flutter/features/subscriptions/presentation/cubits/subscription_details_cubit.dart';

import '../../support/subscriptions_dto_fixtures.dart';
import 'subscription_details_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionsRepository>()])
void main() {
  late MockSubscriptionsRepository repository;
  late SubscriptionDetailsCubit cubit;

  final item = createSubscriptionCatalogItems().last;

  setUp(() {
    repository = MockSubscriptionsRepository();
    cubit = SubscriptionDetailsCubit(repository);
    provideDummy<Result<SubscriptionCatalogItem, SubscriptionsFailure>>(
      Success<SubscriptionCatalogItem, SubscriptionsFailure>(item),
    );
  });

  group('SubscriptionDetailsCubit', () {
    blocTest<SubscriptionDetailsCubit, SubscriptionDetailsState>(
      'uses seedItem without repository call',
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(item.id, seedItem: item),
      expect: () => [
        SubscriptionDetailsState.loaded(item),
      ],
      verify: (_) => verifyNever(repository.getSubscriptionById(any)),
    );

    blocTest<SubscriptionDetailsCubit, SubscriptionDetailsState>(
      'loads by id when seedItem is absent',
      setUp: () => when(repository.getSubscriptionById(item.id)).thenAnswer(
        (_) async => Success<SubscriptionCatalogItem, SubscriptionsFailure>(item),
      ),
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(item.id),
      expect: () => [
        const SubscriptionDetailsState.inProgress(),
        SubscriptionDetailsState.loaded(item),
      ],
      verify: (_) => verify(repository.getSubscriptionById(item.id)).called(1),
    );

    blocTest<SubscriptionDetailsCubit, SubscriptionDetailsState>(
      'emits failed when subscription is missing',
      setUp: () => when(repository.getSubscriptionById(999)).thenAnswer(
        (_) async => const Failure<SubscriptionCatalogItem, SubscriptionsFailure>(
          SubscriptionsNotFoundFailure(),
        ),
      ),
      build: () => cubit,
      act: (cubit) => cubit.loadInitial(999),
      expect: () => const [
        SubscriptionDetailsState.inProgress(),
        SubscriptionDetailsState.failed(SubscriptionsNotFoundFailure()),
      ],
      verify: (_) => verify(repository.getSubscriptionById(999)).called(1),
    );
  });
}
