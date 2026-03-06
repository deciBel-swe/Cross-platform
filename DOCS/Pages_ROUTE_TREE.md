# Route Tree

```text

├─ /feed
│  ├─ /discover
│  └─ /following
├─ /home
│  ├─ /cast
│  ├─ /messages
│  ├─ /notifications
│  └─ /upload
│  └─ /your-likes
├─ /library
│  ├─ /albums
│  ├─ /following
│  ├─ /likes
│  ├─ /playlists
│  ├─ /stations
│  ├─ /uploads
│  └─ /your-insights
│     ├─ /dont-have-uploads
│     └─ /have-uploads
├─ /library-profile
│  ├─ /playlists
│  ├─ /tracks
│  └─ /your-insights
│     ├─ /dont-have-uploads
│     └─ /have-uploads
├─ /library-settings
│  ├─ /account
│  ├─ /add-widget
│  ├─ /advertising
│  ├─ /analytics
│  ├─ /basic-settings
│  ├─ /communications
│  ├─ /import-music
│  ├─ /inbox
│  ├─ /legal
│  ├─ /notifications
│  ├─ /social-settings
│  ├─ /support
│  └─ /your-insights
│     ├─ /dont-have-uploads
│     └─ /have-uploads
├─ /login-create-account
├─ /player
├─ /search
│  ├─ /electronic
│  ├─ /hip-hop
│  ├─ /pop
│  └─ /search-box
└─ /upgrade
```

## Page descriptions

- `/feed` — Activity feed hub that recommends listening activity in a scrollable discovery-style stream.
  - `/feed/discover` — Feed view focused on broader discovery, showing recommended creators, tracks, or activity beyond strictly followed accounts.
  - `/feed/following` — Feed filtered to updates from followed users and accounts the listener already follows.

- `/home` — Main landing page of the app with personalized recommendations, quick actions, trending picks, and shortcuts to upload, inbox, and notifications. the page shows personalized recommendations such as likes, mixes, picks, and playable tracks.
  - `/home/cast` — Device casting entry where playback can be sent to available cast targets.
  - `/home/messages` — Inbox/messages page for direct conversations and communication-related activity.
  - `/home/notifications` — Notification center for follows, likes, reposts, comments, and other account activity.
  - `/home/upload` — Home state with the upload shortcut visible in the toolbar and entry point to the upload flow.
  - `/home/your-likes` — Page showing tracks that the user has liked.

- `/library` — Personal collection hub where the user manages saved music, followed artists, playlists, uploads, and creator tools.
  - `/library/albums` — Saved or collected albums list.
  - `/library/following` — List of artists and users the account follows.
  - `/library/likes` — Liked tracks collection (`Your likes`).
  - `/library/playlists` — User playlists and curated playlist collections.
  - `/library/stations` — Station-based listening area for radio-style recommendations.
  - `/library/uploads` — User-uploaded tracks list (`Your uploads`).
  - `/library/your-insights` — Creator analytics dashboard with overview, track, and audience metrics.
    - `/library/your-insights/dont-have-uploads` — Empty analytics state shown when the account has no uploads yet.
    - `/library/your-insights/have-uploads` — Analytics state populated for an account that already has uploaded tracks.

- `/library-profile` — Public/creator profile page showing avatar, bio, following counts, spotlight content, profile actions, and track highlights.
  - `/library-profile/playlists` — Profile subpage for playlists published or curated by the profile owner.
  - `/library-profile/tracks` — Profile subpage focused on the creator’s full track list.
  - `/library-profile/your-insights` — Profile-linked creator insights view with Overview, Tracks, and Audience analytics.
    - `/library-profile/your-insights/dont-have-uploads` — Empty creator-insights state when no tracks have been uploaded.
    - `/library-profile/your-insights/have-uploads` — Creator-insights state showing performance metrics for uploaded tracks.

- `/library-settings` — Main settings hub for account management, upload tools, analytics access, notifications, privacy, support, and legal pages.
  - `/library-settings/account` — Account management page with email address, sign out, and delete account actions.
  - `/library-settings/add-widget` — Settings area for adding SoundCloud widgets or app widgets.
  - `/library-settings/advertising` — Advertising preferences or promotional settings area.
  - `/library-settings/analytics` — Analytics-related settings or entry point for performance/reporting tools.
  - `/library-settings/basic-settings` — General app preferences such as clearing cache, changing language, and switching the app icon.
  - `/library-settings/communications` — Communication preferences for emails and related account contact settings.
  - `/library-settings/import-music` — Music import entry for bringing existing audio into SoundCloud.
  - `/library-settings/inbox` — Inbox-related settings or management entry.
  - `/library-settings/legal` — Legal information such as terms, policies, and related notices.
  - `/library-settings/notifications` — Granular notification controls for followers, reposts, comments, recommended content, messages, and promotional updates.
  - `/library-settings/social-settings` — Social/privacy controls for waveform comments, discovery visibility, and First/Top Fan visibility.
  - `/library-settings/support` — Support/help entry point for troubleshooting and contacting SoundCloud support.
  - `/library-settings/your-insights` — Settings entry to creator insights and analytics tools.
    - `/library-settings/your-insights/dont-have-uploads` — Empty insights state from settings when there are no uploads yet.
    - `/library-settings/your-insights/have-uploads` — Insights state from settings for accounts with uploaded content.

- `/login-create-account` — Authentication area covering login, OAuth sign-in, forgot password, and account creation flows, based on the available login screen captures.

- `/player` — Mini-player/persistent playback surface that keeps the current track accessible with play/pause, like, follow, and quick now-playing controls while browsing the app.

- `/search` — Search landing page with a large search field and browsable mood/genre tiles such as Hip Hop & Rap, Electronic, Pop, Chill, Party, Techno, and Workout.
  - `/search/electronic` — Genre detail page for Electronic with tabs like All, Trending, Playlists, and Albums plus featured trending tracks.
  - `/search/hip-hop` — Genre detail page for Hip Hop & Rap with trending tracks and category-based browsing.
  - `/search/pop` — Genre detail page for Pop with trending tracks and category-based browsing.
  - `/search/search-box` — Focused search-input state prompting the user to search SoundCloud for artists, tracks, albums, and playlists.

- `/upgrade` — Subscription/paywall page promoting Artist Pro, highlighting unlimited uploads and creator tools, with pricing and upgrade buttons.
