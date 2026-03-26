import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../tests/catalog/domain/repositories/tests_catalog_repository.dart';
import '../../../tests/catalog/presentation/cubits/tests_catalog_cubit.dart';
import 'fitness_start_tests_page.dart';

/// Builder for the Fitness Start tests page.
class FitnessStartTestsPageBuilder extends StatelessWidget {
  /// Creates an instance of [FitnessStartTestsPageBuilder].
  const FitnessStartTestsPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestsCatalogCubit(di<TestsCatalogRepository>())..loadTestings(),
      child: const FitnessStartTestsPage(),
    );
  }
}
