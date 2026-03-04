Architecture  


The project is built on **Clean Architecture** utilizing a feature-first folder structure. The codebase is primarily split into a `core/` directory for shared infrastructure and a `features/` directory for feature modules.

Each feature contains three distinct layers with strict dependency rules:

- **Presentation Layer**: Contains screens and reusable widgets. This layer depends exclusively on the Domain layer and must never depend on the Data layer.
- **Domain Layer**: Contains business entities and abstract repository contracts. This is the innermost layer and depends on nothing.
- **Data Layer**: Contains data sources, data models (DTOs), and repository implementations. This layer depends on the Domain layer to implement its contracts, but never depends on the Presentation layer.

---

## Design Patterns

- **State Management (Riverpod)**: The app uses `Notifier` and `AsyncNotifier` for complex state. Widgets consume state using `ConsumerWidget` or `Consumer` to limit rebuilds, and `AsyncValue.when()` is used to handle loading, error, and data states.
- **Dependency Injection (GetIt + Injectable)**: Services, repositories, and data sources are registered using Injectable annotations eg. `@lazySingleton` and `@injectable`. GetIt instances are never called directly in widgets; instead, they are bridged through Riverpod providers.
- **Networking (Dio)**: All HTTP configuration is centralized in a `DioClient`. Interceptors are used to handle authorization tokens and logging.
- **Routing (GoRouter)**: Navigation is handled by GoRouter. `ShellRoute` is used for persistent layouts, and all route paths are centralized in a static `RoutePaths` class to avoid hardcoded strings.
- **Two-Tier Error Handling**: Data sources throw specific `AppException` subclasses (e.g., `ServerException`, `NetworkException`). Repositories catch these exceptions and return typed `Failure` objects (e.g., `ServerFailure`) to the domain and presentation layers, ensuring raw exceptions don't bubble up to the UI.
- **Data Models & Entities**: Data models (DTOs) are generated using Freezed for JSON serialization and immutability.
- **Utility / Constants Classes**: Constants are grouped into classes with private constructors and `static const` members to prevent accidental instantiation.

---

## Naming Conventions

### File and Folder Naming

- **Files**: Must strictly use `snake_case.dart`.
- **Folders**: Must be lowercase `snake_case` and singular for feature folders (e.g., `auth`, `player`).
- **Suffixes**: Files must be named according to their role, such as `<name>_screen.dart`, `<name>_model.dart`, `<name>_repository.dart`, or `<scope>_constants.dart`.

### Dart Code Naming

- **Classes & Enums**: `PascalCase` (e.g., `TrackRepository`, `TrackStatus`).
- **Variables, Functions, Constants, & Enum Values**: `camelCase` (e.g., `trackTitle`, `fetchTrack()`, `defaultTimeout`).
- **Private Members**: `_camelCase` with a leading underscore (e.g., `_isLoading`).
- **Type Parameters**: `UPPERCASE` (e.g., `T`, `E`).
- **Providers**: Must have descriptive names ending with `Provider` (e.g., `currentTrackProvider`).


---

## Core Principles

- **Code Quality**: Write clean, readable, maintainable code following the DRY (Don't Repeat Yourself) principle. Keep functions and methods small with a single responsibility.
- **Explicitness & Typing**: Prefer explicit over implicit code. Use strong typing and avoid `dynamic` or `Object` unless absolutely necessary. Always use explicit types for public APIs.
- **Immutability**: Prefer `const` constructors and `const` values wherever possible.
- **Null Safety**: use null safety and avoid force-unwrapping (`!`) without a valid reason.

Note: we are thinking on making the project test oriented too.

## Enforcement

- **Zero Warnings**: Code must pass `flutter analyze` with zero issues.
- **Formatting**: All code must be formatted using `dart format .` before committing.
- **Linting**: Lint rules are enforced via `analysis_options.yaml` using `flutter_lints`.

## Organization & Structure

- **Utility Classes**: Constants and utility classes should use a private constructor with `static const` members to prevent instantiation. (stated in the design pattern)
- **Import Order**: Group imports in this strict order: Dart SDK → Flutter SDK → Third-party packages → Project imports. 
- **Internal Imports**: Always use relative imports for files within the project; reserve `package:` imports exclusively for external dependencies.

## Documentation

- **When to Comment**: Document complex business logic, non-obvious workarounds, public APIs, and TODOs with issue references. Do not comment self-explanatory code.
- **Format**: Use `///` for doc comments on classes and methods.

## Strict Prohibitions

- No `print()` statements in production code; use proper logging.
- No hardcoded strings, colors, or magic numbers; define them in constants or theme files.
- No unused imports or dead code left in the project.


 
