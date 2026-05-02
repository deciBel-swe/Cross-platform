# Code Style Guide

> Unified coding standards and design patterns for the Decibel Flutter app

## Table of Contents

1. [General Principles](#general-principles)
2. [Architecture Overview](#architecture-overview)
3. [File & Folder Naming](#file--folder-naming)
4. [Dart Conventions](#dart-conventions)
5. [Flutter Widget Guidelines](#flutter-widget-guidelines)
6. [State Management (Riverpod)](#state-management-riverpod)
7. [Dependency Injection (GetIt + Injectable)](#dependency-injection-getit--injectable)
8. [Networking (Dio)](#networking-dio)
9. [Routing (GoRouter)](#routing-gorouter)
10. [Error Handling](#error-handling)
11. [Data Models (Freezed)](#data-models-freezed)
12. [Theming & Styling](#theming--styling)
13. [Storage](#storage)
14. [Import Organization](#import-organization)
15. [Comments & Documentation](#comments--documentation)
16. [Testing](#testing)
17. [Code Generation](#code-generation)
18. [Git Commit Messages](#git-commit-messages)

---

## General Principles

### Code Quality Rules

- ✅ Write clean, readable, and maintainable code
- ✅ Follow DRY (Don't Repeat Yourself)
- ✅ Prefer explicit over implicit
- ✅ Use strong typing — avoid `dynamic` and `Object` unless absolutely necessary
- ✅ Keep functions and methods small and focused (single responsibility)
- ✅ Write self-documenting code with meaningful names
- ✅ Prefer `const` constructors and `const` values wherever possible
- ✅ Use Dart 3 features: records, patterns, sealed classes, `super` parameter shorthand

### Enforcement Tools

- **flutter_lints:** Lint rules via `analysis_options.yaml`
- **Dart Analyzer:** `flutter analyze` must pass with zero issues
- **Dart Formatter:** `dart format .` — all code must be formatted before committing

---

## Architecture Overview

The project follows **Clean Architecture** with a feature-first folder structure:

```
lib/
├── main.dart                     # Entry point
├── app.dart                      # Root MaterialApp widget
├── core/                         # Shared infrastructure
│   ├── constants/                # App-wide constants
│   ├── di/                       # Dependency injection setup
│   ├── errors/                   # Exception & Failure classes
│   ├── network/                  # Dio client, interceptors, WebSocket
│   │   └── interceptors/         # Dio interceptors (auth, logging, etc.)
│   ├── router/                   # GoRouter config & route paths
│   ├── storage/                  # Hive, SecureStorage, SharedPreferences
│   ├── theme/                    # Colors, text styles, ThemeData
│   └── utils/                    # Shared utilities & extensions
└── features/                     # Feature modules
    └── <feature>/
        ├── data/                 # Data layer
        │   ├── datasources/      # Remote & local data sources
        │   ├── models/           # DTOs (Freezed + JSON serialization)
        │   └── repositories/     # Repository implementations
        ├── domain/               # Domain layer
        │   ├── entities/         # Business entities
        │   └── repositories/     # Abstract repository contracts
        └── presentation/         # Presentation layer
            ├── screens/          # Full-page screen widgets
            └── widgets/          # Feature-specific reusable widgets
```

### Layer Rules

| Layer            | Depends On                    | Never Depends On   |
| ---------------- | ----------------------------- | ------------------ |
| **Presentation** | Domain                        | Data               |
| **Domain**       | Nothing                       | Data, Presentation |
| **Data**         | Domain (implements contracts) | Presentation       |

---

## File & Folder Naming

### Files

```
✅ CORRECT                        ❌ INCORRECT
login_screen.dart                  LoginScreen.dart
auth_repository.dart               authRepository.dart
track_model.dart                   TrackModel.dart
app_colors.dart                    AppColors.dart
dio_client.dart                    DioClient.dart
auth_interceptor.dart              AuthInterceptor.dart
hive_service.dart                  HiveService.dart
```

**Rules:**

- **All Dart files:** `snake_case.dart` — no exceptions
- **Screens:** `<name>_screen.dart` (e.g., `login_screen.dart`)
- **Widgets:** `<name>_widget.dart` or descriptive name (e.g., `track_card.dart`, `waveform_visualizer.dart`)
- **Models (DTOs):** `<name>_model.dart` (e.g., `track_model.dart`)
- **Entities:** `<name>_entity.dart` or just `<name>.dart` (e.g., `track.dart`)
- **Repositories:** `<name>_repository.dart` (e.g., `auth_repository.dart`)
- **Data Sources:** `<name>_remote_datasource.dart`, `<name>_local_datasource.dart`
- **Providers/Notifiers:** `<name>_provider.dart`, `<name>_notifier.dart`
- **Services:** `<name>_service.dart` (e.g., `hive_service.dart`)
- **Constants:** `<scope>_constants.dart` (e.g., `api_constants.dart`)
- **Tests:** Same name as source + `_test.dart` (e.g., `auth_repository_test.dart`)

### Folders

```
✅ CORRECT                        ❌ INCORRECT
features/auth                      features/Auth
core/network                       core/Network
data/datasources                   data/DataSources
presentation/widgets               presentation/Widgets
```

**Rules:**

- All lowercase `snake_case`
- Feature folders: singular (e.g., `auth`, `player`, `upload`)

---

## Dart Conventions

### Naming Conventions

| Kind              | Convention   | Example                                  |
| ----------------- | ------------ | ---------------------------------------- |
| Classes           | `PascalCase` | `TrackRepository`, `AudioPlayerNotifier` |
| Enums             | `PascalCase` | `TrackStatus`                            |
| Enum values       | `camelCase`  | `TrackStatus.processing`                 |
| Variables         | `camelCase`  | `trackTitle`, `isPlaying`                |
| Constants         | `camelCase`  | `defaultTimeout`, `maxRetries`           |
| Functions/Methods | `camelCase`  | `fetchTrack()`, `onPlayPressed()`        |
| Private members   | `_camelCase` | `_isLoading`, `_handleError()`           |
| Type parameters   | `UPPERCASE`  | `T`, `E`, `K`, `V`                       |
| File names        | `snake_case` | `track_model.dart`                       |

### Utility / Constants Classes

Use a **private constructor** with `static const` members to prevent instantiation:

```dart
// ✅ CORRECT
class AppConstants {
  AppConstants._();

  static const String appName = 'Decibel';
  static const int maxRetries = 3;
}

class RoutePaths {
  RoutePaths._();

  static const String home = '/home';
  static const String login = '/login';
}

// ❌ INCORRECT — instantiable, no private constructor
class AppConstants {
  static const String appName = 'Decibel';
}
```

### Type Annotations

```dart
// ✅ CORRECT — explicit types for public APIs
String getUserName(User user) => user.name;

List<Track> filterByGenre(List<Track> tracks, String genre) {
  return tracks.where((t) => t.genre == genre).toList();
}

// ✅ CORRECT — type inference is fine for local variables
final tracks = await repository.fetchTracks();
final filteredTracks = tracks.where((t) => t.isPublished).toList();

// ❌ INCORRECT — avoid dynamic
dynamic fetchData() { }
```

### Const Usage

```dart
// ✅ CORRECT — const everything you can
const EdgeInsets padding = EdgeInsets.all(16);
const Duration timeout = Duration(seconds: 30);

// ✅ CORRECT — const constructor
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
}

// ❌ INCORRECT — missing const
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key}); // should be const
}
```

### Enums

```dart
// ✅ CORRECT — enhanced enums (Dart 3)
enum TrackStatus {
  processing('Processing'),
  finished('Finished'),
  failed('Failed');

  const TrackStatus(this.label);
  final String label;
}

// ❌ INCORRECT — plain strings instead of enums
const String statusProcessing = 'processing';
```

### Null Safety

```dart
// ✅ CORRECT — embrace null safety
User? currentUser;
final userName = currentUser?.name ?? 'Guest';

// ❌ INCORRECT — force unwrapping without reason
final userName = currentUser!.name;
```

---

## Flutter Widget Guidelines

### Widget Structure

```dart
// ✅ CORRECT — well-structured widget
import 'package:flutter/material.dart';

import '../../domain/entities/track.dart';

/// Displays a single track in a list with cover art, title, and artist name.
class TrackCard extends StatelessWidget {
  const TrackCard({
    super.key,
    required this.track,
    this.onTap,
  });

  final Track track;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _CoverArt(url: track.coverUrl),
            const SizedBox(width: 12),
            _TrackInfo(track: track),
          ],
        ),
      ),
    );
  }
}
```

### Widget Organization Order

1. **Imports** (Dart SDK → Flutter → packages → project)
2. **Doc comment** on the class
3. **Class declaration** with `const` constructor
4. **Final fields** (parameters)
5. **`build` method**
6. **Private helper methods** (prefer extracting to private widgets)

### Screen vs Widget

| Type   | Location                | Purpose                          |
| ------ | ----------------------- | -------------------------------- |
| Screen | `presentation/screens/` | Full-page widget, owns a route   |
| Widget | `presentation/widgets/` | Reusable composable UI component |

### Rules

- ✅ Always use `const` constructors when possible
- ✅ Use `super.key` shorthand (not `Key? key`)
- ✅ Prefer `final` fields over getters for widget parameters
- ✅ Extract large widget trees into smaller private widgets or separate files
- ✅ Use `Theme.of(context)` to access theme — never hardcode colors in widgets
- ❌ Avoid deeply nested widget trees (max ~4 levels deep in a single method)
- ❌ Avoid logic in `build()` — keep it declarative
- ❌ Avoid `StatefulWidget` when Riverpod state management suffices

### Keys

```dart
// ✅ CORRECT — use ValueKey for lists
ListView.builder(
  itemBuilder: (context, index) {
    final track = tracks[index];
    return TrackCard(key: ValueKey(track.id), track: track);
  },
);

// ❌ INCORRECT — never use index as key for dynamic lists
TrackCard(key: ValueKey(index), track: track);
```

---

## State Management (Riverpod)

### Setup

The root widget is wrapped in `ProviderScope`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ProviderScope(child: DecibelApp()));
}
```

### Provider Types

| Provider                | Use Case                                             |
| ----------------------- | ---------------------------------------------------- |
| `Provider`              | Expose services/repositories from GetIt              |
| `FutureProvider`        | One-shot async data (e.g., initial config)           |
| `StreamProvider`        | Reactive streams (e.g., WebSocket, audio position)   |
| `StateNotifierProvider` | Complex state with actions (legacy, prefer Notifier) |
| `NotifierProvider`      | Complex synchronous state (Dart 3 preferred)         |
| `AsyncNotifierProvider` | Complex async state (Dart 3 preferred)               |

### Provider Naming

```dart
// ✅ CORRECT — descriptive, ends with Provider
final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final currentTrackProvider = StreamProvider<Track?>((ref) {
  return ref.watch(playerServiceProvider).currentTrackStream;
});

final userTracksProvider = FutureProvider.family<List<Track>, String>((ref, userId) {
  return ref.watch(trackRepositoryProvider).fetchUserTracks(userId);
});

// ❌ INCORRECT — vague naming
final provider1 = Provider((_) => 'bad');
```

### Notifier Pattern

```dart
// ✅ CORRECT — AsyncNotifier for async state
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
    final user = await ref.watch(authRepositoryProvider).getCurrentUser();
    return AuthState(user: user, isAuthenticated: user != null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      return AuthState(user: user, isAuthenticated: true);
    });
  }

  void logout() {
    ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthState(user: null, isAuthenticated: false));
  }
}
```

### Consuming Providers in Widgets

```dart
// ✅ CORRECT — ConsumerWidget for reading providers
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(trendingTracksProvider);

    return tracksAsync.when(
      data: (tracks) => TrackListView(tracks: tracks),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }
}

// ✅ CORRECT — Consumer for scoped rebuilds inside StatelessWidget
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(currentUserProvider);
          return UserProfileView(user: user);
        },
      ),
    );
  }
}
```

### Rules

- ✅ Prefer `AsyncNotifier`/`Notifier` over legacy `StateNotifier`
- ✅ Use `ref.watch()` in `build()`, `ref.read()` in callbacks
- ✅ Use `AsyncValue.when()` for loading/error/data states
- ✅ Use `.family` modifier for parameterized providers
- ❌ Never call `ref.watch()` inside callbacks or event handlers
- ❌ Never store `WidgetRef` in a variable — use it directly

---

## Dependency Injection (GetIt + Injectable)

### Setup

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### Annotations

```dart
// ✅ CORRECT — register as lazy singleton
@lazySingleton
class DioClient {
  // ...
}

// ✅ CORRECT — register as injectable (new instance each time)
@injectable
class TrackRepository implements ITrackRepository {
  const TrackRepository(this._remoteDataSource);
  final TrackRemoteDataSource _remoteDataSource;
}

// ✅ CORRECT — register abstract ↔ implementation binding
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  // ...
}

// ✅ CORRECT — module for third-party dependencies
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
}
```

### Bridging GetIt → Riverpod

```dart
// Expose GetIt services as Riverpod providers
final authRepositoryProvider = Provider<IAuthRepository>(
  (_) => getIt<IAuthRepository>(),
);

final dioClientProvider = Provider<DioClient>(
  (_) => getIt<DioClient>(),
);
```

### Rules

- ✅ Register services, repositories, and datasources with Injectable annotations
- ✅ Use `@lazySingleton` for services that should be shared (network, storage)
- ✅ Use `@injectable` for repositories and use-cases (fresh instances)
- ✅ Run `dart run build_runner build` after adding/modifying DI registrations
- ❌ Never call `getIt<T>()` directly in widgets — bridge through Riverpod providers

---

## Networking (Dio)

### Client Configuration

```dart
// lib/core/network/dio_client.dart
@lazySingleton
class DioClient {
  DioClient(this._dio) {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..contentType = 'application/json';

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  // put, delete, patch ...
}
```

### Interceptors

```dart
// lib/core/network/interceptors/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic
    }
    handler.next(err);
  }
}
```

### Rules

- ✅ Centralize all HTTP config in `DioClient`
- ✅ Use interceptors for cross-cutting concerns (auth, logging, retry)
- ✅ Wrap Dio exceptions into `AppException` subclasses in data sources
- ❌ Never use `http` package — Dio is the standard
- ❌ Never hardcode URLs — use `ApiConstants`

---

## Routing (GoRouter)

### Configuration

```dart
// lib/core/router/app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RoutePaths.discover,
          builder: (context, state) => const DiscoverScreen(),
        ),
        // ...
      ],
    ),
  ],
);
```

### Route Paths

```dart
// lib/core/router/route_paths.dart
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String search = '/search';
  static const String library = '/library';
  static const String player = '/player';
  static const String profile = '/profile';
  static const String upload = '/upload';
}
```

### Rules

- ✅ All route paths centralized in `RoutePaths`
- ✅ Use `ShellRoute` for persistent layouts (bottom nav, player bar)
- ✅ Navigate with `context.go()` / `context.push()` — not `Navigator`
- ❌ Never hardcode path strings in widgets — always reference `RoutePaths`

---

## Error Handling

### Two-Tier Error Model

The project uses a **Clean Architecture** error pattern separating data-layer exceptions from domain-layer failures.

#### Exceptions (Data Layer)

Thrown by data sources when something goes wrong:

```dart
// lib/core/errors/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}
```

#### Failures (Domain Layer)

Returned by repositories as typed results (no thrown exceptions in domain):

```dart
// lib/core/errors/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure']);
}
```

### Error Flow

```
DataSource throws AppException
       ↓
Repository catches → returns Failure (or result type)
       ↓
Notifier receives → updates AsyncValue.error or state
       ↓
Widget displays → AsyncValue.when(error: ...)
```

### Rules

- ✅ Data sources **throw** `AppException` subclasses
- ✅ Repositories **catch** exceptions and return `Failure` objects (or use `Either`/`AsyncValue`)
- ✅ Notifiers handle failures and update state accordingly
- ✅ Widgets display errors using `AsyncValue.when(error: ...)`
- ❌ Never let raw exceptions propagate to the presentation layer
- ❌ Never catch generic `Exception` — catch specific types

---

## Data Models (Freezed)

### Model Definition

```dart
// lib/features/player/data/models/track_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_model.freezed.dart';
part 'track_model.g.dart';

@freezed
class TrackModel with _$TrackModel {
  const factory TrackModel({
    required String id,
    required String title,
    required String artistId,
    required String audioUrl,
    String? coverUrl,
    String? genre,
    @Default(0) int playCount,
    required DateTime createdAt,
  }) = _TrackModel;

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);
}
```

### Entity Definition

```dart
// lib/features/player/domain/entities/track.dart
class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artistId,
    required this.audioUrl,
    this.coverUrl,
    this.genre,
    this.playCount = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String artistId;
  final String audioUrl;
  final String? coverUrl;
  final String? genre;
  final int playCount;
  final DateTime createdAt;
}
```

### Model ↔ Entity Mapping

```dart
// Extension on the model for conversion
extension TrackModelX on TrackModel {
  Track toEntity() => Track(
        id: id,
        title: title,
        artistId: artistId,
        audioUrl: audioUrl,
        coverUrl: coverUrl,
        genre: genre,
        playCount: playCount,
        createdAt: createdAt,
      );
}

extension TrackX on Track {
  TrackModel toModel() => TrackModel(
        id: id,
        title: title,
        artistId: artistId,
        audioUrl: audioUrl,
        coverUrl: coverUrl,
        genre: genre,
        playCount: playCount,
        createdAt: createdAt,
      );
}
```

### Rules

- ✅ Use `@freezed` for all DTOs / data models
- ✅ Keep domain entities as plain Dart classes (no code-gen dependency)
- ✅ Always include `fromJson` factory for JSON deserialization
- ✅ Use `@Default()` for default values in Freezed models
- ✅ Use extensions for model ↔ entity mapping
- ❌ Never import Freezed models directly in the domain or presentation layer
- ❌ Never add business logic to models — they are pure data containers

---

## Theming & Styling

### Color Definitions

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF5500);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onPrimary = Colors.white;
}
```

### Text Styles

```dart
// lib/core/theme/app_text_styles.dart
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
  );
}
```

### Theme Data

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
    );
  }
}
```

### Rules

- ✅ All colors in `AppColors`, all text styles in `AppTextStyles`
- ✅ Access colors/styles via `Theme.of(context)` or the constants classes
- ✅ Dark theme is the default (music app convention)
- ✅ Use `const` for all color and text style definitions
- ❌ Never hardcode colors or font sizes directly in widgets
- ❌ Never use `Colors.red`, `Colors.blue` etc. inline — define them in `AppColors`

---

## Storage

### Three Storage Tiers

| Service                | Package                  | Use Case                                                |
| ---------------------- | ------------------------ | ------------------------------------------------------- |
| `SecureStorageService` | `flutter_secure_storage` | JWT tokens, OAuth credentials                           |
| `HiveService`          | `hive` + `hive_flutter`  | Structured local data (recently played, offline tracks) |
| `SharedPrefsService`   | `shared_preferences`     | Simple key-value preferences (theme, settings)          |

### Rules

- ✅ Wrap each storage backend in a service class under `core/storage/`
- ✅ Register storage services as `@lazySingleton` in DI
- ✅ Use `SecureStorage` only for sensitive data (tokens, credentials)
- ❌ Never store tokens in SharedPreferences or Hive
- ❌ Never access storage directly in widgets — go through a service or repository

---

## Import Organization

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports (relative)
import '../../domain/entities/track.dart';
import '../widgets/track_card.dart';
```

### Relative vs Package Imports

```dart
// ✅ CORRECT — relative imports within the project
import '../widgets/track_card.dart';
import '../../domain/entities/track.dart';
import '../../core/theme/app_colors.dart';

// ❌ INCORRECT — package imports for project files
import 'package:decibel/features/player/presentation/widgets/track_card.dart';
```

> **Note:** Use relative imports for all project files. Reserve `package:` imports for
> external dependencies only.

### Barrel Exports

```dart
// ✅ CORRECT — features/auth/domain/domain.dart (barrel file)
export 'entities/user.dart';
export 'repositories/auth_repository.dart';

// Usage
import '../domain/domain.dart';
```

### Rules

- ✅ Group imports: Dart SDK → Flutter → packages → project
- ✅ Alphabetize within each group
- ✅ Use `show` / `hide` to limit import scope when helpful
- ❌ Never leave unused imports

---

## Comments & Documentation

### When to Comment

- ✅ Complex business logic
- ✅ Non-obvious workarounds
- ✅ Public APIs (classes, methods)
- ✅ TODO items with issue references
- ❌ Self-explanatory code

### Doc Comments (`///`)

```dart
/// Uploads an audio file and returns the created track.
///
/// Throws [ServerException] if the upload fails.
/// Throws [NetworkException] if there is no internet connection.
Future<Track> uploadTrack({
  required File audioFile,
  required TrackMetadata metadata,
});
```

### Class-Level Documentation

```dart
/// Persistent audio player that manages playback state.
///
/// Features:
/// - Play, pause, skip, seek
/// - Stream current position & duration
/// - Background playback support
class AudioPlayerService {
  // ...
}
```

### TODO Format

```dart
// TODO(username): Description of what needs to be done (#issue-number)
// TODO(ahmed): Implement token refresh logic (#42)
```

---

## Testing

### File Naming & Location

```
test/
├── core/
│   ├── network/
│   │   └── dio_client_test.dart
│   └── errors/
│       └── exceptions_test.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository_test.dart
│   │   ├── domain/
│   │   │   └── auth_notifier_test.dart
│   │   └── presentation/
│   │       └── login_screen_test.dart
│   └── player/
│       └── ...
└── widget_test.dart
```

The `test/` folder mirrors the `lib/` folder structure.

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockAuthRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAuthRemoteDataSource();
      repository = AuthRepository(mockDataSource);
    });

    test('login returns user on success', () async {
      // Arrange
      when(() => mockDataSource.login(any(), any()))
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.login('email', 'pass');

      // Assert
      expect(result, isA<User>());
      expect(result.email, 'email');
    });

    test('login throws ServerFailure on error', () async {
      // Arrange
      when(() => mockDataSource.login(any(), any()))
          .thenThrow(const ServerException());

      // Act & Assert
      expect(
        () => repository.login('email', 'pass'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
```

### Widget Tests

```dart
testWidgets('TrackCard displays title and artist', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: TrackCard(track: testTrack),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('Track Title'), findsOneWidget);
  expect(find.text('Artist Name'), findsOneWidget);
});
```

### Test Naming Convention

```dart
// ✅ CORRECT — descriptive test names
test('fetchTracks returns list of tracks when response is 200', () { });
test('fetchTracks throws ServerException when response is 500', () { });

// ❌ INCORRECT — vague names
test('test1', () { });
test('it works', () { });
```

### Rules

- ✅ Follow **Arrange → Act → Assert** pattern
- ✅ Use `group()` to organize related tests
- ✅ Use `setUp()` and `tearDown()` for test fixtures
- ✅ Test names should describe the **behavior**, not the implementation
- ✅ Aim for high coverage on repositories, notifiers, and business logic
- ✅ Widget tests should verify UI rendering and user interaction
- ❌ Never test implementation details — test behavior and outcomes

---

## Code Generation

### Commands

```bash
# Generate all (freezed, json_serializable, injectable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on save)
dart run build_runner watch --delete-conflicting-outputs
```

### Generated Files

Generated files follow the pattern `*.g.dart`, `*.freezed.dart`, `*.config.dart`.

### Rules

- ✅ Always run `build_runner build` after modifying annotated classes
- ✅ Commit generated files to version control
- ✅ Add `--delete-conflicting-outputs` to avoid stale output
- ❌ Never manually edit generated files (`*.g.dart`, `*.freezed.dart`)

---

## Git Commit Messages

### Format

```
<type>(<scope>): <subject>

<body (optional)>

<footer (optional)>
```

### Types

| Type       | Description                                      |
| ---------- | ------------------------------------------------ |
| `feat`     | New feature                                      |
| `fix`      | Bug fix                                          |
| `docs`     | Documentation changes                            |
| `style`    | Formatting, missing semicolons (no logic change) |
| `refactor` | Code refactoring                                 |
| `test`     | Adding or updating tests                         |
| `chore`    | Maintenance tasks (deps, CI, build)              |

### Examples

```bash
# ✅ CORRECT
feat(auth): implement email/password login
fix(player): resolve seek bar jumping on track change
docs(readme): update installation instructions
refactor(network): extract base API client
test(auth): add unit tests for login repository
chore(deps): upgrade flutter_riverpod to 2.6.1

# ❌ INCORRECT
Update files
Fixed bug
WIP
```

### Rules

- Use imperative mood ("add feature" not "added feature")
- Lowercase subject line
- No period at the end
- Keep subject under 50 characters

---

## Checklist Before Pushing

- [ ] `flutter analyze` passes with zero issues
- [ ] `dart format .` applied — no formatting diffs
- [ ] No `dynamic` types (unless justified and commented)
- [ ] `const` constructors used wherever possible
- [ ] All public APIs have `///` doc comments
- [ ] No `print()` statements — use proper logging
- [ ] No hardcoded strings/colors/values — use constants and theme
- [ ] Tests written and passing (`flutter test`)
- [ ] Generated code is up to date (`build_runner build`)
- [ ] Imports are organized (Dart → Flutter → packages → project)
- [ ] No unused imports or dead code
- [ ] Commit message follows convention

---

## Things to Avoid

❌ `print()` in production code — use a logging package  
❌ `dynamic` type — use proper typing  
❌ Hardcoded colors, strings, or magic numbers — use constants  
❌ `setState()` for complex state — use Riverpod  
❌ Deeply nested widget trees — extract sub-widgets  
❌ Business logic in widgets — keep it in notifiers/repositories  
❌ Force-unwrapping nulls (`!`) without null checks  
❌ Mutable state in widgets — use `final` fields  
❌ `Navigator.push()` — use GoRouter's `context.go()`/`context.push()`  
❌ Raw `getIt<T>()` calls in widgets — bridge through Riverpod  
❌ Manually editing generated files (`*.g.dart`, `*.freezed.dart`)  
❌ Committing with analyzer warnings or failing tests
