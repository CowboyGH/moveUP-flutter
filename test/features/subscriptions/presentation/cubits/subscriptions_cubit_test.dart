import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_catalog_item.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:moveup_flutter/features/subscriptions/presentation/cubits/subscriptions_cubit.dart';

import '../../support/subscriptions_dto_fixtures.dart';
import 'subscriptions_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionsRepository>()])
void main() {
  late MockSubscriptionsRepository repository;
  late SubscriptionsCubit subscriptionsCubit;

  final items = createSubscriptionCatalogItems();

  setUp(() {
    repository = MockSubscriptionsRepository();
    subscriptionsCubit = SubscriptionsCubit(repository);
    provideDummy<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>>(
      Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(items),
    );
  });

  group('SubscriptionsCubit', () {
    const subscriptionsFailure = SubscriptionsRequestFailure('error_message');

    blocTest<SubscriptionsCubit, SubscriptionsState>(
      'emits inProgress only once when loadSubscriptions is called twice',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(items),
      ),
      build: () => subscriptionsCubit,
      act: (cubit) {
        cubit.loadSubscriptions();
        cubit.loadSubscriptions();
      },
      expect: () => [
        const SubscriptionsState.inProgress(),
        SubscriptionsState.loaded(items),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );

    blocTest<SubscriptionsCubit, SubscriptionsState>(
      'emits loaded(items) when loadSubscriptions succeeds',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(items),
      ),
      build: () => subscriptionsCubit,
      act: (cubit) => cubit.loadSubscriptions(),
      expect: () => [
        const SubscriptionsState.inProgress(),
        SubscriptionsState.loaded(items),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );

    blocTest<SubscriptionsCubit, SubscriptionsState>(
      'emits failed(subscriptionsFailure) when loadSubscriptions fails',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => const Failure<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
          subscriptionsFailure,
        ),
      ),
      build: () => subscriptionsCubit,
      act: (cubit) => cubit.loadSubscriptions(),
      expect: () => const [
        SubscriptionsState.inProgress(),
        SubscriptionsState.failed(subscriptionsFailure),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );
  });
}
