import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/tests/tests_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/tests/catalog/domain/entities/testing_catalog_item.dart';
import 'package:moveup_flutter/features/tests/catalog/domain/entities/testing_category.dart';
import 'package:moveup_flutter/features/tests/catalog/domain/repositories/tests_catalog_repository.dart';
import 'package:moveup_flutter/features/tests/catalog/presentation/cubits/tests_catalog_cubit.dart';

import 'tests_catalog_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TestsCatalogRepository>()])
void main() {
  late MockTestsCatalogRepository repository;
  late TestsCatalogCubit testsCatalogCubit;

  const items = [
    TestingCatalogItem(
      id: 1,
      title: 'title',
      description: 'description',
      durationMinutes: 1,
      imageUrl: 'test.jpg',
      categories: [
        TestingCategory(id: 1, name: 'test'),
        TestingCategory(id: 2, name: 'test'),
      ],
      exercisesCount: 4,
    ),
  ];

  setUp(() {
    repository = MockTestsCatalogRepository();
    testsCatalogCubit = TestsCatalogCubit(repository);
    provideDummy<Result<List<TestingCatalogItem>, TestsFailure>>(
      const Success<List<TestingCatalogItem>, TestsFailure>(items),
    );
  });

  group('TestsCatalogCubit', () {
    const testsFailure = TestsRequestFailure('error_message');

    blocTest<TestsCatalogCubit, TestsCatalogState>(
      'emits inProgress only once when loadTestings is called twice',
      setUp: () => when(repository.getTestings()).thenAnswer(
        (_) async => const Success<List<TestingCatalogItem>, TestsFailure>(items),
      ),
      build: () => testsCatalogCubit,
      act: (cubit) {
        cubit.loadTestings();
        cubit.loadTestings();
      },
      expect: () => const [
        TestsCatalogState.inProgress(),
        TestsCatalogState.loaded(items),
      ],
      verify: (_) => verify(repository.getTestings()).called(1),
    );

    blocTest<TestsCatalogCubit, TestsCatalogState>(
      'emits loaded(items) when load-testings is succeed',
      setUp: () => when(repository.getTestings()).thenAnswer(
        (_) async => const Success<List<TestingCatalogItem>, TestsFailure>(items),
      ),
      build: () => testsCatalogCubit,
      act: (cubit) => cubit.loadTestings(),
      expect: () => const [
        TestsCatalogState.inProgress(),
        TestsCatalogState.loaded(items),
      ],
      verify: (_) => verify(repository.getTestings()).called(1),
    );

    blocTest<TestsCatalogCubit, TestsCatalogState>(
      'emits failed(testsFailure) when load-testings is failed',
      setUp: () => when(repository.getTestings()).thenAnswer(
        (_) async => const Failure<List<TestingCatalogItem>, TestsFailure>(testsFailure),
      ),
      build: () => testsCatalogCubit,
      act: (cubit) => cubit.loadTestings(),
      expect: () => const [
        TestsCatalogState.inProgress(),
        TestsCatalogState.failed(testsFailure),
      ],
      verify: (_) => verify(repository.getTestings()).called(1),
    );
  });
}
