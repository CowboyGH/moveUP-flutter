import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../tests/attempt/domain/repositories/test_attempt_repository.dart';
import '../../../tests/attempt/presentation/cubits/test_attempt_cubit.dart';
import 'fitness_start_test_attempt_page.dart';

/// Builder for the Fitness Start test attempt page.
class FitnessStartTestAttemptPageBuilder extends StatelessWidget {
  /// Testing identifier to be started on page open.
  final int testingId;

  /// Creates an instance of [FitnessStartTestAttemptPageBuilder].
  const FitnessStartTestAttemptPageBuilder({
    required this.testingId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestAttemptCubit(di<GuestTestAttemptRepository>())..startTest(testingId),
      child: FitnessStartTestAttemptPage(testingId: testingId),
    );
  }
}
