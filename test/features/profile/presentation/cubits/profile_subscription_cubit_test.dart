import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_subscription_cubit.dart';
import 'package:moveup_flutter/features/subscriptions/domain/entities/subscription_catalog_item.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';

import '../../../subscriptions/support/subscriptions_dto_fixtures.dart';
import '../../support/profile_dto_fixtures.dart';
import 'profile_subscription_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProfileRepository>(),
  MockSpec<SubscriptionsRepository>(),
])
void main() {
  late MockProfileRepository profileRepository;
  late MockSubscriptionsRepository subscriptionsRepository;
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
    profileRepository = MockProfileRepository();
    subscriptionsRepository = MockSubscriptionsRepository();
    cubit = ProfileSubscriptionCubit(profileRepository, subscriptionsRepository);
    provideDummy<Result<ProfileActiveSubscriptionSnapshot?, ProfileFailure>>(
      const Success(activeSubscription),
    );
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
      'load emits empty state when backend reports no active subscription',
      setUp: () => when(profileRepository.getActiveSubscription()).thenAnswer(
        (_) async => const Success(null),
      ),
      build: () => cubit,
      seed: () => ProfileSubscriptionState(
        activeSubscription: activeSubscription,
        item: item,
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        ProfileSubscriptionState(
          isLoading: true,
          activeSubscription: activeSubscription,
          item: item,
        ),
        const ProfileSubscriptionState(),
      ],
      verify: (_) {
        verify(profileRepository.getActiveSubscription()).called(1);
        verifyNever(subscriptionsRepository.getSubscriptions());
      },
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'load resolves catalog item when active subscription is present',
      setUp: () {
        when(profileRepository.getActiveSubscription()).thenAnswer(
          (_) async => const Success(activeSubscription),
        );
        when(subscriptionsRepository.getSubscriptions()).thenAnswer(
          (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
            createSubscriptionCatalogItems(),
          ),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProfileSubscriptionState(isLoading: true),
        ProfileSubscriptionState(
          activeSubscription: activeSubscription,
          item: item,
        ),
      ],
      verify: (_) {
        verify(profileRepository.getActiveSubscription()).called(1);
        verify(subscriptionsRepository.getSubscriptions()).called(1);
      },
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'load stores profile failure when active subscription request fails',
      setUp: () => when(profileRepository.getActiveSubscription()).thenAnswer(
        (_) async => const Failure(ProfileRequestFailure('error_message')),
      ),
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => const [
        ProfileSubscriptionState(isLoading: true),
        ProfileSubscriptionState(failure: ProfileRequestFailure('error_message')),
      ],
      verify: (_) {
        verify(profileRepository.getActiveSubscription()).called(1);
        verifyNever(subscriptionsRepository.getSubscriptions());
      },
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'load emits failed retry state when catalog request fails',
      setUp: () {
        when(profileRepository.getActiveSubscription()).thenAnswer(
          (_) async => const Success(activeSubscription),
        );
        when(subscriptionsRepository.getSubscriptions()).thenAnswer(
          (_) async => const Failure<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
            SubscriptionsRequestFailure('error_message'),
          ),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => const [
        ProfileSubscriptionState(isLoading: true),
        ProfileSubscriptionState(
          activeSubscription: activeSubscription,
          failure: SubscriptionsRequestFailure('error_message'),
        ),
      ],
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'load matches active subscription to catalog item by name and price instead of id',
      setUp: () {
        when(profileRepository.getActiveSubscription()).thenAnswer(
          (_) async => const Success(
            ProfileActiveSubscriptionSnapshot(
              id: 90,
              name: '3 месяца',
              price: '1400.00',
              startDate: testProfileSubscriptionStartDate,
              endDate: testProfileSubscriptionEndDate,
            ),
          ),
        );
        when(subscriptionsRepository.getSubscriptions()).thenAnswer(
          (_) async => Success<List<SubscriptionCatalogItem>, SubscriptionsFailure>(
            createSubscriptionCatalogItems(),
          ),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProfileSubscriptionState(isLoading: true),
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
    );

    blocTest<ProfileSubscriptionCubit, ProfileSubscriptionState>(
      'load ignores repeated calls while request is in progress',
      setUp: () {
        when(profileRepository.getActiveSubscription()).thenAnswer(
          (_) async => const Success(null),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.load();
        cubit.load();
      },
      expect: () => const [
        ProfileSubscriptionState(isLoading: true),
        ProfileSubscriptionState(),
      ],
      verify: (_) => verify(profileRepository.getActiveSubscription()).called(1),
    );
  });
}
