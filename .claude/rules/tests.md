---
paths:
  - "test/**/*.dart"
---

# Test rules

## Layout
- `test/` mirrors `lib/` 1:1 (e.g. `lib/features/auth/presentation/cubits/sign_in_cubit.dart` → `test/features/auth/presentation/cubits/sign_in_cubit_test.dart`).
- Shared fixtures per feature in `test/features/<feature>/support/<feature>_dto_fixtures.dart`.
- One test file per production file, suffix `_test.dart`.

## Frameworks
- `flutter_test` for widget tests.
- `mockito` 5 for mocks (this repo does **not** use `mocktail`). Declare via `@GenerateMocks([Foo, Bar])` at the top of the test file; mocks land in the sibling `<name>_test.mocks.dart`. Regenerate with `dart run build_runner build --delete-conflicting-outputs`.
- `bloc_test` 10 for cubits — use `blocTest<Cubit, State>(...)` with `build`, `act`, `expect`.
- `fake_async` for time-sensitive code instead of real delays.

## What to cover
- Every cubit: happy path + each `Failure` branch from the repository.
- Every repository: success + each `Failure` mapping from `DioException` / parsing errors.
- Every mapper: DTO ↔ domain round-trip.
- Validators (`presentation/validators/`): valid + each invalid branch.
- Network interceptors / mappers: see existing tests under `test/core/network/` for the pattern.

## Don'ts
- No `Future.delayed` for timing tests — use `fake_async` or pump helpers.
- No real network — mock the API client (`*_api.dart` retrofit interface).
- No real `FlutterSecureStorage` / `Hive` — mock the service wrapper from `lib/core/services/`.
- Do not edit `*.mocks.dart` — regenerate via build_runner.
