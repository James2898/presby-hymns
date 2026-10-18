# Context Bundle — App Branding, Fonts, Cue Tones, Content Checker & CI Release Docs

## Relevant Files
| File | Why It's Relevant |
|------|------------------|
| `lib/features/home/presentation/widgets/hero_banner.dart` | Renders the Presbyterian blue hero header; currently displays a generic church icon that must be replaced with the Draft 1 branding icon (white bg, #004AAD cross, yellow sunburst, yellow text). |
| `android/app/src/main/res/` | Android launcher icon mipmap directories (`mipmap-hdpi`, `mdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`) currently holding default Flutter icons. |
| `android/app/src/main/AndroidManifest.xml` | Android application manifest referencing `@mipmap/ic_launcher` and app label. |
| `pubspec.yaml` | Flutter package config where offline TTF fonts (`Space Grotesk`, `Source Serif 4`, `Inter`) and audio assets must be declared. |
| `assets/fonts/` | Asset target directory for bundled offline TTF font files. |
| `assets/audio/cue/` | Asset target directory for generated 12 tonic pitch pipe audio tones (C4–B4). |
| `lib/features/reader/widgets/cue_bar.dart` | Reader bottom cue bar; currently catches missing audio files and simulates a 2-second delay with `Future.delayed`. Must play generated tones directly. |
| `tool/render_cue_tones.dart` | New standalone Dart CLI tool to synthesize 12 tonic pitch-pipe tones (C4–B4) into `assets/audio/cue/`. |
| `tool/build_content.dart` | SQLite content compilation script; needs integration of strict content checker validations and `build/content-report.md` generation. |
| `test/data/database_integrity_test.dart` | Database integrity test asserting chord retention and chord regex; reference for validation logic. |
| `docs/01-project-overview.md` | Core project specification referencing Firebase App Distribution in §3 table and Appendix A (D19). |
| `docs/02-technical-architecture.md` | Architecture specification detailing §4.1 Content Checker rules and §12 distribution. |
| `docs/03-implementation-plan.md` | Milestone roadmap detailing M0–M4 tasks, referencing Firebase in §1 and §4. |
| `docs/design/DESIGN.md` | Visual design system defining color tokens (#004AAD primary, #D4AF37 / #FED65B secondary gold) and typography specifications. |
| `.github/workflows/release.yml` | Existing GitHub Actions workflow building release APKs, uploading `presby-hymns-apk` artifacts, and publishing GitHub Releases on `v*` tags. |

## Reuse Candidates
- `lib/core/music/key_speller.dart` — Provides canonical pitch spelling, note lists (`sharpNotes`, `flatNotes`), and pitch indices for calculating tonic frequencies.
- `lib/core/chordpro/chordpro_parser.dart` — Provides `ChordProParser.parse()` and `SongDoc` AST with section types (`SectionType.verse`, `SectionType.chorus`, `SectionType.ending`) to validate contiguous verses and metadata directives.
- `lib/core/search/search_normalizer.dart` — Used in `tool/build_content.dart` for title and lyrics normalization.
- `test/data/database_integrity_test.dart` lines 39-40 — Contains the production musical chord validation regex `^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$` to reuse in `tool/build_content.dart`.

## Patterns to Follow
- **Content Compilation Pipeline:** See `tool/build_content.dart` — Reads `content/en/*.cho` and `content/tl/*.cho`, parses with `ChordProParser`, populates tables (`hymns`, `hymn_texts`, `meta`, `hymn_fts`), and rebuilds FTS. Content checker validation must run before DB write and abort on failure (`exit(1)`).
- **Audio Playback in Widgets:** See `lib/features/reader/widgets/cue_bar.dart` — Uses `AudioPlayer` from `audioplayers` with `AssetSource('audio/cue/${keyRoot}4.<ext>')` and listens to `onPlayerComplete`.
- **Pure Tone Synthesis in Dart:** Synthesize 16-bit PCM WAV (or OGG) audio with standard RIFF header and smooth ADSR envelope (e.g. 50ms attack, 100ms release) to avoid audio clipping/clicks across the 12 frequencies C4 (261.63Hz) to B4 (493.88Hz).
- **Typography Tokens:** See `docs/design/DESIGN.md` and usages across `lib/features/reader/` — Explicitly defines `Space Grotesk` (headings/numbers), `Source Serif 4` (lyrics body), and `Inter` (UI/metadata).
- **CI Artifact Verification:** See `.github/workflows/release.yml` — Distributes APK via GitHub Actions workflow artifact `presby-hymns-apk` and GitHub Releases on `v*` tags instead of Firebase App Distribution.

## Anti-Patterns Flagged
- `lib/features/reader/widgets/cue_bar.dart` lines 56-59: Simulating audio playback with `await Future.delayed(const Duration(seconds: 2))` when assets fail — replace with clean error handling once audio assets are bundled.
- `tool/build_content.dart` lines 114-169: Inserting parsed hymns directly into SQLite without validating verse continuity, chord token syntax, or cross-language key consistency — must enforce §4.1 checks.
- `android/app/src/main/res/mipmap-*/ic_launcher.png`: Default Flutter template launcher icons — replace with Draft 1 branding icon.
- `docs/*.md`: Stale documentation references to Firebase App Distribution — align with GitHub Actions CI artifact workflow.

## MEMORY.md Notes
- **GUARD-001 | Git Push Authorization:** DO NOT PUSH TO REMOTE WITHOUT EXPLICIT USER PERMISSION. Stage and commit locally only; confirm before push.
- **GUARD-003 | PR and Main Merge Workflow:** Default merge workflow is via Pull Request to main on remote.
- **GUARD-005 | Targeted PR Scope Isolation:** Stage strictly the files relevant to the active task. Never run `git checkout -- <file>`, `git restore`, or `git clean` on files not modified in the current session.
- **GUARD-006 | Android APK CI Artifact Verification & Release Tag Gate:** Local macOS environment lacks Android SDK (`flutter build apk` cannot run locally). Test Android changes via GitHub Actions PR artifact (`presby-hymns-apk`) before merging or tagging releases.
- **BUG-005 | Database Content Pipeline (ChordPro Retention):** Ensure raw ChordPro markup is preserved in `hymn_texts.chordpro_body` so runtime parsers and transposer engines can extract chord-over-syllable layouts.
- **BUG-006 | Hymn Viewer Transposition & Chord Controls:** Decouple vocal pitch cues and key transposition from chord-specific rendering controls (Capo, CAGED, Hide Chords). Pitch cues must remain accessible for all songs.
- **BUG-008 | Database Content Pipeline (Chord Syntax Validation):** Always validate extracted chord tokens against standard musical syntax regex (`^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$`), discarding metadata/structural tags from chord processing.
- **BUG-009 | Android Release R8 ProGuard / SharedPreferences:** Pin federated plugins and keep ProGuard rules in mind when modifying build configurations.
