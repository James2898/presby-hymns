# Design Alignment — Stitch vs. Revised Spec (v2)

> **Source:** Stitch project **"Bilingual Presbyterian Hymnal App"** (`projects/17336782789904175329`), design system **"Sanctuary Psalter"** (exported to [design/DESIGN.md](design/DESIGN.md)), screens: *Presbyterian Hymns – Home*, *– Index*, *– Reader (Hymn #1)*. HTML snapshots: [stitch-home.html](design/stitch-home.html), [stitch-index.html](design/stitch-index.html), [stitch-reader.html](design/stitch-reader.html).
> Reviewed 2026-10-17. Two other items in the project (`Presbyterian Hymnal App`, `image.png`) were not reviewed.

**Verdict:** The visual language (blue/gold/crimson, Space Grotesk + Source Serif 4 + Inter, flat bordered surfaces, EN/TL canvas tints) is kept as-is. The screens need **content and behaviour changes** to match the decisions below. The design system also describes features that are out of scope for v1.

## 1. Home Screen

| # | Stitch shows | Spec says | Change |
| :--- | :--- | :--- | :--- |
| H1 | Query `1` returns #1 **and #10** in English | Numeric search = exact only (D10) | Show only #1 per group |
| H2 | Card copy promises "interactive guitar chords, transposition & CAGED" for the whole catalog | Chords are transcribed progressively | Copy: "Lyrics with chords where available" (EN) / Tagalog equivalent |
| H3 | Fixed "520 Hymns" / "380 Hymns" | Counts come from data; unnumbered songs exist | Bind counts to DB; optional "+ n songs" |
| H4 | "img" logo placeholder in app bar | — | **Needs a logo asset** (open item) |
| H5 | Toast "Opening Tagalog Himno #14…" | Not specified | Remove (navigation is instant) |
| H6 | No unnumbered result example | Unnumbered rows have no number pill | Add a row variant without number pill |

## 2. Index Screen

| # | Stitch shows | Spec says | Change |
| :--- | :--- | :--- | :--- |
| I1 | A–Z rail always visible while list is sorted by number | Number sort default; A–Z rail only in Title mode (D23) | Add **Number / Title** sort toggle; hide rail in Number mode |
| I2 | Bookmark icons on cards | No favorites (D6) | Remove bookmark icons |
| I3 | "EN ONLY · Walang Salin" cards | All tab marks missing Tagalog | Keep; add `ENG \| TGL` badge for paired hymns (per DESIGN.md §3) |
| I4 | Copy "No authorized Tagalog translation in Presbyterian Canticle" | — | Use neutral copy: "No Tagalog translation" |
| I5 | No unnumbered section | Unnumbered songs after numbered, A→Z (D4) | Add end-of-list section with a "Songs" divider and no number pill |
| I6 | Tagalog tab not designed | Sparse list, no placeholders | Add Tagalog-tab state (TL titles, TL canvas tint optional) |
| I7 | Key badge on all cards | Key badge whenever a key exists (D21) | OK as-is |

## 3. Hymn Reader Screen

| # | Stitch shows | Spec says | Change |
| :--- | :--- | :--- | :--- |
| R1 | Header "Key of E♭ Major" while chords display in **G** with Capo 0, Key G | Chords transcribed in concert key; header shows **sounding key**; shapes only differ when capo > 0 (D8) | Make consistent: header = current key; when capo > 0 show "Capo n · shapes in Y" |
| R2 | Full music player: BPM, time signature, scrubber, verse "2 of 4", ±10 s, stop/play, volume | MIDI deferred to Phase 2 | Replace with **slim Cue bar**: `[♪ Eb Cue]` + cue key picker. Keep the docked slot for the future player |
| R3 | "E♭ Cue" while chords are in G | Cue follows sounding key (D7) | Cue label = sounding key |
| R4 | No cue key picker / confirmation | Different cue key needs confirmation | Design picker + dialog "Cue in F while chords are in Eb?" |
| R5 | No Reset key | Reset restores original key, capo 0 | Add `Reset` next to key stepper |
| R6 | No overflow / report entry | Report a problem (D16) | Add overflow menu (⋮) with "Report a problem" |
| R7 | Missing-Tagalog empty state not designed | Required | Design empty-state card with "Back to English" |
| R8 | No refrain example | Refrain once, shown after each verse with crimson left rule, `REFRAIN` / `KORO` | Add a hymn example with a refrain |
| R9 | No no-chord variant | Controls show only Size row | Design collapsed/minimal controls for lyrics-only hymns |
| R10 | Font size control shows 16px | Default body-stanza 19px (DESIGN.md) | Default 19px |
| R11 | Language switcher always shown | Hidden for unnumbered songs | Variant without switcher |

## 4. Design System (DESIGN.md) Overrides for v1

| Section | DESIGN.md | v1 decision |
| :--- | :--- | :--- |
| Colors → Global Dark Mode (Vespers) | Defined | **Out of scope** (D14) — do not implement |
| Layout → Tablet dual-pane, Desktop projection | Defined | **Out of scope** — tablets get the phone layout, centered max 768 px |
| Components §4 Filter chips (Advent, Bautismo…) | Defined | **Out of scope** — no themes (D6) |
| Metadata → scripture references | Mentioned | Not in data model; omit |
| Components §5 Audio player bar | Tempo + pitch | v1 = Cue bar only |
| Secondary gold `#d4af37` for **text** (verse numerals, badge text) | Used for text | Contrast ≈ 2.0:1 on parchment — **fails AA**. Use gold only for rules/borders/fills; render verse numerals in `#735c00` (≈ 6:1, passes AAA-large for 19px bold) |
| Tagalog badge `#8A6708` on `#F5EFE6` | Badge text | ≈ 4.6:1 — passes AA (UI chrome), acceptable |
| Fonts | Google Fonts | **Bundle TTFs** — no runtime fetch (offline) |
| EN/TL canvas tints `#FBF9F5` / `#F5EFE6` | Defined | Keep |

## 5. Open Design Items

1. Logo / app icon asset (H4).
2. Exact `applicationId` / church name for branding.
3. Should the Stitch screens be updated to reflect sections 1–3 before build, or treat this doc as the delta?
