# Presby Hymns — Bilingual Presbyterian Hymnal & Musician's Chord Workbench

> **Presby Hymns** is an offline-first, bilingual (English & Tagalog) hymnal application tailored for Presbyterian congregations, choir directors, and church musicians. It unifies the English Hymnal (520 numbered hymns) and the Tagalog Himnaryo (380 numbered hymns) under **one unified numbering scheme matching the physical printed hymnals**, alongside unnumbered liturgical songs. Built with the artisan **Sanctuary Psalter** design language, editorial serif typography, instant FTS5 offline search, and a musician's chord workbench.

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square&logo=dart)](https://dart.dev/)
[![Riverpod](https://img.shields.io/badge/State-flutter__riverpod_3-blue?style=flat-square)](https://riverpod.dev/)
[![Drift & SQLite](https://img.shields.io/badge/Database-Drift_%2B_FTS5-orange?style=flat-square&logo=sqlite)](https://drift.simonbinder.eu/)
[![Platform](https://img.shields.io/badge/Platform-Android_(Offline--First)-3DDC84?style=flat-square&logo=android)](https://www.android.com/)
[![Tests](https://img.shields.io/badge/Tests-Passing_(15/15)-brightgreen?style=flat-square)](./test)

---

## ✨ Features

### 📖 Unified Bilingual Hymnal Catalog
- **Exact Printed Book Alignment**: Hymn numbering directly mirrors the printed Presbyterian hymnal (English 1–520, with Tagalog providing a 380-hymn 1-to-1 matching counterpart).
- **Instant Language Switcher**: Switch effortlessly between English and Tagalog within the reader while maintaining position and key context.
- **Atmospheric Canvas Tints**: Distinct parchment backgrounds signal active language context (`#FBF9F5` for English, `#F5EFE6` for Tagalog).
- **Unnumbered Liturgical Songs**: Dedicated catalog section for doxologies, choral responses, and communion songs.
- **Dual Catalog & Index Views**: Filter by *All Hymns*, *English*, or *Tagalog*, sorted by hymn number or alphabetical title with a sticky A–Z jump rail. "EN ONLY" badges clearly denote hymns awaiting Tagalog translation.

### 🎸 Musician's Chord Workbench
- **Real-Time Transposition**: Shift musical keys up or down chromatic semitones (`-1`, `+1`, key picker modal, and instant reset) with enharmonic spelling and slash chord awareness.
- **Universal Vocal Transposition**: Key adjustments and tonic pitch cues operate across all hymns—including lyrics-only Tagalog hymns without chord transcriptions.
- **Capo Calculation & Chord Shapes**: Select capo positions (0–7) with dynamic chord shape calculations (e.g., Key C with Capo 3 displays **A** shapes).
- **CAGED Voicing Shortcuts**: 1-tap capo preset buttons (`C`, `A`, `G`, `E`, `D`) for acoustic guitarists, intelligently disabling fingerings exceeding fret 7.
- **Persistent Preferences**: Transposed keys and capo positions are remembered per hymn across app restarts via `SharedPreferences`.
- **Dynamic Font Scaling & Hide Chords**: Global font scaling (12px to 28px) with a dedicated "Hide Chords" toggle for singers and choir members.

### 🔍 Instant Offline FTS5 Search
- **Sub-50ms Query Performance**: Powered by an embedded SQLite FTS5 index compiled at build time.
- **Exact Hymn Number Matching**: Pure numeric search instantly isolates matching English and Tagalog hymns without clutter.
- **Keyword & Lyric Search**: 150ms debounced search scanning titles, first lines, and full lyrics while ignoring chord markers, syllable hyphens, and Tagalog diacritics/accents.
- **Grouped Search Dropdown**: Categorizes instant matches into `ENGLISH HYMNS` and `TAGALOG HIMNARYO` result cards.

### 🎵 Key CUE Tonic Pitch Pipe
- **Tonic Reference Audio**: Slim docked Cue Bar (`[♪ Eb Cue]`) sounds a 2-second tonic reference tone (octave 4) in the hymn's active key to aid worship leaders and choir soloists.
- **Independent Cue Key Picker**: Audition alternative starting pitches with a safety confirmation dialog when the cue key deviates from the chord key.

### 🛡️ Offline-First & Sanctuary-Ready
- **100% Offline Autonomy**: Operates entirely in airplane mode with zero network access required.
- **Pre-Compiled Content Database**: Pre-seeded SQLite database (`assets/db/hymns.db`) with automatic version cache invalidation (`kAppDbVersion`) ensuring seamless content updates.
- **Zero Distractions & Privacy**: No user accounts, zero analytics tracking, and no external advertising.
- **Screen Wake Lock**: Automatically prevents the sanctuary device screen from sleeping while the Hymn Reader is open.
- **One-Tap Problem Reporting**: Pre-formatted `mailto:` generator capturing hymn metadata, key, capo, and app version, with automatic clipboard fallback.

### 🎨 Sanctuary Psalter Design System
- **Presbyterian Palette**: Dignified heritage palette featuring Presbyterian Blue (`#002F6C` / `#00357F`), warm parchment tones, and rich gold accents.
- **Sacred Typography**: Editorial typography pairing *Space Grotesk* for hero banners and navigation with *Source Serif 4* for WCAG AAA lyric readability and *Inter* for functional UI controls.

---

## 🛠️ Tech Stack

| Layer | Technology | Details |
|---|---|---|
| **Framework** | [Flutter 3.13+](https://flutter.dev/) | Cross-platform framework with Dart null safety |
| **State Management** | [flutter_riverpod 3](https://riverpod.dev/) | Compile-safe state management (`Notifier` / `AsyncNotifier`) |
| **Local Database & FTS** | [Drift 2.35](https://drift.simonbinder.eu/) & [sqlite3](https://pub.dev/packages/sqlite3) | Type-safe persistence with SQLite FTS5 full-text search |
| **Audio Pitch Pipe** | [audioplayers 6.8](https://pub.dev/packages/audioplayers) | Low-latency audio playback for tonic pitch cues |
| **Screen Management** | [wakelock_plus](https://pub.dev/packages/wakelock_plus) | Prevents screen timeout during church service reader mode |
| **User Preferences** | [shared_preferences 2.5](https://pub.dev/packages/shared_preferences) | Stores per-hymn key/capo choices and global text scaling |
| **Typography** | Bundled TTF Assets | Offline *Space Grotesk*, *Source Serif 4*, and *Inter* fonts |
| **Testing** | [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) | Unit, widget, and database integrity test suites |
| **Content Pipeline** | Dart CLI & Python | Custom ChordPro compilation and Google Docs ingestion tools |

---

## 📂 Project Structure

```
presby-hymns/
├── assets/                     # Packaged static assets
│   ├── audio/cue/              # Pre-rendered tonic pitch pipe audio files (C4.ogg … B4.ogg)
│   ├── db/hymns.db             # Pre-compiled SQLite database with FTS5 virtual tables
│   └── fonts/                  # Bundled Space Grotesk, Source Serif 4, and Inter fonts
├── content/                    # Authored source files (ChordPro format)
│   ├── en/                     # English hymns (001.cho … 520.cho)
│   ├── tl/                     # Tagalog Himnaryo (001.cho … sparse 1-to-1 counterpart)
│   └── extra/                  # Unnumbered liturgical songs and responses
├── docs/                       # Project specifications & architecture documentation
│   ├── 01-project-overview.md  # Scope, personas, and decision log (D1–D25)
│   ├── 02-technical-architecture.md # System architecture, database schema, and Riverpod graph
│   ├── 03-implementation-plan.md    # Multi-phase milestone execution plan
│   ├── 04-design-alignment.md       # Visual design reconciliation notes
│   └── design/DESIGN.md        # "Sanctuary Psalter" design tokens, colors & typography
├── lib/
│   ├── app/                    # Application shell, routing, and theme definitions
│   ├── core/                   # Pure Dart domain logic (unit tested)
│   │   ├── chordpro/           # AST parser for ChordPro directives and chord tokens
│   │   ├── music/              # Transposition math, CAGED capo resolver & key speller
│   │   └── search/             # Accent stripper, hyphen normalizer & FTS query builder
│   ├── data/                   # Data access layer
│   │   ├── database/           # Drift database client (`AppDatabase`) & schema
│   │   └── repositories/       # Hymn catalog repository & SharedPreferences storage
│   └── features/               # Presentation layer screens & Riverpod providers
│       ├── home/               # Hero banner, live search dropdown, and catalog cards
│       ├── index/              # Filter tabs (All/EN/TL), sort toggle & A–Z jump rail
│       └── reader/             # Lyrics canvas, SongControlsToolbar, and CueBar
├── tasks/                      # Project task specifications (TASK-NNN.md)
├── test/                       # Unit, widget, and database regression tests
│   ├── core/                   # Parser, music transposition, and search normalizer tests
│   ├── data/                   # Database integrity and regex chord token verification
│   └── features/               # Widget tests for Home, Index, and Reader screens
├── tool/                       # Build tools & content compilers
│   ├── build_content.dart      # Compiles raw ChordPro files into assets/db/hymns.db
│   └── import_gdoc.py          # Google Docs raw hymnal text importer & parser
├── CHANGELOG.md                # Release history and milestone implementation logs
├── CLAUDE.md                   # AI agent conventions and multi-agent workflow guide
├── MEMORY.md                   # Root cause learnings and architectural decisions
└── pubspec.yaml                # Flutter project dependencies and asset registrations
```

---

## 🎼 ChordPro Content Format

Hymn lyrics and chords are authored using clean ChordPro notation (`.cho`). Metadata directives specify hymn numbers, titles, and original musical keys, while bracketed chords are placed directly over corresponding lyric syllables:

```text
{number: 1}
{title: Doxology}
{key: G}

{start_of_verse: 1}
[G] Praise God,
From whom all blessings flow
[G] Praise Him,
[C][D] All creatures here below
[E][D] Praise Him above,
[C][D][Em] Ye heav’nly host
[G] Praise Father,
[D][C][D][G] Son and Holy Ghost.
Amen.
{end_of_verse}
```

### Supported Directives
- `{number: N}` — Hymn number matching the printed hymnal (omitted for unnumbered songs)
- `{title: Title}` — Hymn title
- `{key: Key}` — Original key of the hymn (`C`, `G`, `Eb`, `F#m`, etc.)
- `{meter: Meter}` — Poetic meter (e.g., `L.M.`, `8.7.8.7.D.`)
- `{author: Name}` / `{translator: Name}` / `{year: Year}` — Historical hymn metadata
- `{start_of_verse: N}` / `{end_of_verse}` — Verse block grouping
- `{start_of_chorus}` / `{end_of_chorus}` — Refrain / Koro blocks (rendered after every verse)

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.13.5` or later
- **Dart SDK**: `^3.0.0` or later
- **Android Studio / Android SDK**: Configured for local emulator or physical device testing

### 1. Clone the Repository
```bash
git clone https://github.com/James2898/presby-hymns.git
cd presby-hymns
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code Artifacts (Optional)
If modifying Drift database schemas or Riverpod models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Compile the Hymnal Content Database
Compile the ChordPro source files in `content/` into the bundled SQLite database (`assets/db/hymns.db`):
```bash
dart run tool/build_content.dart
```

### 5. Launch the Application
Start the app on an Android device or emulator:
```bash
flutter run
```

---

## 📜 Available Commands

| Command | Description |
|---|---|
| `flutter run` | Starts the app in debug mode on a connected device or emulator |
| `flutter test` | Executes the complete test suite (unit, widget, database integrity) |
| `dart run tool/build_content.dart` | Parses `content/` `.cho` files and builds `assets/db/hymns.db` |
| `dart run build_runner build` | Runs code generation for Drift and dependencies |
| `flutter analyze` | Runs static code analysis against `analysis_options.yaml` |
| `flutter build apk --split-per-abi` | Builds optimized production APK binaries for Android |

---

## 🤝 Contributing & Architecture Workflow

Presby Hymns follows a disciplined, multi-agent development workflow:
- Task specifications and implementation plans are logged under `tasks/TASK-NNN.md`.
- Architecture decisions and design standards are maintained in [`docs/`](./docs).
- Notable changes and milestone completions are tracked in [`CHANGELOG.md`](./CHANGELOG.md).
- Root-cause analyses and technical lessons are recorded in [`MEMORY.md`](./MEMORY.md).

---

## 📄 License & Ministry Use

This application is designed for internal congregational worship and church ministry use. All hymn texts and tunes belong to their respective copyright holders and public domain traditions.
