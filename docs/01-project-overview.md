# Bilingual Presbyterian Hymns App — Project Overview (v2)

> **Status:** Revised 2026-10-17 after two design-grill rounds. Supersedes the original draft.
> **Companion docs:** [02-technical-architecture.md](02-technical-architecture.md) · [03-implementation-plan.md](03-implementation-plan.md) · [04-design-alignment.md](04-design-alignment.md) · [design/DESIGN.md](design/DESIGN.md)

## 1. Executive Summary

An **offline-first, bilingual (English / Tagalog) hymnal app** for internal use by a Presbyterian congregation. It unifies the English hymnal (520 numbered hymns) and the Tagalog Himnaryo (380 numbered hymns) under **one numbering scheme that matches the printed books**, plus a set of unnumbered songs.

v1 is a **lyric reader and musician's chord workbench**:

- **Instant search** by hymn number (exact) or lyric/title keywords, grouped into English and Tagalog results.
- **Chord workbench** — ChordPro chords over syllables, transposition (remembered per hymn), capo 0–7 with shape display, CAGED shortcuts, hide chords, font scaling.
- **Key CUE** — a short tonic pitch-pipe tone in the hymn's current key.
- **Report a song** — one tap opens a pre-filled email to the maintainer.
- **100% offline**, no login, no analytics.

**Not in v1:** MIDI accompaniment / music player drawer (next phase), iOS build, dark mode, favorites, recents, setlists, themes.

## 2. Context & Problem

- Bilingual services alternate English and Tagalog; members juggle two physical books.
- Musicians need chords in singable keys and capo positions; few printed chord charts exist.
- Sanctuaries often have no signal — the app must work fully offline.

## 3. Distribution & Audience

| Item | Decision |
| :--- | :--- |
| Distribution | **Internal only.** Not published to Play Store / App Store. |
| Platform (v1) | **Android only**, distributed as APK via **Firebase App Distribution** (free). |
| Application ID | `com.badzbordz.hymns` (personal/private project namespace). |
| Reference Device | Local Android Emulator configured with **2 GB RAM & low-end profile** (e.g. Pixel 3a / generic 360dp phone) to simulate target hardware. |
| Source Content | Existing texts exported from **Google Docs**; parser/importer script converts to `.cho` in M0. |
| Branding Asset | Generic dignified hymnal & cross icon. |
| iOS | Deferred until a paid Apple Developer account exists (free accounts expire builds every 7 days). |
| Accounts | Free accounts only; no in-app login. |
| Maintainer / reviewer | Single developer, who is also content reviewer and release approver. |
| Content rights | Internal use only. Re-evaluate copyright before any public release. |

## 4. Personas

### 4.1 Congregant & Choir Member
- Find a hymn by announced number or a remembered phrase.
- Large, high-contrast serif lyrics with adjustable size.
- One-tap switch between English and Tagalog of the same number.
- Key CUE to find the starting note.

### 4.2 Church Musician / Guitarist
- Chords over syllables, transposable to a singable key, **remembered next time the hymn is opened**.
- Capo 0–7 with chords shown as the shapes to finger (Key C + Capo 3 → shows **A** shapes).
- CAGED buttons that set the capo for a chosen shape.
- Hide chords when playing from sheet music.

### 4.3 Pastor / Liturgist
- Fully offline reliability.
- Hymn metadata: number, meter, author/translator, year, tune name.
- *(Accompaniment playback moves to the MIDI phase; themes/setlists out of scope.)*

## 5. Content Model (summary)

| Catalog | Count | Numbering |
| :--- | :--- | :--- |
| English Hymnal | 520 | 1–520, same as printed book |
| Tagalog Himnaryo | 380 | Sparse subset of 1–520; **#N Tagalog is the translation of #N English** |
| Unnumbered songs | N (growing) | No number; belong to **one language only**; listed after numbered hymns, alphabetically |

- Tagalog-only *numbered* hymns are **not supported**.
- English and Tagalog of the same number **share the key**, but **may differ in verse count**.
- Every hymn has a **key** recorded (even without chords). Chords are transcribed progressively; `has_chords` tracks coverage.
- Source today: **text only**. Chords and verse markers are transcribed manually into ChordPro files.

## 6. Screens & Features (v1)

Visual source of truth: Stitch project **"Bilingual Presbyterian Hymnal App"** + [design/DESIGN.md](design/DESIGN.md) ("Sanctuary Psalter"). Required deviations are listed in [04-design-alignment.md](04-design-alignment.md).

### 6.1 Home
- Presbyterian-blue hero banner.
- Live search field (`Search #, title, or lyrics`), debounced 150 ms:
  - **Digits only** → exact hymn number; at most one English and one Tagalog result.
  - **Text** → keyword search over title, first line and lyrics; ignores chord markers, syllable hyphens and accents/diacritics.
  - Results grouped: `ENGLISH HYMNS (n matches)` / `TAGALOG HIMNARYO (n matches)`; row = number pill (none for unnumbered), title, first-line snippet, chevron. Tap opens reader in that language.
- Catalog cards: English Hymnal, Tagalog Himnaryo — counts computed from data.

### 6.2 Index
- Tabs: `All Hymns` · `English` · `Tagalog` (last tab remembered).
  - **All:** one row per hymn number (English title), availability badges (`ENG | TGL` / `EN ONLY`); unnumbered songs of both languages appended.
  - **English / Tagalog:** that language's rows; Tagalog list skips unassigned numbers with no placeholders.
- Sort toggle: **Number (default)** / **Title**. A–Z jump rail visible **only in Title mode**.
- Number mode: numbered hymns ascending, then unnumbered songs alphabetically. Title mode: everything alphabetical.
- Search field filters within the active tab (same search rules as Home).
- Card: number pill, title, author (year) • meter, key badge (shown whenever a key exists).

### 6.3 Hymn Reader
- Header: back, language switcher `[English] [Tagalog]`, overflow menu (`Report a problem`). Language switcher hidden for unnumbered songs.
- Metadata: `HYMN #n`, current key badge, title, meter, author/translator, year.
- Language switch keeps the hymn number, resets scroll to top, and changes canvas tint (EN `#FBF9F5`, TL `#F5EFE6`). Missing counterpart → empty-state card with a one-tap return button.
- **Song Controls** (collapsible; summary line `Capo 0 • Key G`):
  - Key: `[-1] [Key ▾] [+1]` + `Reset` — saved per hymn, shared by English and Tagalog.
  - Size: `[A-] 19px [A+]` — global, range 12–28 px.
  - Hide Chords — global.
  - Capo: `0 … 7` — saved per hymn; stays fixed when transposing (shapes recompute).
  - CAGED: `C A G E D` — sets capo for that shape; disabled if it needs a capo above 7.
  - Hymns without chords show only the Size row.
- Lyrics canvas: Source Serif 4; chords above syllables; verse numerals; refrain written once and shown after every verse in a refrain box (`REFRAIN` / `KORO`).
- **Cue bar** (slim, docked bottom): `[♪ Eb Cue]` plays a ~2 s tonic note (octave 4) in the **current key**. A key picker lets the user cue a different key; if it differs from the chord key, a confirmation dialog appears. Cue key is not saved.
- Screen stays awake while the reader is open. No auto-scroll.

### 6.4 Report a Problem
- Opens the device mail app (`mailto:`) to the maintainer, pre-filled with hymn number, language, title, current key/capo, app version and content version.
- If no mail app is available: copy the report to clipboard and show the address.

## 7. Non-Functional Requirements

| Dimension | Requirement |
| :--- | :--- |
| Offline | All features work in airplane mode. No network calls except user-initiated `mailto:`. |
| Cold start | < 1.5 s to interactive Home on reference device (excludes first-ever launch DB copy). |
| Search | < 50 ms per query (p95) on reference device. |
| Package size | APK < 25 MB per ABI. |
| Legibility | Lyrics text WCAG **AAA** (≥ 7:1); UI chrome WCAG **AA** (≥ 4.5:1). Font 12–28 px without clipping. |
| Wake lock | Screen stays on in Reader. |
| Devices | Android, Flutter's default minimum SDK. Portrait phones are the designed layout; tablets/landscape must work but have no bespoke layout. |
| Reference device | Low-end Android, 2 GB RAM (exact model to be named in plan). |
| Privacy | No accounts, analytics, or crash SDKs. |

## 8. Out of Scope (v1) / Future

| Item | Target |
| :--- | :--- |
| MIDI accompaniment, SoundFont, music player drawer, verse tracking, tempo | Phase 2 (post-v1) |
| iOS distribution | When paid Apple account exists |
| Dark mode, tablet dual-pane | Later |
| Favorites, recents, setlists, themes / scripture filters | Not planned |
| Auto-scroll / verse highlighting | Not planned for v1 |

## Appendix A — Decision Log

| # | Decision |
| :--- | :--- |
| D1 | Internal app; no store publishing. |
| D2 | v1 = text + chords; MIDI is the next phase. Chords and verse markers transcribed manually. |
| D3 | App number = printed number; no separate `printed_number`. |
| D4 | No Tagalog-only numbered hymns. Unnumbered songs (single language) listed last, alphabetical. |
| D5 | EN/TL may differ in verse count; key is shared. Transposed key saved per hymn. |
| D6 | No setlists, themes, recents, favorites. |
| D7 | Cue follows current key; may be changed independently with confirmation; not saved; single tonic note, octave 4. |
| D8 | Capo shows shape chords (sounding key − capo). Capo stays fixed on transpose. CAGED disabled above fret 7. |
| D9 | (MIDI phase) Playback stops when leaving the reader. |
| D10 | Search ignores chord markers, hyphens, accents. Numeric search = exact match only. |
| D11 | Single developer = reviewer. |
| D12 | Free accounts; private internal tool. |
| D13 | Transposer supports slash chords and minor keys. |
| D14 | No dark mode in v1. |
| D15 | Key + capo per hymn; font size + hide-chords global. |
| D16 | Report-a-song via `mailto:`, clipboard fallback. |
| D17 | Least-config targets: Android first, Flutter default SDK minimums. |
| D18 | No auto-scroll in v1. |
| D19 | Android-only v1 via Firebase App Distribution. |
| D20 | Key CUE in v1 using pre-rendered tones (no SoundFont). |
| D21 | Every hymn has a key; key badge shown whenever a key exists. |
| D22 | Refrain written once (`{chorus}`), rendered after every verse. |
| D23 | Index sort: Number default, Title toggle; A–Z rail only in Title mode. |
| D24 | Content authored as ChordPro files in git; build script produces the seed DB. |
| D25 | User state stored separately from the replaceable content DB. |
