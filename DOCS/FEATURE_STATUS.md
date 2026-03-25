# Feature status snapshot

This document summarizes the current implementation state of the Decibel Flutter app based on the code in this workspace.

## 1) Authentication and sessions

### Implemented

- JWT session handling is in place through secure storage and an auth interceptor.
- Access tokens are attached to API calls, refresh tokens are used for automatic renewal, and expired sessions are cleared on failure.
- Google sign-in exists in the auth flow and stores token pairs in secure storage.
- Mock auth supports development mode and can be switched on from `.env`.

### Partial

- The login screen has the email/password form, but the main Continue button is still disabled pending local or web auth wiring.
- The register screen has the form shell, but Google/Facebook/Apple actions are still placeholders.

### Not yet wired in the front end

- Forgot password flow.
- Email verification / resend verification flow.
- A full local email/password registration submit flow.

### Code evidence

- Session refresh and bearer attachment: `lib/core/network/interceptors/auth_interceptor.dart`
- Secure token persistence: `lib/core/storage/secure_storage_service.dart`
- Google login flow: `lib/features/auth/data/repositories/auth_repository.dart`
- Mock/dev auth path: `lib/features/auth/data/repositories/mock_auth_repository.dart`
- Login/register screens: `lib/features/auth/presentation/screens/login_screen.dart`, `lib/features/auth/presentation/screens/register_screen.dart`

## 2) Profile

### Implemented

- Profile editing already supports bio, city, country, favorite genres, social links, and avatar/cover uploads.
- Public profile pages render profile imagery, location, social links, spotlight content, and top tracks.
- External links are supported for Instagram, Twitter/X, website, and additional social platforms in the model layer.
- Public/private visibility exists through social settings and profile privacy fields.

### Partial

- The UI currently exposes bio, city, and country, but there is no separate editable display-name field yet.
- The account identity is represented by `username` and `role`/`tier` metadata, not by an explicit Artist/Listener toggle.

### Code evidence

- Edit profile screen: `lib/features/library_profile/presentation/screens/edit_profile_screen.dart`
- Avatar/cover upload UI: `lib/features/library_profile/presentation/widgets/profile_image_header.dart`
- Favorite genres selector: `lib/features/library_profile/presentation/widgets/genre_selector.dart`
- Social links UI: `lib/features/library_profile/presentation/widgets/social_links_widget.dart`
- Profile model: `lib/features/library_profile/domain/entities/user_profile.dart`
- Mock profile data: `lib/features/library_profile/data/repositories/mock_profile_repository_impl.dart`

## 3) Uploads, spotlight, and waveform generation

### Implemented

- Track upload supports metadata, privacy, tags, cover image, and audio file selection.
- Waveform extraction runs during upload and again in the background after submit.
- Mock upload flow creates a `PROCESSING` track first, then flips it to `FINISHED` after a delay.
- Uploaded tracks refresh into the profile/library views and can appear in the spotlight / top-tracks area.

### Code evidence

- Upload state and waveform extraction: `lib/features/upload/presentation/providers/upload_notifier.dart`
- Upload metadata model: `lib/features/upload/domain/entities/track_upload_metadata.dart`
- Mock upload repository: `lib/features/upload/data/repository/mock_upload_repository_impl.dart`
- Spotlight section on profile: `lib/features/library_profile/presentation/screens/profile_screen.dart`
- Waveform preview widgets: `lib/features/library_profile/presentation/widgets/track_preview_waveform_section.dart`

## 4) Desktop and mobile UI separation

### Implemented

- The app uses responsive breakpoints for mobile, tablet, and desktop.
- The main shell switches between a desktop layout and a mobile layout.
- Desktop uses a sidebar, top header, and desktop player bar.
- Mobile uses bottom navigation.
- Several feature screens also branch their layouts based on screen width.

### Code evidence

- App breakpoints: `lib/app.dart`
- Main shell: `lib/core/router/main_shell.dart`
- Desktop header/sidebar: `lib/core/router/desktop_header.dart`, `lib/core/router/desktop_sidebar.dart`
- Desktop player bar: `lib/features/player/presentation/widgets/desktop_player_bar.dart`
- Responsive feature screens: `lib/features/auth/presentation/screens/start_screen.dart`, `lib/features/home/presentation/screens/home_screen.dart`, `lib/features/feed/presentation/screens/feed_screen.dart`, `lib/features/search/presentation/screens/search_screen.dart`, `lib/features/library/presentation/screens/library_screen.dart`

## 5) Settings and app icon changes

### Implemented

- The settings area includes a dedicated app icon selector.
- Desktop icons are applied from assets and persisted through the app icon repository.
- Basic settings exposes the app icon entry point.

### Code evidence

- App icon screen: `lib/features/settings/presentation/screens/change_app_icon_screen.dart`
- Basic settings screen: `lib/features/settings/presentation/screens/basic_settings_screen.dart`
- App icon repository: `lib/features/settings/data/repositories/app_icon_repository_impl.dart`

## 6) Mock configuration from `.env`

### Implemented

- `main.dart` reads `.env` and uses `USE_MOCK_SERVICES` to choose mock or production dependencies.
- Mock repositories exist for auth, profile, upload, and social settings.

### Code evidence

- Environment bootstrapping: `lib/main.dart`
- Mock auth repository: `lib/features/auth/data/repositories/mock_auth_repository.dart`
- Mock profile repository: `lib/features/library_profile/data/repositories/mock_profile_repository_impl.dart`
- Mock upload repository: `lib/features/upload/data/repository/mock_upload_repository_impl.dart`

## 7) Current gaps to finish later

- Add full login, registration, forgot password, and email verification screens/flows.
- Add an explicit editable display-name field if username is not intended to be the display name.
- Add a real Artist/Listener account-type selector if that is meant to be separate from membership tier.
- Wire the remaining social buttons and finalize OAuth handling for all target platforms.
- Decide whether profile visibility should be controlled from profile editing, social settings, or both.

## Short implementation summary

The app already has a strong base for:

- JWT + refresh-token session persistence,
- Google social login scaffolding,
- profile editing with genres, bio, location, avatar, cover, and social links,
- upload + waveform generation,
- responsive desktop/mobile layouts,
- and app-icon switching.

The main unfinished parts are the front-end auth flows for registration, password recovery, email verification, and the explicit Artist/Listener account-type UI.
