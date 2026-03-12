# 🤸 moveUP Mobile Fitness App

Mobile client for the moveUP fitness platform.

[![Dart Version](https://img.shields.io/badge/Dart-3.11.0+-blue.svg)](https://dart.dev/)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.0+-blue.svg)](https://flutter.dev/)

---

## 📚 Table of Contents

- [🚀 Highlights](#-highlights)
- [📦 Tech Stack](#-tech-stack)
- [🏗️ Architecture](#️-architecture)
- [📂 Project Structure](#-project-structure)
- [🛠️ Getting Started](#️-getting-started)
- [🧪 Testing](#-testing)
- [📖 Documentation](#-documentation)
- [🐋 Docker Build](#-docker-build)
- [📝 Changelog](#-changelog)

---

## 🚀 Highlights

- 🔐 **End-to-end Auth Flow**: sign in, sign up, email verification, password recovery, OTP verification, password reset, and logout
- 🏛️ **Clean Architecture** in feature modules (Data → Domain → Presentation)
- 🌐 **Network Layer** built on Dio + Retrofit
- 🧭 **Navigation** with GoRouter and session-aware redirects
- 🎨 **UIKit + Theming** with shared buttons, dialogs, images, colors, gradients, and text styles
- ⚠️ **Error Handling** via `Result` and typed `Failure` hierarchies
- 💉 **Dependency Injection** with GetIt + Provider

---

## 📦 Tech Stack

| Category | Technology |
| ---------- | ----------- |
| **Framework** | Flutter 3.41.0+ |
| **State Management** | flutter_bloc |
| **Dependency Injection** | get_it, provider |
| **Navigation** | go_router |
| **Connectivity Tracking** | connectivity_plus |
| **HTTP Client** | dio + retrofit |
| **Code Generation** | freezed, json_serializable, build_runner |
| **Logging** | logger |
| **Testing** | mockito, bloc_test, flutter_test |
| **UI Components** | flutter_svg, cached_network_image |

---

## 🏗️ Architecture

This app follows **Clean Architecture** principles:

```text
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│      (Pages, Widgets, BLoC/Cubit)       │
└───────────────────┬─────────────────────┘
                    │
                    │ uses
┌───────────────────▼─────────────────────┐
│             Domain Layer                │
│   (Entities, UseCases, Repositories*)   │  * interfaces only
└───────────────────▲─────────────────────┘
                    │
                    │ implements
┌───────────────────┴─────────────────────┐
│              Data Layer                 │
│  (DTOs, DataSources, Repositories Impl) │
└─────────────────────────────────────────┘
```

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── constants/         # Shared app strings and asset references
│   ├── di/                # Dependency injection
│   ├── env/               # Envied-based environment config
│   ├── failures/          # Feature and network failure types
│   ├── network/           # Dio setup, interceptors, mappers, error DTOs
│   ├── result/            # Result pattern
│   ├── router/            # GoRouter config and route paths
│   ├── services/          # Cross-feature services (network, token storage)
│   └── utils/             # Logger and analytics utilities
├── features/
│   ├── app/               # App composition and root widget
│   ├── auth/
│   │   ├── data/          # DTOs, API client, repository implementation
│   │   ├── domain/        # Entities and repository contracts
│   │   └── presentation/  # Pages, widgets, cubits, validators
│   └── debug/             # Internal debug screen
├── uikit/
│   ├── buttons/           # Shared buttons
│   ├── dialogs/           # Shared dialogs
│   ├── images/            # Shared image widgets
│   └── themes/            # Color, gradient, and typography system
├── main.dart              # Main entry point
└── runner.dart            # Bootstrap entrypoint
```

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK: `>=3.41.0`
- Dart SDK: `>=3.11.0`

### Setup

1. **Create a local `.env` file in the project root.**

   ```bash
   touch .env
   ```

2. **Fill in `API_URL` in `.env`.**

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run code generation:**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app:**

   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run tests:

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/features/*/presentation/

# Coverage (requires lcov)
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 📖 Documentation

Generate API docs from Dart doc-comments:

```bash
dart doc --output doc/api
```

Serve docs locally:

```bash
dart pub global activate dhttpd
dart pub global run dhttpd --path doc/api
```

Then open:

```text
http://localhost:8080
```

---

## 🐋 Docker Build

Build Android APK using Docker:

```bash
docker build \                                                  
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  --progress=plain \
  --no-cache \
  -t moveUP-app-android:latest .
```

Extract APK files:

```bash
docker create --name temp-flutter moveUP-app-android:latest
docker cp temp-flutter:/artifacts/. ./apk-output/
docker rm temp-flutter
```

---

## 📝 Changelog

All notable changes to this project are documented in [CHANGELOG.md](CHANGELOG.md).
