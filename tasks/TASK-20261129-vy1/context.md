# Context Bundle — Home Navigation Redesign & Tagalog Responsive Readings

## Relevant Files
| File | Why It's Relevant |
|------|------------------|
| `pbi-docs/PBI-20261129-home-nav-and-tagalog-responsive-reading.md` | Authoritative PBI, `/design-grill` decisions (Q1.1–Q3.4), sample MD, acceptance criteria, and scope. |
| `lib/features/home/presentation/home_screen.dart` | Home screen body & AppBar: remove AppBar "Hymn Index" `IconButton`, replace EN/TL cards with Hymns, Tugunang Pagbasa, and WSC cards; add `onBrowseReadings` callback. |
| `lib/features/home/presentation/widgets/catalog_card.dart` | Reusable navigation card widget; currently requires non-null `count`, `countLabel`, `onTap`, and leaves `badgeBackgroundColor` unused. Needs optional count, styled badge pill, and disabled state. |
| `lib/features/home/presentation/providers/catalog_stats_provider.dart` | Provides `homeRepositoryProvider` and `catalogStatsProvider` backed by `appDatabaseProvider`. |
| `lib/features/home/domain/models/catalog_stats.dart` | Stats model for Home screen; currently tracks `english` and `tagalog` with stale `520`/`380` default values rather than unique hymn count. |
| `lib/features/home/data/home_repository.dart` | Queries `hymns`/`hymn_texts`/`hymn_fts` for Home search (already hymns-only) and `getCatalogStats()` (currently counts `hymn_texts` rows per language: EN=173, TL=115). |
| `lib/main.dart` | `HomeNavigationHost` wires `HomeScreen` callbacks and pushes `IndexScreen` / `ReaderScreen` via `MaterialPageRoute`; add push route for Readings list. |
| `lib/data/database/app_database.dart` | Drift `@DriftDatabase` schema (`Hymns`, `HymnTexts`, `schemaVersion => 1`), conditional native/web connection import, and canonical `appDatabaseProvider`. |
| `lib/data/database/app_database.g.dart` | Drift generated code (1,886 lines); must be regenerated via `dart run build_runner build --delete-conflicting-outputs` after adding reading tables. |
| `lib/data/database/connection/connection_native.dart` | Copies `assets/db/hymns.db` to app documents dir when `storedVersion < kAppDbVersion` (currently `3`). Must bump `kAppDbVersion` to `4` on DB rebuild. |
| `lib/data/database/connection/connection_web.dart` | Loads `sqlite3.wasm` and `assets/db/hymns.db` fresh into `InMemoryFileSystem()` every session with `enableMigrations: false`; DB asset DDL must match Drift tables exactly. |
| `lib/core/theme/app_colors.dart` | Nordic Chapel + Sanctuary Gold palette tokens (`primary`, `accent`, `accentSoft`, `accentText`, `canvasEn`, `canvasTl`, `surface`, `border`, `borderStrong`, `textPrimary`, `textMuted`). |
| `lib/core/search/search_normalizer.dart` | `normalize()` and `removeDiacritics()` helpers usable for normalizing reading `sort_title` and title filtering. |
| `lib/features/index/index_screen.dart` | Pattern reference for list AppBar, sticky search filter bar (150ms debounce), and `ListView.builder` over cards. |
| `lib/features/index/providers/index_provider.dart` | Shows `IndexTab.all` displays 1 entry per `Hymn` (173 unique hymns in current DB); note anti-pattern `databaseProvider` alias to avoid. |
| `lib/features/index/widgets/song_card.dart` | Card layout reference (`AppColors.surface`, `BorderRadius.circular(12)`, `AppColors.border`, `48x48` `NO.` pill box). |
| `lib/features/reader/reader_screen.dart` | Pattern reference for `WakelockPlus` lifecycle, `AppColors.canvasTl` background tinting, scroll reset on prev/next navigation, and bottom prev/next `OutlinedButton.icon` bar. |
| `lib/features/reader/widgets/reader_header.dart` | Transparent `AppBar` reference with leading back button and prev/next `IconButton`s (`arrow_back_ios_new`, `arrow_forward_ios`) in `actions`. |
| `lib/features/reader/widgets/reader_metadata_card.dart` | Metadata card pattern (`HYMN #N` pill, `Space Grotesk` 22px bold title, tinted metadata chip for Scripture reference). |
| `lib/features/reader/widgets/song_controls_toolbar.dart` | Collapsible card + `A-` / `A+` text size controls (`_SmallBtn`, `12.0..28.0`, step `1.0`). |
| `lib/features/reader/providers/reader_providers.dart` | Persists global font size under `'settings.fontSize'` in `SharedPreferences` (default `19.0`, clamped `12.0..28.0`). |
| `lib/features/reader/widgets/lyrics_canvas.dart` | Body typography convention: `Source Serif 4`, `fontSize`, `height: 1.5`, `AppColors.textPrimary`. |
| `tool/build_content.dart` | Standalone Dart CLI (`dart run tool/build_content.dart`) that validates content, writes `build/content-report.md`, and compiles `assets/db/hymns.db`. Can parse `raw_content/Tagalog Responsive Readings.md` directly. |
| `tool/import_gdoc.py` | Python Google Docs MD → `.cho` converter for hymns only; not needed for readings unless intermediate files are desired (MD → `build_content.dart` directly is leaner). |
| `raw_content/` | Contains `English Hymns.md` and `Tagalog Hymns.md`. **Note:** `raw_content/Tagalog Responsive Readings.md` is not present in the repo yet. |
| `test/features/screens_test.dart` | Tests `HomeScreen`, `IndexScreen`, and `ReaderScreen`; lines 139–140 assert `'English Hymnal'` and `'Tagalog Himnaryo'` (must be updated). |
| `test/widget_test.dart` | Root smoke test; lines 36–37 assert `'English Hymnal'` and `'Tagalog Himnaryo'` (must be updated). |
| `test/data/database_integrity_test.dart` | Validates `assets/db/hymns.db` directly via `sqlite3`; extend with readings table/line assertions. |
| `test/features/offline_branding_cue_test.dart` | Asserts `build/content-report.md` contains `'Validation Status:** **PASS**'` and `'Total Unique Hymns:** 173'` (lines 138–139). |
| `.github/workflows/release.yml` | Runs `flutter pub get`, `dart run tool/build_content.dart`, `flutter test`, and `flutter build apk --release`. |
| `.claude/rules/GIT.md` | Repo git/PR/Android-CI rules (note PR target discrepancy vs `MEMORY.md` GUARD-003). |
| `docs/02-technical-architecture.md`, `docs/04-design-alignment.md`, `docs/design/DESIGN.md` | Architecture & design alignment rules, including WCAG contrast rule (`AppColors.accentText` for text on parchment, never `AppColors.accent` for body/badge text). |

## Reuse Candidates
- `lib/features/home/presentation/widgets/catalog_card.dart` — Reuse directly for all 3 Home navigation cards (Hymns, Tugunang Pagbasa, Westminster Shorter Catechism) by making `count`/`countLabel`/`onTap` nullable (or adding `disabled` / `countIcon`) and wiring `badgeBackgroundColor` for the `"Coming soon"` badge pill.
- `lib/core/theme/app_colors.dart` — Reuse `AppColors.canvasTl`, `AppColors.accent`, `AppColors.accentSoft`, `AppColors.accentText`, `AppColors.surface`, `AppColors.border`, `AppColors.borderStrong`, `AppColors.textPrimary`, `AppColors.textMuted`, and `AppColors.primary`.
- `lib/core/search/search_normalizer.dart` — Reuse `SearchNormalizer.normalize()` / `removeDiacritics()` for normalizing reading titles in the DB and/or list filter.
- `lib/data/database/app_database.dart` (`appDatabaseProvider`) — Reuse canonical `appDatabaseProvider` across the new readings providers/repository (never instantiate `AppDatabase` directly).
- `shared_preferences` (`'settings.fontSize'`) — Reuse the existing `'settings.fontSize'` preference key (default `19.0`, clamped `12.0..28.0`) or share a `fontSizeProvider` pattern so text scaling behaves identically to `ReaderPreferencesNotifier` (`lib/features/reader/providers/reader_providers.dart` lines 77, 127–131).
- `wakelock_plus` — Standard library/installed dependency already used in `lib/features/reader/reader_screen.dart` lines 39, 45 (`WakelockPlus.enable()` / `disable()`); reuse in the Reading page so the screen stays awake during responsive readings.
- `lib/features/reader/widgets/reader_header.dart`, `reader_metadata_card.dart`, `song_controls_toolbar.dart` (`_SmallBtn`), and `lib/features/index/widgets/song_card.dart` — Visual/structural patterns for the Readings list and Reading page (without music/chord/cue controls).
- `sqlite3` + `drift` (`build_runner`, `drift_dev`) — Already in `pubspec.yaml`; no new packages needed.

## Patterns to Follow
- **Home Navigation Wiring:** See `lib/main.dart` lines 42–87 (`HomeNavigationHost`) and `lib/features/home/presentation/home_screen.dart` lines 11–19 — Pass callback props from `HomeNavigationHost` into `HomeScreen` and push feature screens with `MaterialPageRoute`.
- **Feature Provider DB Access:** See `lib/features/home/presentation/providers/catalog_stats_provider.dart` lines 8–16 and `lib/features/home/presentation/providers/home_search_provider.dart` lines 30–74 — Watch `appDatabaseProvider` directly (no local alias) and prefer `NotifierProvider` / `FutureProvider` over `legacy.dart` `StateProvider`.
- **Dual-Platform Prebuilt SQLite Asset:** See `lib/data/database/connection/connection_native.dart` lines 9–35 and `connection_web.dart` lines 6–30 — `tool/build_content.dart` creates tables and rows in `assets/db/hymns.db`, `connection_native.dart` invalidates cached DB via `kAppDbVersion`, and `connection_web.dart` opens the asset in memory with `enableMigrations: false`. Keep `AppDatabase`'s default `onCreate` intact so `AppDatabase(NativeDatabase.memory())` tests create schema in memory; set `PRAGMA user_version = <schemaVersion>` in `tool/build_content.dart` if `schemaVersion` is bumped.
- **Content Pipeline & Report Continuity:** See `tool/build_content.dart` lines 53–100 & 338–350 — Run strict validation before touching `assets/db/hymns.db`, exit non-zero on missing/malformed reading fields, write `build/content-report.md` keeping `'Validation Status:** **PASS**'` and `'Total Unique Hymns:** 173'` intact for `offline_branding_cue_test.dart`, and rebuild `hymn_fts`.
- **Nordic Chapel / Sanctuary Gold (TL) Styling & Contrast:** See `lib/core/theme/app_colors.dart` and `docs/04-design-alignment.md` §4 — Use `AppColors.canvasTl` (`#EFECE4`) background for Tagalog Reading screen, `AppColors.surface` (`#FFFFFF`) cards with `1px` `AppColors.border`, `Space Grotesk` for numbers/titles/UI headers, `Source Serif 4` (`19px`, line-height `1.5`) for reading lines, and `AppColors.accentText` (`#7A5E1B`) rather than `AppColors.accent` (`#C29B48`) for gold-tinted text on light surfaces.
- **Headless Widget Testing with Drift:** See `test/features/screens_test.dart` lines 19–131 — Mock `SharedPreferences.setMockInitialValues({})` and override `appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))` in `ProviderScope`.

## Anti-Patterns Flagged
- `lib/features/index/providers/index_provider.dart` line 18 and `lib/features/reader/providers/reader_providers.dart` line 11: Aliasing `final databaseProvider = appDatabaseProvider;` forces tests to override feature-specific aliases and risks Riverpod 3 override mismatches (BUG-001 / BUG-002) — do not replicate in `lib/features/readings/`.
- `lib/features/home/domain/models/catalog_stats.dart` lines 17–20 and `lib/features/home/data/home_repository.dart` lines 153–154: Hardcoding stale fallback numbers (`520`, `380`) in `CatalogStats` defaults and `catch` blocks — do not replicate; also note `hymns` has **173** unique hymns (`IndexTab.all` count) while `hymn_texts` has **288** rows (173 EN + 115 TL), so use `COUNT(*) FROM hymns` for the single Hymns card count rather than summing EN + TL texts.
- `lib/features/home/presentation/widgets/catalog_card.dart` lines 26–27 & 70–79: Unused `badgeBackgroundColor` parameter and unstyled plain `Text` badge — wire the badge container styling properly when adding `"Coming soon"`.
- `lib/features/index/index_screen.dart` lines 142–150: Calling `_searchController.clear()` without updating state to refresh suffix clear-icon visibility, and plain `.toLowerCase().contains()` filtering without diacritic normalization (`SearchNormalizer.normalize` avoids accented mismatch).
- `lib/data/database/connection/connection_native.dart` line 9 & `tool/build_content.dart` line 409: Forgetting to bump `kAppDbVersion` after rebuilding `assets/db/hymns.db` silently serves stale DBs on existing installs (BUG-004); `PRAGMA user_version` is also currently left at `0` by `tool/build_content.dart`.
- `raw_content/Tagalog Hymns.md` lines 1–40 (Google Docs MD export reference): Google Docs exports frequently contain backslash escapes (`\!`, `\-`, `\#`), trailing double spaces, CRLF, or curly apostrophes (`’` as seen in the PBI sample `siya’y`). The readings MD parser should handle backslash unescaping / whitespace trimming / BOM safely and validate against the real `raw_content/Tagalog Responsive Readings.md` once delivered.

## MEMORY.md Notes
- **GUARD-001 | Git Push Authorization:** DO NOT PUSH TO REMOTE WITHOUT EXPLICIT USER PERMISSION. Stage and commit locally only; confirm before running `git push`.
- **GUARD-002 | Google Stitch Design Intake & Verification:** Do not build/implement from a Google Stitch link without explicit user analysis/approval.
- **GUARD-003 | PR and Main Merge Workflow (vs `.claude/rules/GIT.md`):** `MEMORY.md` GUARD-003 says default feature PR target is `develop` (`gh pr create --base develop`), and this worktree (`add_responsive_reading_nav`) is branched from `develop` (`ee8be2e`). Note `.claude/rules/GIT.md` line 13 says PR targeting `main`. Confirm base branch (`develop`) with the user before creating the PR; never merge directly into local `main` or `develop` without explicit override.
- **GUARD-004 | Pull Request Assignment:** Always assign PRs to `@me` (`--assignee "@me"`) upon creation.
- **GUARD-005 | Targeted PR Scope Isolation:** Stage strictly the files relevant to the active task; never run `git checkout -- <file>`, `git restore`, or `git clean` on files not modified in the current session; list any remaining unstaged files in the commit summary.
- **GUARD-006 | Mandatory Physical Android Device Verification & No Local Android SDK:** Never tag or publish a `v*` release without user verification on a physical Android device. Per `.claude/rules/GIT.md`, this environment has no local Android SDK (`flutter build apk` / `flutter doctor` cannot run locally); verify Android builds via the `presby-hymns-apk` CI artifact in `.github/workflows/release.yml`.
- **GUARD-007 | Dart MCP Tool Diagnostics:** Initialize `roots` or connect `dtd` before calling `dart-mcp-server` diagnostics (`analyze_files`, `widget_inspector`).
- **GUARD-008 | Visual Previews for Design & Palette Choices:** Render a side-by-side PNG mockup when proposing color palettes or UI style options.
- **BUG-001 | Riverpod 3.x State Management:** In `flutter_riverpod: ^3.4.3`, legacy providers (`StateProvider`, `StateNotifier`, `StateNotifierProvider`) live in `package:flutter_riverpod/legacy.dart` (prefer `Notifier`/`AsyncNotifier`), and overrides must target canonical providers rather than aliased references.
- **BUG-002 | Database Provider Architecture:** Never instantiate `AppDatabase` in feature code; always consume canonical `appDatabaseProvider` from `lib/data/database/app_database.dart`.
- **BUG-003 | SQLite Asset Test Isolation:** Always override `appDatabaseProvider` with `AppDatabase(NativeDatabase.memory())` in widget/unit tests for headless execution without asset bundle dependencies.
- **BUG-004 | SQLite Asset Cache Synchronization:** Whenever `tool/build_content.dart` updates `assets/db/hymns.db`, increment `kAppDbVersion` in the same commit. *(Updated file location after PR #13: `kAppDbVersion` is now in `lib/data/database/connection/connection_native.dart` line 9, currently `3`, rather than `app_database.dart`.)*
- **BUG-005 | Database Content Pipeline (ChordPro Retention):** Keep preserving raw ChordPro markup in `hymn_texts.chordpro_body` and stripped plain text in `hymn_texts.lyrics_text` when updating `tool/build_content.dart`.
- **BUG-006 | Hymn Viewer Transposition & Chord Controls:** Keep vocal pitch cues and key transposition decoupled from chord-specific controls (`Capo`, `CAGED`, `Hide Chords`) in the hymn reader.
- **BUG-007 | Bundled SQLite Asset Cold-Start Optimization:** Compare `SharedPreferences` version (`kDbVersionPrefKey`) before calling `rootBundle.load('assets/db/hymns.db')`; never load the DB asset bytes into RAM just to check freshness.
- **BUG-008 | Database Content Pipeline (Chord Syntax Validation):** Preserve standard musical chord regex validation in `tool/build_content.dart` and `test/data/database_integrity_test.dart`.
- **BUG-009 | Android Release R8 ProGuard / SharedPreferences JNI NoSuchMethodError:** Preserve `shared_preferences_android: ">=2.4.28 <2.5.0"` in `pubspec.yaml` and existing ProGuard rules.
- **BUG-010 | CI Build & Gitignored Test Artifacts:** Run `dart run tool/build_content.dart` before `flutter test` (matching `.github/workflows/release.yml`), and never pass `Platform.resolvedExecutable` inside `flutter test` to spawn Dart CLI tools (use `'dart'` explicitly).

## Environment & Tooling Notes
- Flutter `3.50.1` / Dart `3.14.0` are installed at `/home/james2898/flutter/bin/flutter` and `/home/james2898/flutter/bin/dart` (not in default `$PATH`; `.dart_tool/` is not yet generated in this fresh worktree until `flutter pub get` runs).
- `assets/db/hymns.db` currently has `173` rows in `hymns` (`173` EN + `115` TL = `288` rows in `hymn_texts`), `PRAGMA user_version = 0`, `meta.schema_version = '1'`.
