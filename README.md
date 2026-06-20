# Dog Breeds App

A Flutter mobile application that displays dog breed information from the [Dog API](https://dogapi.dog). Built with Clean Architecture, Bloc state management, and offline-first caching.

## Features

- **Splash screen** with session check and auto-navigation
- **Login / Register** on a single screen with auto-register for new users
- **Home screen** with authenticated username display
- **Dog breed listing** with infinite scroll pagination
- **Cache-first offline strategy** using Hive local storage
- **Pull-to-refresh** for manual data updates
- **Search / filter breeds** with 300ms debounce
- **Dark mode toggle** with persistent preference
- **Clean Architecture** (3 layers: Presentation, Domain, Data)
- **Bloc state management** for predictable UI states
- **GetIt dependency injection** for testability
- **Hive local storage** with SHA-256 hashed passwords
- **Error handling** for network, server, parse, and cache failures

## Architecture

The app follows Clean Architecture with a strict dependency rule:

```
Presentation → Domain ← Data
```

| Layer | Responsibility | Key Components |
|-------|---------------|----------------|
| **Presentation** | UI and state management | Blocs, Widgets, Screens |
| **Domain** | Business logic (zero external deps) | Entities, Use Cases, Repository Interfaces |
| **Data** | Data access and persistence | Repository Implementations, Data Sources, Models |

### Dependency Flow

- The **Domain layer** has no dependencies on external packages (except `dartz` for `Either`).
- **Presentation** depends on Domain (never on Data directly).
- **Data** implements repository interfaces defined in Domain.

### State Management

Authentication and breed listing each have their own Bloc with well-defined events and states:

- `AuthBloc` — handles login, registration, session check, logout
- `BreedsBloc` — handles breed fetching, pagination, refresh, search/filter
- `ThemeBloc` — handles dark/light mode toggle and persistence

## Technology Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State Management | flutter_bloc / bloc |
| Networking | Dio |
| Local Storage | Hive / hive_flutter |
| Dependency Injection | GetIt / Injectable |
| Functional Types | dartz (Either) |
| Connectivity | connectivity_plus |
| Password Hashing | crypto (SHA-256) |
| Equality | equatable |
| Testing | flutter_test, bloc_test, mocktail, glados |

## Project Structure

```
lib/
├── main.dart                          # App entry point, Hive init, DI setup
├── injection.dart                     # GetIt service locator configuration
├── core/
│   ├── error/
│   │   ├── failures.dart              # Typed failure classes
│   │   └── exceptions.dart            # Exception classes
│   ├── network/
│   │   ├── connectivity_service.dart  # Network monitoring service
│   │   └── connectivity_repository.dart
│   ├── theme/
│   │   ├── app_theme.dart             # Material 3 light/dark ThemeData
│   │   ├── theme_bloc.dart            # Theme state management
│   │   ├── theme_repository.dart
│   │   ├── theme_repository_impl.dart
│   │   └── theme_local_data_source.dart
│   └── utils/
│       ├── debouncer.dart             # Configurable debounce utility
│       └── password_hasher.dart       # SHA-256 password hashing
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── check_session_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── screens/
│   │           ├── splash_screen.dart
│   │           └── login_screen.dart
│   └── breeds/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── breed_remote_data_source.dart
│       │   │   └── breed_local_data_source.dart
│       │   ├── models/
│       │   │   ├── breed_model.dart
│       │   │   └── paginated_breed_response.dart
│       │   └── repositories/
│       │       └── breed_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── breed_entity.dart
│       │   │   └── paginated_result.dart
│       │   ├── repositories/
│       │   │   └── breed_repository.dart
│       │   └── usecases/
│       │       ├── get_breeds_usecase.dart
│       │       ├── get_cached_breeds_usecase.dart
│       │       └── cache_breeds_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── breeds_bloc.dart
│           │   ├── breeds_event.dart
│           │   └── breeds_state.dart
│           ├── screens/
│           │   └── home_screen.dart
│           └── widgets/
│               ├── breed_card.dart
│               ├── breed_list.dart
│               └── breed_search_bar.dart
test/
├── core/
│   ├── error/
│   └── utils/
└── features/
    ├── auth/
    └── breeds/
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x ([installation guide](https://docs.flutter.dev/get-started/install))
- Dart SDK 3.11.5+
- Android Studio or Xcode (for emulator/simulator)
- A physical device or emulator running Android 5.0+ / iOS 12.0+

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd dog_breed_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run code generation** (for Injectable DI config)

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**

```bash
flutter run
```

## Running Tests

Run all tests:

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

Run static analysis:

```bash
dart analyze
```

## API Information

This app uses the [Dog API](https://dogapi.dog) — a free, public API for dog breed data.

- **Base URL**: `https://dogapi.dog/api/v2`
- **Breeds endpoint**: `GET /breeds?page[number]={page}&page[size]={size}`
- **Format**: JSON:API specification
- **Authentication**: None required
- **Rate limiting**: Public use, no key needed

### Example Response

```json
{
  "data": [
    {
      "id": "uuid",
      "type": "breed",
      "attributes": {
        "name": "Affenpinscher",
        "description": "...",
        "life": { "min": 10, "max": 12 },
        "male_weight": { "min": 3, "max": 6 },
        "female_weight": { "min": 3, "max": 6 },
        "hypoallergenic": false
      }
    }
  ],
  "links": { "current": "...", "next": "...", "last": "..." },
  "meta": { "pagination": { "current_page": 1, "total_pages": 7 } }
}
```

## Screenshots

| Splash | Login | Home |
|--------|-------|------|
| *placeholder* | *placeholder* | *placeholder* |

| Dark Mode | Search | Offline |
|-----------|--------|---------|
| *placeholder* | *placeholder* | *placeholder* |

## License

This project is for educational/demonstration purposes.
