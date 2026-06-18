# Decibel

A cross-platform SoundCloud-inspired audio streaming application built with Flutter. Decibel supports Android, iOS, Web, Windows, macOS, and Linux from a single codebase.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Setup](#environment-setup)
- [Running the App](#running-the-app)
- [Code Generation](#code-generation)
- [Code Quality](#code-quality)

---

## Overview

Decibel is a full-featured audio streaming platform clone developed as a software engineering project. It replicates the core experience of SoundCloud, covering user authentication, audio upload and playback, social interactions, real-time notifications, playlist management, search and discovery, direct messaging, and a premium subscription tier.

---

## Features

### Module 1 - Authentication and User Management

- Email-based registration with CAPTCHA verification and automated resend workflows
- Self-service password reset and email update flows
- Google OAuth and social login integration
- Secure JWT and refresh token handling for persistent sessions

### Module 2 - User Profile and Social Identity

- Dynamic bio, location, and favorite genre tagging
- Artist (uploader) and Listener account role distinction
- Avatar and cover photo management
- External social profile linking (Instagram, Twitter, personal website)
- Public and private profile visibility settings

### Module 3 - Followers and Social Graph

- Real-time follow and unfollow system with automatic feed updates
- Dedicated views for Followers, Following, and Suggested Users
- User blocking and unblocking with a managed Blocked Users list

### Module 4 - Audio Upload and Track Management

- Multi-format upload support for MP3, WAV, and high-bitrate audio
- Metadata engine for title, genre, tags, and release date
- Automatic transcoding state tracking (Processing vs. Finished)
- Track visibility toggle between Public and Private (link-only)
- Audio waveform visualization of track peaks

### Module 5 - Playback and Streaming Engine

- Core player with Play, Pause, Seek, and Volume controls
- Playback state handling for Playable, Preview, and Blocked states
- Recently Played and Listening History tracking
- Persistent sticky player UI that works seamlessly on Web and Mobile

### Module 6 - Engagement and Social Interactions

- One-tap track liking with a global Favorites count
- Repost functionality to share tracks to a user's own feed and profile
- Timestamped comments tied to specific seconds in the audio waveform
- Engagement lists showing users who Liked or Reposted a track

### Module 7 - Sets and Playlists

- Full playlist CRUD: create, edit, and delete collections of tracks
- Track reordering and Add/Remove functionality
- Secret and Public playlist privacy with unique shareable secret tokens
- Embed code generation for sharing playlists externally via iframe

### Module 8 - Feed, Search, and Discovery

- Chronological activity feed of new tracks from followed artists
- Permalink resolver to convert standard URLs into internal resource IDs
- Global search across Tracks, Users, and Playlists using keyword matching
- Trending and Charts discovery based on recent play counts and engagement velocity

### Module 9 - Messaging and Track Sharing

- 1-to-1 direct messaging between users
- Embeddable track and playlist preview cards within message threads
- Unread message counters and per-message blocking rules

### Module 10 - Real-Time Notifications

- Instant activity alerts for new Followers, Likes, Reposts, and Comments
- Global Mark as Read and unread notification counter
- Mobile push notification support for time-sensitive social actions

### Module 11 - Moderation and Admin Dashboard

- User-facing report flags for Copyright and Inappropriate Content
- Admin panel with tools to hide or remove tracks and suspend accounts
- Platform analytics: total active users, play-through rates, and storage usage

### Module 12 - Premium Subscription (Pro/Go+)

- Upload limit enforcement (3 tracks for Free users, unlimited for Pro)
- Mocked Stripe payment processing for subscription lifecycle management
- Ad-free experience and mocked Offline Listening (download) capabilities

---

## Architecture

The project follows **Clean Architecture** with a **feature-first folder structure**.

Each feature module is split into three layers with strict dependency rules:

| Layer        | Responsibility                                                                 | Dependencies          |
|--------------|--------------------------------------------------------------------------------|-----------------------|
| Presentation | Screens and reusable widgets. Consumes domain layer only.                      | Domain only           |
| Domain       | Business entities and abstract repository contracts. Innermost layer.          | None                  |
| Data         | Data sources, DTOs, and repository implementations. Implements domain contracts.| Domain only           |

### Key Design Patterns

- **State Management** — Riverpod with `Notifier` / `AsyncNotifier`. Widgets use `ConsumerWidget` or `Consumer` to limit rebuilds. `AsyncValue.when()` handles loading, error, and data states.
- **Dependency Injection** — GetIt with Injectable annotations (`@lazySingleton`, `@injectable`). GetIt is never called directly in widgets; it is bridged through Riverpod providers.
- **Networking** — Dio with a centralized `DioClient`. Interceptors handle authorization tokens and logging.
- **Routing** — GoRouter with `ShellRoute` for persistent layouts. All route paths are centralized in a static `RoutePaths` class.
- **Two-Tier Error Handling** — Data sources throw typed `AppException` subclasses. Repositories catch them and return typed `Failure` objects so raw exceptions never reach the UI.
- **Data Models** — DTOs are generated with Freezed for immutability and JSON serialization.

---

## Tech Stack

| Category              | Package / Tool                          |
|-----------------------|-----------------------------------------|
| Framework             | Flutter 3.41.6 (managed via FVM)        |
| Language              | Dart 3.x                                |
| State Management      | flutter_riverpod                        |
| Routing               | go_router                               |
| Dependency Injection  | get_it, injectable                      |
| Networking            | dio, web_socket_channel                 |
| Data Modeling         | freezed, json_annotation, dartz         |
| Audio Playback        | just_audio, just_audio_windows          |
| Waveform              | audio_waveforms, flutter_soloud         |
| Secure Storage        | flutter_secure_storage                  |
| Local Storage         | hive, hive_flutter, shared_preferences  |
| Auth                  | google_sign_in, flutter_dotenv          |
| Media                 | image_picker, file_picker, croppy       |
| Code Generation       | build_runner, freezed, json_serializable, injectable_generator |
| Testing               | mocktail                                |

---

## Project Structure

```
lib/
├── app.dart               # Root app widget and initialization
├── main.dart              # Entry point
├── core/                  # Shared infrastructure (DI, routing, theming, networking, error handling)
└── features/
    ├── auth/              # Authentication and account management
    ├── engagement/        # Likes, reposts, comments
    ├── feed/              # Activity feed (Discover and Following)
    ├── home/              # Home screen and quick actions
    ├── library/           # Personal collection, uploads, and insights
    ├── library_profile/   # Public and creator profile pages
    ├── player/            # Persistent audio player
    ├── playlists/         # Playlist management (Sets)
    ├── search/            # Global search and genre discovery
    ├── settings/          # Account and app settings
    ├── upgrade/           # Premium subscription paywall
    └── upload/            # Audio upload flow
```

---

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) SDK (see `.fvmrc` for the pinned version)
- [FVM](https://fvm.app/) (Flutter Version Management) — recommended
- Dart SDK `^3.10.8`
- A configured `.env` file (see [Environment Setup](#environment-setup))

### Install FVM and the pinned Flutter version

```bash
dart pub global activate fvm
fvm install
fvm use
```

### Install dependencies

```bash
flutter pub get
```

---

## Environment Setup

Copy the example environment file and fill in the required values:

```bash
cp .env.example .env
```

| Variable                   | Description                                  |
|----------------------------|----------------------------------------------|
| `USE_MOCK_SERVICES`        | Set to `true` to use mock data sources       |
| `API_BASE_URL`             | Base URL for the backend REST API            |
| `GOOGLE_MOBILE_CLIENT_ID`  | Google OAuth client ID for mobile platforms  |
| `GOOGLE_DESKTOP_CLIENT_ID` | Google OAuth client ID for desktop platforms |
| `RECAPTCHA_SITE_KEY`       | reCAPTCHA v2 site key for registration forms |

---

## Running the App

```bash
# Run on a connected device or emulator
flutter run

# Run on a specific platform
flutter run -d chrome        # Web
flutter run -d windows       # Windows desktop
flutter run -d android       # Android
flutter run -d ios           # iOS
```

---

## Code Generation

Several packages require build_runner for code generation. Run the following command after modifying any Freezed models, JSON serialization, or Injectable registrations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Code Quality

The project enforces zero-warning code quality standards.

```bash
# Static analysis
flutter analyze

# Format all Dart files
dart format .
```

### Conventions

- Files and folders use `snake_case`
- Classes and enums use `PascalCase`
- Variables, functions, and constants use `camelCase`
- Private members are prefixed with `_`
- Riverpod providers are named with a `Provider` suffix (e.g., `currentTrackProvider`)
- No `print()` statements in production code
- No hardcoded strings, colors, or magic numbers
- All imports are ordered: Dart SDK, Flutter SDK, third-party packages, project imports
