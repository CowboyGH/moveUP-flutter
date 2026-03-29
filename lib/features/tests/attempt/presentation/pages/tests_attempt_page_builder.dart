import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/di.dart';
import '../../domain/repositories/test_attempt_repository.dart';
import '../cubits/test_attempt_cubit.dart';
import 'tests_attempt_page.dart';

/// Builder for the authenticated tests attempt page.
class TestsAttemptPageBuilder extends StatelessWidget {
  /// Testing identifier to be started on page open.
  final int testingId;

  /// Creates an instance of [TestsAttemptPageBuilder].
  const TestsAttemptPageBuilder({
    required this.testingId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TestAttemptCubit(di<AuthenticatedTestAttemptRepository>())..startTest(testingId),
      child: TestsAttemptPage(testingId: testingId),
    );
  }
}
