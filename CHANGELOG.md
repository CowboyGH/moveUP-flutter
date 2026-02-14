# 📘 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

## [0.3.0] - 2026-02-03

### Added

- Complete authentication system with email/password and Google Sign-In support.
- `User` entity, `AuthRepository` (interface + Firebase impl), typed `AuthFailure` hierarchy.
- `AuthBloc` with comprehensive unit tests for all auth flows.
- `SignInPage` UI with sign-in/sign-up toggle, form validation, and error localization.
- Auth-aware GoRouter routing (`/auth/*` public, others require auth).
- Analytics logging for auth events (sign-in/up/out).
- `DebugScreen` with sign-out for testing.

### Changed

- Breaking: `AppFailure` constructor: `message` now positional parameter.
- Form handling: `TextEditingController` → `FormKey` + `onSaved()` (no `dispose()` needed).
- Auth UI: improved toggle text clarity, added headlines/labels, RichText links.
- Bloc: `BlocConsumer` → `BlocListener` (removed redundant loading states).
- Auth routes now use `/auth/*` prefix consistently.

### Fixed

- CI/CD pipeline: added `build_runner` for Freezed codegen in Docker.
- Prevented multiple simultaneous auth requests (button debounce).
- Enhanced email/password validators with real regex checks.
- Router redirect logic: clearer variable naming.

### Refactored

- Simplified auth repository documentation (removed verbose comments).
- Updated `.gitignore` to exclude generated `*.freezed.dart`.

### Removed

- Removed unused `.gitkeep` files.
- Removed `AsyncResult` type alias (not used in auth flow).

## [0.2.0] - 2025-12-20

### Added

- Implemented base Clean Architecture structure (`core`, `features`, `uikit`) with `data`, `domain`, and `presentation` layers.
- Added project dependencies from `pubspec.yaml`.
- Integrated `GetIt` for dependency injection.
- Added `DebugScreen` widget for testing and debugging purposes.
- Added application router with `GoRouter` and defined route paths for navigation.
- Integrated `logger` package with `AppLogger` abstraction, DI setup, and global error handling (Flutter & platform-level).
- Integrated `Firebase Core` for authentication and analytics features.
- Integrated `Firebase Crashlytics` for global error handling.
- Added `AppFailure` base class and `UnknownFailure` implementation for unified domain-level error handling.
- Added sealed `Result` abstraction with `Success` and `Failure` implementations, plus `AsyncResult` type alias for standardizing async operation handling.
- Added DI-independent fallback error handler inside `runZonedGuarded` to ensure reliable error reporting even if DI or Firebase are not ready.
- Added unified analytics architecture with `Firebase Analytics` integration, debug logging, and automatic screen view tracking via `AnalyticsRouteObserver`.
- Added `AppLoggerMixin` for convenient logger access in Bloc/Cubit.
- Added CI/CD pipeline with GitHub Actions:
  - Multi-stage Dockerfile with Flutter 3.38.4 and Android SDK 35.
  - Support for split APK by ABI (armeabi-v7a, arm64-v8a, x86_64).
  - `.dockerignore` for optimized build context.
  - Workflow jobs: code analysis, Android build (Docker + DockerHub), iOS build (macOS runner).
  - Artifact uploads and build summaries.
- Added `NetworkService` for monitoring network availability with `connectivity_plus` integration and unit tests.

### Changed

- Updated `analysis_options.yaml` (including enabling `public_member_api_docs`).
- Refactored app startup:
  - Extracted main application widget to `app.dart`.
  - Added `runner.dart` for app initialization and error handling.
  - Simplified `main.dart`.
- Streamlined logger registration in dependency injection setup.
- Updated Dart SDK constraint to `>=3.10.0 <4.0.0`.

### Fixed

- Moved `WidgetsFlutterBinding.ensureInitialized()` inside `runZonedGuarded` in `runner.dart` to ensure proper app initialization and error handling.
- Fixed code generation failure by updating `retrofit_generator` for compatibility with newer `analyzer` versions.

## [0.1.0] - 2025-10-29

### Added

- Initial Flutter project created via `flutter create`.
- Added core documentation files and base configuration.
