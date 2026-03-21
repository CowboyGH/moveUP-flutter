part of 'tests_catalog_cubit.dart';

/// States for [TestsCatalogCubit].
@freezed
class TestsCatalogState with _$TestsCatalogState {
  /// Initial idle state before catalog loading.
  const factory TestsCatalogState.initial() = _Initial;

  /// State emitted while tests catalog request is in progress.
  const factory TestsCatalogState.inProgress() = _InProgress;

  /// State emitted when tests catalog loads successfully.
  const factory TestsCatalogState.loaded(List<TestingCatalogItem> items) = _Loaded;

  /// State emitted when tests catalog loading fails.
  const factory TestsCatalogState.failed(TestsFailure failure) = _Failed;
}
