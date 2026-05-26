# moveUP — mobile fitness app

Mobile client for the moveUP fitness platform. Targets iOS and Android.

## Stack
- Flutter 3.44.0 (3.41.0 in CI), Dart SDK `>=3.10.0 <4.0.0`, channel stable
- State: `flutter_bloc` 9 (Cubit pattern, not Bloc)
- DI: `get_it` 9 + `provider` 6 (Provider used for widget-tree DI only, not state)
- Routing: `go_router` 17 (paths in `lib/core/router/router_paths.dart`)
- HTTP: `dio` 5 + `retrofit` 4 + `dio_cookie_manager` + `cookie_jar`
- Models / codegen: `freezed` 3 + `json_serializable` 6 + `retrofit_generator` + `envied_generator`
- Local storage: `hive_ce_flutter` 2 + `flutter_secure_storage` 10
- Env: `envied` (obfuscated, reads `.env` at root)
- Tests: `flutter_test` + `mockito` 5 + `bloc_test` 10 + `fake_async`
- Logging: `logger`

## Commands
- `flutter pub get` — install deps
- `dart run build_runner build --delete-conflicting-outputs` — codegen one-shot
- `dart run build_runner watch --delete-conflicting-outputs` — codegen watch
- `dart format lib/ test/` — format (page width 100, trailing commas preserved)
- `flutter analyze --fatal-infos` — lints (CI fails on infos)
- `flutter test` / `flutter test --coverage` — unit + widget tests
- `flutter run` — run on attached device / simulator
- `dart doc --output doc/api` — generate dartdoc

## Repo layout
- `lib/core/` — `di/`, `router/`, `env/`, `network/`, `services/`, `failures/`, `result/`, `constants/`, `utils/`
- `lib/features/<feature>/` — feature-first, layers `data/` + `domain/` + `presentation/` (+ optional `support/`)
- `lib/features/<feature>/presentation/` — `pages/`, `cubits/`, `widgets/`, `validators/`
- `lib/uikit/` — shared `buttons/`, `dialogs/`, `images/`, `themes/`, `inputs/`, `cards/`, `menus/`
- `lib/main.dart` → `lib/runner.dart` — single entrypoint, no flavors
- `test/` — mirror of `lib/`
- `assets/` — `icons/`, `images/`, `splash/`, `legal/`, `fonts/montserrat/`

## Conventions
- Files: `snake_case`. Suffixes used in this repo: `_page.dart` (screens, **not** `_screen.dart`), `_widget.dart`, `_cubit.dart`, `_state.dart`, `_repository.dart`, `_dto.dart`, `_mapper.dart`, `_failure.dart`, `_api.dart`.
- State files: `part of` cubit, generated as `<name>_state.dart`; cubit class often `final class`.
- Imports: relative (`prefer_relative_imports` enabled) within `lib/`.
- Strings: single quotes (`prefer_single_quotes`).
- `const` everywhere possible (warning if missed).
- All public members require dartdoc (`public_member_api_docs`).
- Commits: Conventional Commits (`feat(auth): ...`, `fix(...): ...`, `chore(...): ...`).
- Branches: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`. Default branch is `develop`; release PRs target `main`.

## Hard rules
- Never edit generated: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`, `lib/core/localization/generated/**`. After changing a `@freezed` / `@JsonSerializable` / `@RestApi` / `@Envied` source → run `dart run build_runner build --delete-conflicting-outputs`.
- Don't add or upgrade dependencies in `pubspec.yaml` without explicit request.
- Don't touch `ios/`, `android/`, `Dockerfile`, `.github/workflows/**` without explicit request.
- Don't use `Navigator.push` / `Navigator.pop` directly — use `context.go` / `context.push` / `context.pop` (go_router). Add new routes in `lib/core/router/router_paths.dart` + `router.dart`.
- Don't introduce a new state-management lib. Use Cubit from `flutter_bloc`.
- Don't bypass the `Result<T, F>` / `Failure` pattern in `lib/core/result/` + `lib/core/failures/` — repositories return `Result`, cubits switch on `Success` / `Failure`.

## Scope discipline
- Modify only files relevant to the current task.
- See an unrelated issue? Mention it in the final message — don't fix it. If user wants leave `// TODO(claude): <description>`.
- Large refactor (>100 lines or 3+ files): outline plan → wait for confirmation → code.
- Don't mass-rename or reformat without explicit request.

## When to ask
- Ambiguous requirements (more than one reasonable interpretation).
- Before adding any new package to `pubspec.yaml`.
- Before changing a public API of a widget / cubit / repository used in 3+ places.
- Before changing the navigation graph (new top-level route, redirect logic).
- Task touches >5 files and the plan is non-obvious.

## PR
- Before `gh pr create`: `dart format lib/ test/ && flutter analyze --fatal-infos && flutter test`.
- Target branch: `develop` (CI runs `develop-analysis.yml`). Release PRs target `main` (`main.yml`, full Android build).
- Title: Conventional Commits, under 70 chars, without body (1 line only).
- Body: **Why** / **What** / **How to test**, 1–3 lines each. Link issue `Closes #N`.
- Don't merge yourself.

## Keeping docs current
- New feature establishes a pattern → add/update the relevant `.claude/rules/*.md`.
- Dependency or layer changes → update `Stack` above and `docs/architecture.md`.
- One fact, one place: if a rule lives in `CLAUDE.md` and in a rules file, remove one and link.
- If you corrected Claude on the same thing twice — that's a signal to write a rule.

## Extended docs (NOT auto-loaded)
- `docs/architecture.md` — feature-first layers, data flow
- `README.md` — project overview, setup, Docker build
- `CHANGELOG.md` — release history

## Env notes
- `.env` at repo root (gitignored). Required: `API_URL` (e.g. `http://127.0.0.1:8000/`). CI falls back to `http://127.0.0.1:8000/` if secret missing.
- Envied is obfuscated — after changing `.env` regenerate via build_runner.
- No flavors. Single `main.dart` → `runner.dart` bootstrap.
- Local extras live in `CLAUDE.local.md` (gitignored).
