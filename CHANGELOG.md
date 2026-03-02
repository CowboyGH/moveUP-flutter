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

### Changed

- Updated Dockerfile and CI workflow to inject API_URL via GitHub Secrets.
- CI: Split the pipeline: PRs to main now run the release workflow, while PRs to develop run a separate analysis-only workflow.
- Reorganized network/auth structure from legacy `lib/api/service/*` to `lib/core/network/*` and `lib/features/auth/data/*`.
- Updated DI registrations to use the new network setup, token storage, and feature-scoped auth API client.
- Simplified `TokenStorage` to read/write/delete only.
- Reduced `AuthRepository` to a temporary empty interface until feature-specific methods are introduced.

### Fixed

- Fixed `ErrorResponseDto` serialization configuration by disabling generated `toJson` where it is not used.

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
