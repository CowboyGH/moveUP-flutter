# 📘 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- Added `dartdoc_options.yaml` to configure Dart API docs generation and exclude the generated `firebase_options` library.
- Added API documentation generation and local preview instructions to `README.md`.

### Changed

- Clarified documentation comments in bootstrap, DI, network, and auth-related files.
- Rebranded the project from template naming to `moveUP` for the initial baseline.
- Aligned Android, iOS and Firebase identifiers to the new project identity (`com.sibcode.moveup`).
- Updated project/build configuration files to match the new app identity (platform configs, CI/CD, service files).
- Simplified CI to Android-only: removed iOS job and redundant steps, switched Docker build to a single APK (`app-release.apk`), and tightened formatting/test checks.

### Removed

- Removed legacy `flutter_starter_template` references and leftover template scaffolding from the codebase.

### Fixed

- Fixed configuration mismatches introduced during template cleanup and project rebranding.

### Breaking

- Android Application ID / Namespace and iOS Bundle Identifier changed to `com.sibcode.moveup`.
- App root widget rename: `FlutterStarterTemplate` -> `MoveUpApp`.
