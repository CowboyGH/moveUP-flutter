# 🤸 moveUP Mobile Fitness App

Mobile client for the moveUP fitness platform.

[![Dart Version](https://img.shields.io/badge/Dart-3.11.0+-blue.svg)](https://dart.dev/)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.40.0+-blue.svg)](https://flutter.dev/)

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

- 🏛️ **Clean Architecture** (Data → Domain → Presentation)
- 💉 **Dependency Injection** (GetIt + Provider)
- ⚠️ **Error Handling** (Result pattern + Failure hierarchy)
- 📝 **Logging** with `AppLogger` abstraction and Mixin for Bloc/Cubit
- 🧭 **Navigation** with GoRouter
- 🌐 **Connectivity Tracking** with connectivity_plus
- 🔔 **Push Notifications** (Firebase Cloud Messaging)
- 📦 **Modular Structure** for scalable feature development

---

## 📦 Tech Stack

| Category | Technology |
| ---------- | ----------- |
| **Framework** | Flutter 3.40.0+ |
| **State Management** | flutter_bloc |
| **Dependency Injection** | get_it, provider |
| **Navigation** | go_router |
| **Connectivity Tracking** | connectivity_plus |
| **Push Notifications** | firebase_messaging |
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
├── core/                  # Shared infrastructure
│   ├── di/                # Dependency injection
│   ├── failures/          # Error handling (Failure)
│   ├── result/            # Result-pattern
│   ├── router/            # Navigation (GoRouter)
│   ├── services/          # Services (Network, etc.)
│   └── utils/             # Utilities (Logger, Analytics)
├── features/              # Feature modules (Clean Architecture)
│   └── [feature_name]/
│       ├── data/          # DTOs, DataSources, Repository Impl
│       ├── domain/        # Entities, UseCases, Repository Interfaces
│       └── presentation/  # Pages, Widgets, BLoC/Cubit
├── uikit/                 # Shared UI components
└── main.dart              # App entry point
```

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK: `>=3.41.0`
- Dart SDK: `>=3.11.0`
- Firebase project (for Firebase Cloud Messaging)

### Setup

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Configure Firebase:**

   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

3. **Run code generation:**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**

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
