import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/fitness_start_repository.dart';
import '../cubits/fitness_start_cubit.dart';
import 'fitness_start_quiz_page.dart';

/// Builder for the Fitness Start quiz page.
class FitnessStartQuizPageBuilder extends StatelessWidget {
  /// Creates an instance of [FitnessStartQuizPageBuilder].
  const FitnessStartQuizPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FitnessStartCubit(di<FitnessStartRepository>())..loadReferences(),
      child: const FitnessStartQuizPage(),
    );
  }
}
