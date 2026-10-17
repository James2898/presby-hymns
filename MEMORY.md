# Memory — Bug Root Causes & Resolutions
> Maintained by `@debug-memory`. Read by agents when PM includes it in the Context Bundle.
> Agents that read: @codebase-explorer, @requirements-engineer, @fullstack-developer, @release-manager, @validator-agent.
> Only `@debug-memory` writes to this file.

---

## UI State

- **BUG-001** | 2026-10-17 | Feature: `Riverpod 3.x State Management`
  - **Root Cause:** In `flutter_riverpod: ^3.4.3`, legacy state classes (`StateNotifier`, `StateNotifierProvider`, `StateProvider`) were moved out of the default export into `legacy.dart`, and duplicating provider aliases in `ProviderScope`/`ProviderContainer` `overrides` triggered runtime assertion errors.
  - **Resolution:** Imported `package:flutter_riverpod/legacy.dart` for legacy providers and ensured only canonical providers (not duplicate aliases like `databaseProvider = appDatabaseProvider`) are supplied in `overrides`.
  - **Prevention:** When using Riverpod 3.x, import legacy constructs from `package:flutter_riverpod/legacy.dart` (or migrate to `Notifier`/`AsyncNotifier`), and always override canonical provider definitions rather than aliased references.

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
