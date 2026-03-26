import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/result/result.dart';
import '../entities/testing_catalog_item.dart';

/// Repository interface for tests catalog operations.
abstract interface class TestsCatalogRepository {
  /// Returns all active testings available for catalog display.
  Future<Result<List<TestingCatalogItem>, TestsFailure>> getTestings();
}
