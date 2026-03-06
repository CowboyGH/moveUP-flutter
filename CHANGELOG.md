# 📘 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- Added envied config for managing environment variables.
- Added API client starter setup (Dio + Retrofit).
- Added lightweight Dio `InterceptorsWrapper` (debug-only): logs request/response/error metadata without body dump.
- Added secure token persistence with `flutter_secure_storage` (`TokenStorage` + `SecureTokenStorage`).
- Added core network/auth foundation under `lib/core/network/*`:
  - Dio setup and API paths.
  - Logging and auth interceptors (with access token refresh flow).
  - Typed network error DTOs and `DioException` mapper.
- Added typed `NetworkFailure` and `AuthFailure` mapping.
- Added auth data scaffolding: `AuthApiClient`, base `UserDto`, and auth mapper.
- Added login API contract and DTOs in auth data layer (`LoginRequestDto`, `LoginResponseDto`, `LoginSessionDto`) and wired `AuthApiClient.login`.
- Added auth domain/data login flow: `AuthRepository.signIn` contract and `AuthRepositoryImpl` with token persistence.
- Added sign-in presentation flow: `SignInCubit`, `SignInPageBuilder`, and `SignInPage` integrated with router.
- Added unit tests for user entity mapping, sign-in repository flow, and `SignInCubit` states.
- Added `/me` auth API integration: `AuthApiClient.me` and `MeResponseDto`.
- Added auth session foundation with `AuthSessionCubit` (`initial/checking/guest/authenticated/unauthenticated`) and startup session restore.
- Added session-aware router refresh integration via `GoRouterCubitRefreshStream`.
- Added unit tests for `AuthRepositoryImpl.getCurrentUser` and `AuthSessionCubit`.
- Added register API contract and DTOs in auth data layer (`RegisterRequestDto`, `RegisterResponseDto`) and wired `AuthApiClient.register`.
- Added auth domain/data sign-up flow: `AuthRepository.signUp` contract and `AuthRepositoryImpl` implementation.
- Added sign-up presentation flow: `SignUpCubit`, `SignUpPageBuilder`, and `SignUpPage` integrated with router.
- Added unit tests for `AuthRepositoryImpl.signUp` and `SignUpCubit`.
- Added shared auth UI widgets for reusable screen composition: (`AuthFlowShell`, `AuthTextField`, `AuthPasswordField`, `AuthSwitchSection`)

### Changed

- Updated Dockerfile and CI workflow to inject API_URL via GitHub Secrets.
- CI: Split the pipeline: PRs to main now run the release workflow, while PRs to develop run a separate analysis-only workflow.
- Reorganized network/auth structure from legacy `lib/api/service/*` to `lib/core/network/*` and `lib/features/auth/data/*`.
- Updated DI registrations to use the new network setup, token storage, and feature-scoped auth API client.
- Simplified `TokenStorage` to read/write/delete only.
- Updated DI to register `AuthRepository` implementation and provide sign-in dependencies (`AppLogger`, `AuthApiClient`, `TokenStorage`).
- Updated auth presentation routing to resolve sign-in dependencies via `SignInPageBuilder`.
- Simplified `SignInCubit` by removing logger dependency and keeping state transitions focused on auth flow.
- Reduced debug log noise: removed duplicate sign-in logs in repository/cubit, switched debug analytics logs to debug level, and set debug logger `methodCount` to `0`.
- Updated sign-in form behavior: simplified password validation for login (`not empty` + max length), relaxed email regex TLD bound, and gated temporary debug routes (`/debug`) behind debug-only checks.
- Extended `AuthRepository` with `getCurrentUser` and implemented mapping flow in `AuthRepositoryImpl`.
- Updated sign-in UI flow to drive navigation through `AuthSessionCubit` (`onSignInSuccess` / `continueAsGuest`) instead of direct success navigation.
- Updated `SignInPageBuilder` to provide the shared `AuthSessionCubit` instance from DI for router/session consistency.
- Updated app bootstrap to call `restoreSession()` asynchronously on startup.
- Refactored auth repository tests to reuse shared Dio exception fixtures.
- Updated `UserDto.emailVerifiedAt` to nullable to align with `/register` response payload.
- Refactored sign-in and sign-up pages to use shared auth widgets and unified auth layout.
- Updated sign-up consent UX: extracted local `ConsentRow` widget and clarified validation snackbar message.

### Fixed

- Fixed `ErrorResponseDto` serialization configuration by disabling generated `toJson` where it is not used.
- Fixed potential emit-after-close in SignInCubit by guarding with isClosed after awaiting repository response.
- Fixed sign-in page debug shortcuts to be truly disabled in release and improved email validation to accept common addresses (e.g. with '+').

### Removed

- Removed legacy API client scaffold at `lib/api/service/api_client.dart`.

## [0.1.0] - 2026-02-16

### Added

- Added API documentation generation and local preview instructions to `README.md`.

### Changed

- Clarified documentation comments in bootstrap, DI, network, and auth-related files.
- Rebranded the project from template naming to `moveUP` for the initial baseline.
- Aligned Android and iOS identifiers to the new project identity (com.sibcode.moveup).
- Updated project/build configuration files to match the new app identity (platform configs, CI/CD, service files).
- Simplified CI to Android-only: removed iOS job and redundant steps, switched Docker build to a single APK (`app-release.apk`), and tightened formatting/test checks.

### Removed

- Removed legacy `flutter_starter_template` references and leftover template scaffolding from the codebase.
- Removed Firebase integration from the baseline (runtime initialization, Firebase dependencies, platform plugins/config references, and CI mock Firebase file generation).

### Fixed

- Fixed configuration mismatches introduced during template cleanup and project rebranding.

### Breaking

- Android Application ID / Namespace and iOS Bundle Identifier changed to `com.sibcode.moveup`.
- App root widget rename: `FlutterStarterTemplate` -> `MoveUpApp`.
