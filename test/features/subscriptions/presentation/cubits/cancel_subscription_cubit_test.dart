import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:moveup_flutter/features/subscriptions/presentation/cubits/cancel_subscription_cubit.dart';

import 'cancel_subscription_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionsRepository>()])
void main() {
  late MockSubscriptionsRepository repository;
  late CancelSubscriptionCubit cubit;

  const failure = SubscriptionsRequestFailure('test');

  setUp(() {
    repository = MockSubscriptionsRepository();
    cubit = CancelSubscriptionCubit(repository);
    provideDummy<Result<void, SubscriptionsFailure>>(const Success(null));
  });

  group('CancelSubscriptionCubit', () {
    blocTest<CancelSubscriptionCubit, CancelSubscriptionState>(
      'emits inProgress and succeed when cancel succeeds',
      setUp: () =>
          when(repository.cancelSubscription()).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) => cubit.cancelSubscription(),
      expect: () => const [
        CancelSubscriptionState.inProgress(),
        CancelSubscriptionState.succeed(),
      ],
      verify: (_) => verify(repository.cancelSubscription()).called(1),
    );

    blocTest<CancelSubscriptionCubit, CancelSubscriptionState>(
      'emits failed(failure) when cancel fails',
      setUp: () => when(
        repository.cancelSubscription(),
      ).thenAnswer((_) async => const Failure(failure)),
      build: () => cubit,
      act: (cubit) => cubit.cancelSubscription(),
      expect: () => const [
        CancelSubscriptionState.inProgress(),
        CancelSubscriptionState.failed(failure),
      ],
      verify: (_) => verify(repository.cancelSubscription()).called(1),
    );

    blocTest<CancelSubscriptionCubit, CancelSubscriptionState>(
      'emits inProgress only once when cancelSubscription is called twice',
      setUp: () =>
          when(repository.cancelSubscription()).thenAnswer((_) async => const Success(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.cancelSubscription();
        cubit.cancelSubscription();
      },
      expect: () => const [
        CancelSubscriptionState.inProgress(),
        CancelSubscriptionState.succeed(),
      ],
      verify: (_) => verify(repository.cancelSubscription()).called(1),
    );
  });
}
