import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/subscriptions/subscriptions_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:moveup_flutter/features/subscriptions/presentation/cubits/subscription_payment_cubit.dart';

import '../../support/subscriptions_dto_fixtures.dart';
import 'subscription_payment_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionsRepository>()])
void main() {
  late MockSubscriptionsRepository repository;
  late SubscriptionPaymentCubit cubit;

  setUp(() {
    repository = MockSubscriptionsRepository();
    cubit = SubscriptionPaymentCubit(repository);
    provideDummy<Result<void, SubscriptionsFailure>>(
      const Success<void, SubscriptionsFailure>(null),
    );
  });

  group('SubscriptionPaymentCubit', () {
    const subscriptionsFailure = SubscriptionsRequestFailure('error_message');

    blocTest<SubscriptionPaymentCubit, SubscriptionPaymentState>(
      'emits succeed when pay succeeds',
      setUp: () => when(
        repository.paySubscription(payload: testSubscriptionPaymentPayload),
      ).thenAnswer((_) async => const Success<void, SubscriptionsFailure>(null)),
      build: () => cubit,
      act: (cubit) => cubit.pay(payload: testSubscriptionPaymentPayload),
      expect: () => const [
        SubscriptionPaymentState.inProgress(),
        SubscriptionPaymentState.succeed(),
      ],
      verify: (_) =>
          verify(repository.paySubscription(payload: testSubscriptionPaymentPayload)).called(1),
    );

    blocTest<SubscriptionPaymentCubit, SubscriptionPaymentState>(
      'emits failed when pay fails',
      setUp: () =>
          when(
            repository.paySubscription(payload: testSubscriptionPaymentPayload),
          ).thenAnswer(
            (_) async => const Failure<void, SubscriptionsFailure>(subscriptionsFailure),
          ),
      build: () => cubit,
      act: (cubit) => cubit.pay(payload: testSubscriptionPaymentPayload),
      expect: () => const [
        SubscriptionPaymentState.inProgress(),
        SubscriptionPaymentState.failed(subscriptionsFailure),
      ],
      verify: (_) =>
          verify(repository.paySubscription(payload: testSubscriptionPaymentPayload)).called(1),
    );

    blocTest<SubscriptionPaymentCubit, SubscriptionPaymentState>(
      'emits inProgress only once when pay is called twice',
      setUp: () => when(
        repository.paySubscription(payload: testSubscriptionPaymentPayload),
      ).thenAnswer((_) async => const Success<void, SubscriptionsFailure>(null)),
      build: () => cubit,
      act: (cubit) {
        cubit.pay(payload: testSubscriptionPaymentPayload);
        cubit.pay(payload: testSubscriptionPaymentPayload);
      },
      expect: () => const [
        SubscriptionPaymentState.inProgress(),
        SubscriptionPaymentState.succeed(),
      ],
      verify: (_) =>
          verify(repository.paySubscription(payload: testSubscriptionPaymentPayload)).called(1),
    );
  });
}
