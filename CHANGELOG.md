# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] — 2026-11-29

### Added
- **Tagalog Responsive Readings Content Pipeline & Reader (`TASK-20261129-vy1`)**:
  - Added `ResponsiveReadingParser` (`lib/core/readings/responsive_reading_parser.dart`) and build-time ingestion in `tool/build_content.dart` to parse and strictly validate all 57 Tagalog responsive readings (571 lines) from `raw_content/Tagalog Responsive Readings.md`.
  - Added `ResponsiveReadings` and `ResponsiveReadingLines` Drift tables (`schemaVersion` `2`) and rebuilt `assets/db/hymns.db` (`PRAGMA user_version = 2`), preserving existing ChordPro hymn data and validation reports.
  - Added `ReadingsListScreen` (`"Tugunang Pagbasa"`) with real-time trimmed number and diacritic-normalized title filtering and `ReadingDetailScreen` featuring the Tagalog Sanctuary Gold palette, `WakelockPlus`, role-formatted lines (`leader`, `people`, `all`), `A-`/`A+` text-size bounds and persistence (`12.0`–`28.0`), sequential previous/next navigation with scroll reset, and missing-reading fallback.
  - Affected files: `raw_content/Tagalog Responsive Readings.md`, `lib/core/readings/responsive_reading_parser.dart`, `lib/data/database/app_database.dart`, `lib/data/database/app_database.g.dart`, `tool/build_content.dart`, `assets/db/hymns.db`, `lib/features/readings/`, `lib/main.dart`, `test/core/responsive_reading_parser_test.dart`, `test/features/readings_screens_test.dart`, `test/data/database_integrity_test.dart`

### Changed
- **Home Screen Navigation Redesign & Cache Sync (`TASK-20261129-vy1`)**:
  - Consolidated separate English/Tagalog hymn cards into a single `"Hymns"` `CatalogCard` showing the unique hymn count (`173`) and opening the Hymn Index on `IndexTab.all`, added the `"Tugunang Pagbasa"` navigation card and disabled `"Westminster Shorter Catechism"` (`"Coming soon"`) placeholder card, and removed the AppBar `"Hymn Index"` icon button while keeping Home search hymns-only.
  - Extended `CatalogCard` with optional count, styled badge pill (`badgeBackgroundColor`/`badgeTextColor`), and disabled visual/semantic state; removed stale `520`/`380` defaults from `CatalogStats` and `HomeRepository`.
  - Bumped `kAppDbVersion` to `4` in `lib/data/database/connection/connection_native.dart` so existing installs refresh cached SQLite assets.
  - Affected files: `lib/features/home/domain/models/catalog_stats.dart`, `lib/features/home/data/home_repository.dart`, `lib/features/home/presentation/widgets/catalog_card.dart`, `lib/features/home/presentation/home_screen.dart`, `lib/data/database/connection/connection_native.dart`, `test/features/screens_test.dart`, `test/widget_test.dart`

## [0.3.0] — 2026-11-26

### Added
- **Complete 173-Hymn Musical Chord Catalog (`PR #11`)**:
  - Annotated all 173 English hymns (`content/en/001.cho`–`173.cho`) and all 115 Tagalog hymns (`content/tl/001.cho`–`115.cho`) with ChordPro chord progressions.
  - Validated 11,225 musical chord tokens across 288 hymn texts with 0 syntax or verse continuity anomalies.
- **Traditional Hymnal Concert Key Alignment (`PR #12`)**:
  - Aligned Hymns `#002` and `#011`–`#173` (EN & TL pairs) to their traditional hymnal keys (`G`, `Eb`, `Ab`, `F`, `Bb`, `D`, `C`, `Db`) with proper enharmonic spelling and 100% EN/TL key parity.

### Changed
- **Android App Display Label (`PR #12`)**:
  - Updated `android:label` in `android/app/src/main/AndroidManifest.xml` from `presby_hymns` to `Presbyterian Hymns`.
- **Database Asset & Cache Invalidation**:
  - Rebuilt `assets/db/hymns.db` with the full 288-text chord catalog and FTS5 index.
  - Bumped `kAppDbVersion` to `3` in `lib/data/database/app_database.dart` so existing installs automatically refresh their local database cache.
- **Build & Tooling (`PR #11`)**:
  - Bumped Android Gradle Plugin (AGP) to `9.1.1` in `android/settings.gradle.kts` for Flutter stable compatibility.

## [0.2.0] — 2026-10-19

### Added
- **Draft 1 App Branding & Adaptive Launcher Icons (`TASK-20261018-8d1`)**:
  - Implemented approved Draft 1 branding icon across Android adaptive launcher mipmap densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`) with pure white background (`#FFFFFF`), solid blue cross (`#004AAD`), radiant sunburst rays (`#FED65B`), and gold accent (`#D4AF37`).
  - Updated `HeroBanner` (`lib/features/home/presentation/widgets/hero_banner.dart`) to render high-resolution Draft 1 branding asset `assets/images/app_logo.png` with graceful church icon fallback.
  - Affected files: `android/app/src/main/res/`, `assets/images/app_logo.png`, `lib/features/home/presentation/widgets/hero_banner.dart`
- **100% Offline Typography Asset Bundling (`TASK-20261018-8d1`)**:
  - Physically bundled 11 TrueType Font files in `assets/fonts/` for Space Grotesk, Source Serif 4, and Inter across standard weights (regular, italic, medium, bold).
  - Declared local font families and assets in `pubspec.yaml`, ensuring 100% offline rendering with zero network/CDN dependencies.
  - Affected files: `assets/fonts/`, `pubspec.yaml`
- **Audio Cue Tone Generator & Direct Asset Playback (`TASK-20261018-8d1`)**:
  - Added standalone CLI synthesis tool `tool/render_cue_tones.dart` generating 12 equal-temperament chromatic OGG tones spanning C4–B4 with raised-cosine click-free amplitude envelope ramps.
  - Updated `CueBar` (`lib/features/reader/widgets/cue_bar.dart`) for resilient direct asset playback, removing synthetic delays and adding non-blocking SnackBar error feedback.
  - Affected files: `tool/render_cue_tones.dart`, `assets/audio/cue/`, `lib/features/reader/widgets/cue_bar.dart`
- **Strict Content Integrity Checker Tooling (`TASK-20261018-8d1`)**:
  - Implemented `tool/build_content.dart` validation pass verifying BUG-008 chord regex, contiguous verse numbering (1..N), bilingual EN/TL key matching, and BUG-005 raw ChordPro preservation before compiling `assets/db/hymns.db`.
  - Added automated Markdown reporting to `build/content-report.md`.
  - Corrected verse continuity anomalies in `content/en/038.cho`, `082.cho`, `121.cho`, and `169.cho`.
  - Affected files: `tool/build_content.dart`, `build/content-report.md`, `assets/db/hymns.db`, `content/en/`
- **Distribution Documentation Standardization (`TASK-20261018-8d1`)**:
  - Removed all references to Firebase App Distribution across project documentation, standardizing test APK distribution on GitHub Actions CI artifact (`presby-hymns-apk`) on PRs (GUARD-006) and GitHub Releases (`v*` tags).
  - Affected files: `docs/01-project-overview.md`, `docs/02-technical-architecture.md`, `docs/03-implementation-plan.md`
- **Musical Chord Token Regex Integrity Verification (`TASK-20261018-8c1`)**:
  - Enforced musical chord token validation in `test/data/database_integrity_test.dart` against `^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$` for all hymns with chord annotations.

### Changed
- **Database Asset Cache Invalidation (`TASK-20261018-8c1`)**:
  - Added `kAppDbVersion` and `SharedPreferences` version tracking to `AppDatabase` (`lib/data/database/app_database.dart`), automatically invalidating and reloading bundled assets whenever the content version advances without redundant asset reads.
- **Universal Key Transposition (`TASK-20261018-8c1`)**:
  - Decoupled key transposition controls (`-1`, `+1`, key picker, reset) in `SongControlsToolbar` from `hasChords == 1`, enabling tonic pitch cues and vocal transposition across all hymns (including lyrics-only Tagalog hymns).
  - Maintained strict chord gating (`hasChords == 1`) for Capo selection, CAGED voicings, and the Hide Chords toggle.
  - Updated toolbar header summary text to format `'Key $soundingKey • Text Size ...'` on lyrics-only hymns.
  - Added comprehensive widget test in `test/features/screens_test.dart` verifying Tagalog hymn key transposition.

## [0.1.0-m1] — 2026-10-17

### Added
- **Milestone 1 Core Screens (`TASK-20261017-8b2`)**:
  - **Home Screen**: Presbyterian Blue hero branding (`#002F6C`), 150ms debounced search with exact numeric matching and FTS5 full-text lookup, grouped English and Tagalog search results dropdown, and live catalog counts.
  - **Index Screen**: Comprehensive hymn index with "All Hymns", "English", and "Tagalog" filtering tabs; numeric and title alphabetical sorting; sticky A-Z jump rail on title sort; "EN ONLY" badges for untranslated hymns; and dedicated "Unnumbered Songs" section for liturgical items.
  - **Hymn Reader Screen**: Reader canvas with language-based background tinting (`#FBF9F5` for English, `#F5EFE6` for Tagalog); synchronized ChordPro chord-over-lyric layout; collapsible song controls toolbar with semitone transposition, Capo selector (0–7), CAGED voicings, font resizing (default 19px), and "Hide Chords" toggle; bottom slim pitch cue bar sounding tonic pitch; screen wake lock management via `wakelock_plus`; and empty state fallback view.
  - **Test Suite**: Widget and integration test suite covering Home, Index, and Reader screen criteria in `test/features/screens_test.dart`.
