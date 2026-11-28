# PBI-20261129 — Home navigation redesign and Tagalog Responsive Reading

- **Saved:** 2026-11-29
- **Source:** User request + `/design-grill` rounds-mode decisions (no ticket ID; date fallback)

---

## PBI (verbatim)

> i want to add the responsive reading on the app, so the homescreen will jsut contain the hero banner, search, Hymns Navigation Item, Responsive Reading Navigation item, and the future westminster-shorter-catechism navigation item

### Grill decisions (2026-11-29)

| # | Decision | Answer | Source | Spec section |
|---|---|---|---|---|
| Q1.1 | Reading content in this PR? | Yes — user supplies an MD file, parsed into `hymns.db` via `tool/` | user | Scope |
| Q1.2 | Hymn items on home | One "Hymns" `CatalogCard` → Index on `ALL` | recommendation accepted | Scope / AC |
| Q1.3 | Westminster Shorter Catechism item | Disabled `CatalogCard`, "Coming soon" badge | recommendation accepted | AC |
| Q1.4 | Nav item widget | Reuse `CatalogCard` | recommendation accepted | AC |
| Q1.5 | Home search | Stays hymns-only | recommendation accepted | Scope |
| Q1.6 | App-bar "Hymn Index" icon | Removed | recommendation accepted | AC |
| Q1.7 | App title | Stays "Presbyterian Hymns" | recommendation accepted | Scope |
| Q2.1 | Line styling | Leader: **bold, left-aligned**. People: normal weight, right-aligned | user | AC |
| Q2.2 | Reading header | Line 1 `Tugunang Pagbasa Bilang N` → number; line 2 → title; trailing Scripture-reference line → reference | user sample | Data model |
| Q2.3 | Language | Tagalog only; keep a `language` column for future | user | Scope / Data model |
| Q2.4 | Readings list | Simple numbered list + number/title filter → reader page | recommendation accepted | AC |
| Q2.5 | Reader controls | Text size + prev/next only, no music features | recommendation accepted | AC |
| Q2.6 | Count on reading card | No count | user | AC |
| Q3.1 | ***Bold-italic*** line | Unison (all) — centered, bold-italic | recommendation accepted | AC |
| Q3.2 | Source file | One file `raw_content/Tagalog Responsive Readings.md`, split on `**Tugunang Pagbasa Bilang N**` | recommendation accepted | Integration |
| Q3.3 | Copy | Tagalog: card "Tugunang Pagbasa", button "Tingnan ang mga Pagbasa" | recommendation accepted | AC |
| Q3.4 | Reader colours | Tagalog palette (`AppColors.canvasTl`, `accent*`) | recommendation accepted | NFR |

### Sample source MD (provided by user)

```
**Tugunang Pagbasa Bilang 1**

**Ang Daan Ng Buhay**

**Mapalad ang tao na hindi lumalakad sa payo ng masama,**

Ni tumatayo man sa daan ng mga makasalanan, Ni nauupo man sa upuan ng mga manglilibak.

**Kundi ang kanyang kasayahan ay nasa kautusan ng Panginoon;**

At sa kautusan niya nagbubulay-bulay siya araw at gabi.

**At siya’y magiging parang punong kahoy na itinanim sa siping ng mga agos ng tubig,**

Na nagbubunga sa kaniyang kapanahunan, ang kanyang dahon nama’y hindi nalalanta; at ano mang kaniyang gawin ay giginhawa.

**Ang masama ay hindi gayon;**

Kundi parang ipa na itinatabol ng hangin.

**Kaya’t ang masama ay hindi tatayo sa pag hatol,**

Ni ang mga makasalanan man sa kapisanan ng mga matuwid.

**Sapagka’t nalalaman ng Panginoon ang lakad ng mga matuwid:**

***Nguni’t ang lakad ng masama ay mapapahamak.***

Awit 1:1-6
```

---

## Analysis

### Acceptance Criteria

**Home screen**
- [ ] Home body shows, in order: hero banner, search bar, Hymns card, Tugunang Pagbasa card, Westminster Shorter Catechism card — and nothing else.
- [ ] The separate English and Tagalog hymn cards are gone; a single Hymns card opens the Index with `ALL` selected.
- [ ] The Hymns card still shows the total hymn count.
- [ ] The Tugunang Pagbasa card shows Tagalog copy (title "Tugunang Pagbasa", button "Tingnan ang mga Pagbasa"), no count, and opens the Readings list.
- [ ] The Westminster Shorter Catechism card shows a "Coming soon" badge and does nothing when tapped (button disabled).
- [ ] The app-bar "Hymn Index" icon is removed; title stays "Presbyterian Hymns".
- [ ] Home search behaves exactly as before (hymns only; readings never appear in results).

**Content pipeline**
- [ ] `raw_content/Tagalog Responsive Readings.md` is parsed into a new readings table in `assets/db/hymns.db`, split on each `**Tugunang Pagbasa Bilang N**` line.
- [ ] Each reading stores number N, title (line 2), Scripture reference (trailing reference line, e.g. `Awit 1:1-6`), `language = 'TL'`, and ordered lines with a role.
- [ ] Line roles: `**bold**` → leader, plain → people, `***bold-italic***` → unison. Header and reference lines are not stored as body lines.
- [ ] The sample above parses to number 1, title "Ang Daan Ng Buhay", reference "Awit 1:1-6", 12 body lines (6 leader, 5 people, 1 unison). (derived)
- [ ] A reading with a missing number, title or reference fails the build (or is reported) rather than shipping silently malformed. (derived)
- [ ] Existing hymn data and tests are unaffected after the DB rebuild (`test/data/database_integrity_test.dart` passes). (derived)

**Readings list**
- [ ] Lists all readings sorted by number, each row showing number, title and reference.
- [ ] A filter field narrows the list by number or title.
- [ ] Tapping a row opens that reading.

**Reading page**
- [ ] Header shows number, title and reference.
- [ ] Leader lines: bold, left-aligned. People lines: normal weight, right-aligned. Unison lines: bold-italic, centered.
- [ ] Text size can be increased/decreased.
- [ ] Prev/next navigate to adjacent readings; disabled at first/last.
- [ ] Uses the Tagalog palette (`AppColors.canvasTl`, accent colours); no chords, cue tones or transpose controls.
- [ ] Works offline on Android and web, like the hymns. (derived)

### Scope & Out-of-Scope
- **In scope:** home layout rework; Readings list + reader screens; MD parser and new DB table for Tagalog readings; WSC placeholder card.
- **Out of scope:** English readings; searching readings from home; WSC content or screen; renaming the app; changes to the hymn Index or hymn reader beyond being opened from the new Hymns card.

### Ambiguities & Risks
- **Source file not yet delivered.** Parsing rules are inferred from one sample; the full file may contain variations (multi-paragraph lines, missing reference, bold reference, stray headings, numbering gaps). Validate on the real file before building UI against it.
- **Reference detection.** The reference line is plain text like a people line. Detect by "last non-empty line" + reference pattern (book + `chapter:verse`); readings citing multiple passages (e.g. `Awit 1; Isaias 2:3`) need a looser pattern.
- **Long people line in sample** ("Ni tumatayo man … manglilibak.") may have been two lines in print; the MD keeps it as one paragraph — rendered as one line.
- **Pipeline placement.** Hymns go MD → `tool/import_gdoc.py` → `.cho` → `tool/build_content.dart` → DB. Readings have no `.cho` analogue; decide whether `build_content.dart` reads the MD directly or an intermediate format is added.
- **Schema change in the bundled DB.** Rebuilding `hymns.db` with a new table and regenerating `app_database.g.dart`; confirm whether a schema version bump / release note is required.
- **Disabled WSC card** must still be readable and announced as disabled for accessibility.

### Codebase-Aware Notes
- `lib/features/home/presentation/home_screen.dart` — replace the two `CatalogCard`s with Hymns / Readings / WSC; remove the app-bar `IconButton`; add an `onBrowseReadings` callback.
- `lib/features/home/presentation/widgets/catalog_card.dart` — reuse; has `badgeText`. Needs a hidden/optional count and a disabled state (`onTap` is currently required).
- `lib/features/home/presentation/providers/catalog_stats_provider.dart`, `lib/features/home/domain/models/catalog_stats.dart` — Hymns card needs a combined total.
- `lib/main.dart` — `HomeNavigationHost` pushes `ReaderScreen` / `IndexScreen` via `MaterialPageRoute`; add a push for the Readings list.
- `lib/data/database/app_database.dart` (+ generated `app_database.g.dart`) — add readings tables (Drift).
- `tool/build_content.dart` (writes `assets/db/hymns.db`) and `tool/import_gdoc.py` (reads `raw_content/*.md`) — extend for the readings MD.
- `lib/core/theme/app_colors.dart` — `canvasTl`, `accent`, `accentSoft`, `accentText` for the reader.
- `lib/features/reader/widgets/reader_header.dart`, `song_controls_toolbar.dart` — reference for header/text-size patterns; do not reuse music controls.
- `test/features/screens_test.dart`, `test/data/database_integrity_test.dart` — update home expectations; add readings integrity checks.
- **Net-new:** `lib/features/readings/` (list screen, reader screen, providers), parser for the readings MD, `raw_content/Tagalog Responsive Readings.md`.
