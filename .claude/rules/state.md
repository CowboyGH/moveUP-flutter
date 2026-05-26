---
paths:
  - "lib/**/*_cubit.dart"
  - "lib/**/*_state.dart"
  - "lib/**/presentation/cubits/**/*.dart"
---

# State management — flutter_bloc (Cubit)

This repo uses **Cubit** from `flutter_bloc` 9. Do not introduce `Bloc`, `ChangeNotifier`, `ValueNotifier`, Riverpod, or GetX.

## File / class layout
- File: `<name>_cubit.dart` in `lib/features/<feature>/presentation/cubits/`.
- Companion state: `<name>_state.dart` declared as `part of '<name>_cubit.dart'` (see `sign_in_cubit.dart` / `sign_in_state.dart`).
- Cubit class: `final class <Name>Cubit extends Cubit<<Name>State>`.
- State: `@freezed` sealed class with named factory constructors (`initial`, `inProgress`, `succeed`, `failed`, …). After editing, run build_runner.
- Each cubit constructor takes its dependencies (repository / service) as positional `final` fields. DI wires them in `lib/core/di/di.dart`.

## Inside a cubit
- Returns from repositories are `Result<T, F extends Failure>`. Switch on `Success(:final data)` / `Failure(:final error)` and emit the matching state — see `sign_in_cubit.dart`.
- Guard re-entrancy: check `state.maybeWhen(inProgress: () => true, orElse: () => false)` before starting an async op.
- After `await`, check `if (isClosed) return;` before `emit`.
- Do NOT perform navigation, snackbars, or dialogs inside the cubit — UI listens to state and reacts.
- Do NOT call `dio` / HTTP directly — go through a repository in `data/repositories/`.

## Tests
- Use `bloc_test` (already a dev dep). One file per cubit in `test/features/<feature>/presentation/cubits/`.
- Mock repositories with `mockito` (`@GenerateMocks([AuthRepository])` → `.mocks.dart`).
- Cover happy path + each `Failure` branch.
