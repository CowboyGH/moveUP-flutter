import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/testing_catalog_item.dart';
import '../../domain/repositories/tests_catalog_repository.dart';

part 'tests_catalog_cubit.freezed.dart';
part 'tests_catalog_state.dart';

/// Cubit that manages tests catalog loading flow and emits [TestsCatalogState].
final class TestsCatalogCubit extends Cubit<TestsCatalogState> {
  /// Repository used for tests catalog requests.
  final TestsCatalogRepository _repository;

  /// Creates an instance of [TestsCatalogCubit].
  TestsCatalogCubit(this._repository) : super(const TestsCatalogState.initial());

  /// Loads all available testings for the catalog.
  Future<void> loadTestings() async {
    final isInProgress = state.maybeWhen(
      inProgress: () => true,
      orElse: () => false,
    );
    if (isInProgress) return;

    emit(const TestsCatalogState.inProgress());

    final result = await _repository.getTestings();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(TestsCatalogState.loaded(data));
      case Failure(:final error):
        emit(TestsCatalogState.failed(error));
    }
  }
}
