import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_subscription_cubit.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_catalog_item.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';

import '../../../subscriptions/support/subscriptions_dto_fixtures.dart';
import '../../support/profile_dto_fixtures.dart';
import 'profile_subscription_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionsRepository>()])
void main() {
  late MockSubscriptionsRepository repository;
  late ProfileSubscriptionCubit cubit;

  const activeSubscription = ProfileActiveSubscriptionSnapshot(
    id: testProfileSubscriptionId,
    name: testProfileSubscriptionName,
    price: testProfileSubscriptionPrice,
    startDate: testProfileSubscriptionStartDate,
    endDate: testProfileSubscriptionEndDate,
  );
  final item = createSubscriptionCatalogItems().last;

  setUp(() {
    repository = MockSubscriptionsRepository();
    cubit = ProfileSubscriptionCubit(repository);
    provideDummy<Result<SubscriptionCatalogItem, SubscriptionsFailure>>(
      Success<SubscriptionCatalogItem, SubscriptionsFailure>(item),
    );
    provideDummy<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>>(
      Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
        createSubscriptionCatalogItems(),
      ),
    );
  });

  group('ProfileSubscriptionCubit', () {
    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'emits empty state when active subscription is absent',
      build: () => cubit,
      seed: () => ProfileSubscriptionState(
        activeSubscription: activeSubscription,
        item: item,
        failure: const SubscriptionsRequestFailure('test'),
      ),
      act: (cubit) => cubit.syncActiveSubscription(null),
      expect: () => const [
        ProfileSubscriptionState(),
      ],
      verify: (_) => verifyNever(repository.getSubscriptions()),
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'loads details when active subscription appears',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
          createSubscriptionCatalogItems(),
        ),
      ),
      build: () => cubit,
      act: (cubit) => cubit.syncActiveSubscription(activeSubscription),
      expect: () => [
        const ProfileSubscriptionState(
          isLoading: true,
          activeSubscription: activeSubscription,
        ),
        ProfileSubscriptionState(
          activeSubscription: activeSubscription,
          item: item,
        ),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'ignores duplicate sync with same subscriptionId',
      build: () => cubit,
      seed: () => ProfileSubscriptionState(
        activeSubscription: activeSubscription,
        item: item,
      ),
      act: (cubit) => cubit.syncActiveSubscription(activeSubscription),
      expect: () => const <ProfileSubscriptionState>[],
      verify: (_) => verifyNever(repository.getSubscriptions()),
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'emits failed retry state when details request fails',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => const Failure<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
          SubscriptionsRequestFailure('error_message'),
        ),
      ),
      build: () => cubit,
      act: (cubit) => cubit.syncActiveSubscription(activeSubscription),
      expect: () => const [
        ProfileSubscriptionState(
          isLoading: true,
          activeSubscription: activeSubscription,
        ),
        ProfileSubscriptionState(
          activeSubscription: activeSubscription,
          failure: SubscriptionsRequestFailure('error_message'),
        ),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'matches active subscription to catalog item by name and price instead of active id',
      setUp: () => when(repository.getSubscriptions()).thenAnswer(
        (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
          createSubscriptionCatalogItems(),
        ),
      ),
      build: () => cubit,
      act: (cubit) => cubit.syncActiveSubscription(
        const ProfileActiveSubscriptionSnapshot(
          id: 90,
          name: '3 месяца',
          price: '1400.00',
          startDate: testProfileSubscriptionStartDate,
          endDate: testProfileSubscriptionEndDate,
        ),
      ),
      expect: () => [
        const ProfileSubscriptionState(
          isLoading: true,
          activeSubscription: ProfileActiveSubscriptionSnapshot(
            id: 90,
            name: '3 месяца',
            price: '1400.00',
            startDate: testProfileSubscriptionStartDate,
            endDate: testProfileSubscriptionEndDate,
          ),
        ),
        ProfileSubscriptionState(
          activeSubscription: const ProfileActiveSubscriptionSnapshot(
            id: 90,
            name: '3 месяца',
            price: '1400.00',
            startDate: testProfileSubscriptionStartDate,
            endDate: testProfileSubscriptionEndDate,
          ),
          item: item,
        ),
      ],
      verify: (_) => verify(repository.getSubscriptions()).called(1),
    );
  });
}
