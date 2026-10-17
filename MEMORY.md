# Memory — Bug Root Causes & Resolutions
> Maintained by `@debug-memory`. Read by agents when PM includes it in the Context Bundle.
> Agents that read: @codebase-explorer, @requirements-engineer, @fullstack-developer, @release-manager, @validator-agent.
> Only `@debug-memory` writes to this file.

---

## Workflow & Process Guards

- **GUARD-001** | Git Push Authorization
  - **Rule:** **DO NOT PUSH TO REMOTE WITHOUT EXPLICIT USER PERMISSION.**
  - **Context:** The user requires live verification on local devices/desktop before any commit is pushed to remote PR branches. Pushing unverified or buggy commits pollutes PR history and can mislead reviewers.
  - **Action:** Stage and commit changes locally only. Explicitly ask for user verification and confirmation before running `git push`.

- **GUARD-002** | Google Stitch Design Intake & Verification
  - **Rule:** **DO NOT BUILD OR IMPLEMENT UPON RECEIVING A GOOGLE STITCH DESIGN WITHOUT EXPLICIT USER PERMISSION.**
  - **Context:** Whenever the user shares a Google Stitch design or link, the design, copy, content, and layout must first be analyzed and grilled against project specs, technical reality, and non-functional requirements. Building prematurely bypasses human design review and risks baking in fabricated claims or misaligned UI patterns.
  - **Action:** Inspect the Stitch design, conduct an adversarial grill of the layout, copy, and behavior against `docs/`, present the analysis to the user, and await explicit approval before writing or updating any implementation code.

- **GUARD-003** | PR and Main Merge Workflow
  - **Rule:** **DEFAULT MERGE WORKFLOW IS VIA PULL REQUEST TO MAIN ON REMOTE.**
  - **Context:** The standard integration path is: push feature branch (once approved by user), open a Pull Request targeting `main`, and merge the PR on GitHub.
  - **Action:** Never merge feature branches directly into local `main` unless the user explicitly gives a manual override (e.g., "merge locally to main").

- **GUARD-004** | Pull Request Assignment
  - **Rule:** **ALWAYS ASSIGN PULL REQUESTS TO THE USER (@me / @James2898) UPON CREATION.**
  - **Context:** The repository owner and sole maintainer monitors open work, reviews, and notifications through GitHub's assignee filters. Unassigned PRs slip through personal dashboard views.
  - **Action:** Whenever creating a pull request (`gh pr create`), always include `--assignee "@me"` (or assign immediately after creation).

- **GUARD-005** | Targeted PR Scope Isolation
  - **Rule:** **WHEN ASKED TO COMMIT AND OPEN A PR FOR A SPECIFIC TASK, STAGE ONLY THAT TASK'S FILES.**
  - **Context:** Developers frequently have local experiments, uncommitted configs, or ongoing fixes in the workspace (e.g., build gradle tweaks, debug scripts) that are not part of the requested task. Staging `git add .` or blocking the user with scope questions adds friction.
  - **Action:** Stage strictly the files relevant to the active user request/task (e.g., `git add README.md`). Leave unrelated modified or untracked files safely untouched in the local working tree.

---

## UI State

- **BUG-001** | 2026-10-17 | Feature: `Riverpod 3.x State Management`
  - **Root Cause:** In `flutter_riverpod: ^3.4.3`, legacy state classes (`StateNotifier`, `StateNotifierProvider`, `StateProvider`) were moved out of the default export into `legacy.dart`, and duplicating provider aliases in `ProviderScope`/`ProviderContainer` `overrides` triggered runtime assertion errors.
  - **Resolution:** Imported `package:flutter_riverpod/legacy.dart` for legacy providers and ensured only canonical providers (not duplicate aliases like `databaseProvider = appDatabaseProvider`) are supplied in `overrides`.
  - **Prevention:** When using Riverpod 3.x, import legacy constructs from `package:flutter_riverpod/legacy.dart` (or migrate to `Notifier`/`AsyncNotifier`), and always override canonical provider definitions rather than aliased references.

- **BUG-006** | 2026-10-18 | Feature: `Hymn Viewer Transposition & Chord Controls`
  - **Root Cause:** Coupling key transposition controls to chord presence prevented vocalists and accompanists singing text-only/Tagalog hymns from receiving tonic pitch cues and pitch adjustment.
  - **Resolution:** Decoupled Key Transposition (`PitchShiftController` / transposition selector) from chord-specific controls (`Capo`, `CAGED`, `Hide Chords`), ensuring pitch transposition remains universally accessible regardless of chord notation availability.
  - **Prevention:** Always decouple vocal pitch cues and Key Transposition from chord-specific rendering controls (Capo, CAGED, Hide Chords) when displaying music with optional chord markup.

---

## Backend / DB

- **BUG-002** | 2026-10-17 | Feature: `Database Provider Architecture`
  - **Root Cause:** Instantiating `AppDatabase` independently in separate feature directories spawned multiple background SQLite isolate connections, risking database lock contention and state desynchronization.
  - **Resolution:** Centralized database lifecycle into a single canonical `appDatabaseProvider` in `lib/data/database/app_database.dart` consumed by all repositories and features.
  - **Prevention:** Never instantiate `AppDatabase` directly in feature code; always consume the canonical `appDatabaseProvider`.

- **BUG-003** | 2026-10-17 | Feature: `SQLite Asset Test Isolation`
  - **Root Cause:** Tests loading precompiled SQLite databases via `rootBundle.load('assets/db/hymns.db')` fail in headless test environments due to missing Flutter asset bundle context.
  - **Resolution:** Overrode `appDatabaseProvider` with an in-memory database instance `AppDatabase(NativeDatabase.memory())` within `testWidgets` / `ProviderScope.overrides`.
  - **Prevention:** Always override `appDatabaseProvider` with `AppDatabase(NativeDatabase.memory())` in widget and unit tests to ensure fast, isolated, headless test execution without asset dependencies.

- **BUG-004** | 2026-10-18 | Feature: `SQLite Asset Cache Synchronization`
  - **Root Cause:** When using precompiled bundled databases (`assets/db/hymns.db`), `_openConnection()` only copied the asset into `getApplicationDocumentsDirectory()` when `!await file.exists()`. Updates to the bundled asset were silently ignored, causing running desktop and mobile sandbox instances to serve stale cached SQLite data.
  - **Resolution:** Added file size / freshness comparison `final needsCopy = !await file.exists() || (await file.length()) != blob.lengthInBytes;` in `lib/data/database/app_database.dart` so updated bundled assets automatically overwrite the container document copy on launch.
  - **Prevention:** Never use a one-way `!file.exists()` guard for bundled database assets; always compare byte length or version to detect asset updates.

- **BUG-005** | 2026-10-18 | Feature: `Database Content Pipeline (ChordPro Retention)`
  - **Root Cause:** In `tool/build_content.dart`, `plainText` (which strips all chord brackets) was inserted into `hymn_texts.chordpro_body`, permanently losing chord markup during SQLite compilation.
  - **Resolution:** Stored the raw `.cho` file text in the builder memory map and inserted `enEntry.raw` / `tlEntry.raw` directly into `chordpro_body` while keeping `cleanPlain` for `lyrics_text` (FTS indexing).
  - **Prevention:** Ensure the raw ChordPro markup is preserved in `chordpro_body` so runtime parsers and transposer engines can extract chord-over-syllable layouts.

- **BUG-008** | 2026-10-18 | Feature: `Database Content Pipeline (Chord Syntax Validation)`
  - **Root Cause:** Naive bracket detection (`\[.*?\]`) treated non-chord structural tags (e.g., `[Verse]`, `[Chorus]`, `[Refrain]`) as valid musical chords during database compilation and validation.
  - **Resolution:** Updated validation logic in `test/data/database_integrity_test.dart` to assert chord tokens against standard musical syntax regex (`^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$`), discarding metadata/structural tags from chord processing.
  - **Prevention:** Always validate extracted chord tokens against standard musical chord syntax rather than relying on generic square bracket matching.

---

## Performance

- **BUG-007** | 2026-10-18 | Feature: `Bundled SQLite Asset Cold-Start Optimization`
  - **Root Cause:** Loading bundled database assets into RAM via `rootBundle.load()` on every app startup to compare byte sizes caused high memory overhead and degraded cold-start performance.
  - **Resolution:** Implemented a version stamp check via `SharedPreferences` before invoking `rootBundle.load()`, reading the bundled asset into memory only when a database schema or asset migration is genuinely required.
  - **Prevention:** Never load bundled binary assets into memory to check freshness; compare persistent metadata (e.g., `SharedPreferences` version or build number) before allocating RAM for asset blobs.

---

## Build & Packaging

- **BUG-009** | 2026-10-18 | Feature: `Android Release R8 ProGuard / SharedPreferences JNI NoSuchMethodError`
  - **Root Cause:** In Android release builds (`flutter build apk --release`), `shared_preferences_android: 2.5.0` migrated to Pigeon JNI reflection, causing R8 to strip or rewrite Kotlin coroutine `Continuation` parameters on `getAll(...)`. On launch, this threw `PlatformException(NoSuchMethodError: no non-static method SharedPreferencesApiRegistrar.getAll...)`.
  - **Resolution:** Constrained `shared_preferences_android: ">=2.4.28 <2.5.0"` (Method Channel architecture), added Kotlin coroutine / JNI keep rules in `android/app/proguard-rules.pro`, wired ProGuard in `android/app/build.gradle.kts`, and updated `.github/workflows/release.yml` to upload test APK artifacts before tagging public releases.
  - **Prevention:** Always include Kotlin coroutines keep rules in `proguard-rules.pro` for Android release builds, pin federated plugins if major underlying IPC changes, and verify release APKs via CI artifacts prior to publishing GitHub releases.

