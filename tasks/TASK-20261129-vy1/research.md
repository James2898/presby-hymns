# Research — Home Navigation & Tagalog Responsive Reading

## Open Questions

### Blocking
- None. (All product decisions were finalized in the 2026-11-29 3-round design-grill.)

### Pending Reconciliation
- **CatalogCard API & Callers** — Confirm the existing `CatalogCard` widget properties, styling tokens, and all current callers in the codebase to ensure optional count and disabled/badge extensions remain backwards-compatible. (suggested resolution source: `context.md` / `lib/features/home/` & `lib/shared/widgets/`)
- **AppBar Existing Actions** — Confirm whether the Home screen AppBar contains any action icons other than the removed `"Hymn Index"` icon (e.g., settings or theme toggle) that must be retained. (suggested resolution source: `context.md` / Home screen widget)
- **Hymn Index `ALL` Filter Navigation** — Confirm exact route path/name and filter argument used to open the Hymn Index screen on the `ALL` tab. (suggested resolution source: `context.md` / router & Hymn Index screen)
- **Database Naming & Versioning Conventions** — Confirm existing Drift table/column naming style, `language` literal casing (`'TL'` vs `'tl'`), current `kAppDbVersion` and `schemaVersion`, and how `tool/build_content.dart` creates/populates tables in `assets/db/hymns.db`. (suggested resolution source: `context.md` / `lib/data/database/app_database.dart` & `tool/build_content.dart`)
- **Tagalog Palette & Text-Size Tokens** — Confirm exact `AppColors` `accent*` token names and existing reader text-size min/max/step/persistence provider conventions. (suggested resolution source: `context.md` / `lib/core/theme/` & Hymn detail reader)
- **Secondary UI Copy Language** — Confirm whether secondary non-specified strings on the Tagalog Readings List screen (filter placeholder, empty search state) should follow Tagalog copy or existing English UI chrome conventions. (suggested resolution source: `context.md` / existing Tagalog Index or Hymn viewer strings)
