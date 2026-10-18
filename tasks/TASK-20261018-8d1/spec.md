# Feature Specification

### Feature Summary
Establish complete offline self-containment, standardized visual identity, cue tone playback, and rigorous content verification for the Presbyterian Hymns application. This release implements the approved Draft 1 branding across Android adaptive launcher mipmaps and the in-app HeroBanner, bundles all required typography (Space Grotesk, Source Serif 4, Inter) locally to guarantee 100% offline rendering, generates 12 chromatic OGG audio cue tones (C4–B4) with resilient CueBar playback, introduces a comprehensive content integrity checker in `tool/build_content.dart` outputting `build/content-report.md`, and updates distribution documentation to standardize on GitHub Actions CI APK artifacts while deprecating Firebase App Distribution.

---

### Acceptance Criteria

#### 1. App Icon & In-App Branding
1. The Android launcher icon displays the approved Draft 1 design: pure white background (`#FFFFFF`), solid blue Christian cross (`#004AAD`), yellow radiant sunburst rays emanating behind the cross, and yellow text reading "PRESBYTERIAN HYMNS" beneath the cross.
2. Launcher icon assets are generated and placed in all standard Android mipmap densities under `android/app/src/main/res/`:
   - `mipmap-mdpi/ic_launcher.png` (48x48) & `mipmap-mdpi/ic_launcher_round.png`
   - `mipmap-hdpi/ic_launcher.png` (72x72) & `mipmap-hdpi/ic_launcher_round.png`
   - `mipmap-xhdpi/ic_launcher.png` (96x96) & `mipmap-xhdpi/ic_launcher_round.png`
   - `mipmap-xxhdpi/ic_launcher.png` (144x144) & `mipmap-xxhdpi/ic_launcher_round.png`
   - `mipmap-xxxhdpi/ic_launcher.png` (192x192) & `mipmap-xxxhdpi/ic_launcher_round.png`
3. Adaptive icon configuration is present in `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` and `ic_launcher_round.xml`, utilizing the white background (`#FFFFFF`) and approved foreground layer.
4. The `HeroBanner` component (`lib/features/home/presentation/widgets/hero_banner.dart`) displays the new Presbyterian Hymns logo/icon asset matching the Draft 1 branding without layout distortion across mobile and tablet viewports.

#### 2. Asset Bundling (100% Offline Typography)
5. TrueType Font files for `Space Grotesk`, `Source Serif 4`, and `Inter` covering required standard weights (regular, italic, medium, bold) are physically present in `assets/fonts/`.
6. `pubspec.yaml` declares local font families under the `flutter: fonts:` section mapping `Space Grotesk`, `Source Serif 4`, and `Inter` directly to their respective bundled `.ttf` files in `assets/fonts/`.
7. `pubspec.yaml` registers `assets/fonts/` (or individual font paths) in the `flutter: assets:` section.
8. The application renders typography completely offline with zero HTTP network requests to Google Fonts or external CDN endpoints, and does not degrade or throw font loading errors when network connectivity is severed.

#### 3. Cue Audio Generation & Playback
9. A CLI generator script `tool/render_cue_tones.dart` is implemented and can be executed via `dart run tool/render_cue_tones.dart`.
10. `tool/render_cue_tones.dart` generates exactly 12 chromatic OGG audio cue tones spanning C4 through B4 (C4, C#4/Db4, D4, D#4/Eb4, E4, F4, F#4/Gb4, G4, G#4/Ab4, A4, A#4/Bb4, B4) calculated via equal temperament ($A4 = 440 \text{ Hz}$) with click-free amplitude envelope ramps.
11. Generated cue audio files are placed in `assets/audio/cue/` and registered under the `flutter: assets:` section in `pubspec.yaml`.
12. `CueBar` (`lib/features/reader/widgets/cue_bar.dart`) loads and plays the corresponding tonic cue tone matching the hymn's designated key when triggered by the user.
13. Per BUG-006 prevention guard, `CueBar` audio cue triggers and key pitch controls remain accessible and functional independently of chord visibility controls (Capo, CAGED, Hide Chords).
14. If the audio player encounters missing assets, unsupported codecs, or hardware audio output errors during cue playback, `CueBar` catches the exception gracefully, provides appropriate non-blocking visual feedback (e.g. snackbar or icon state), and never crashes or locks the UI.

#### 4. Content Checker Tooling (`tool/build_content.dart`)
15. `tool/build_content.dart` executes a strict content validation pass against all hymn content files before database compilation.
16. **Chord Token Syntax Validation (BUG-008):** Validates all chord annotations against standard musical syntax regex (`^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$`) and excludes structural/metadata tags (such as `[Verse]`, `[Chorus]`, `[Refrain]`) from chord parsing errors.
17. **Verse Numbering Integrity:** Asserts that numbered verses within each hymn are strictly contiguous starting from 1 (e.g., 1, 2, 3...) with no skipped numbers or invalid ordering.
18. **Bilingual Key Matching:** Verifies that paired English (EN) and Tagalog (TL) hymn entries exist, match valid key identifiers, and maintain parity where cross-references are expected.
19. **ChordPro Body Preservation (BUG-005):** Verifies that raw ChordPro markup is preserved in `chordpro_body` while clean, bracket-stripped lyrics are written to `lyrics_text` for full-text search indexing.
20. Validation results are written to `build/content-report.md`, detailing total hymns checked, validation status (PASS/FAIL), count of validated chords, verse numbering anomalies, translation mismatches, and timestamp.
21. When validation encounters fatal syntax or continuity errors, `tool/build_content.dart` outputs descriptive error diagnostics referencing the problematic hymn number and line, and exits with a non-zero exit code.

#### 5. Distribution Documentation & Workflow
22. All references to Firebase App Distribution are removed or replaced in `docs/01-project-overview.md` and `docs/03-implementation-plan.md`.
23. Documentation specifies that test APK distributions are produced via the GitHub Actions CI workflow artifact (`presby-hymns-apk`) on Pull Requests (per GUARD-006), and production releases are published via GitHub Release tags (`v*`).

---

### Out of Scope
- Implementing audio playback for full hymn melodies or backing tracks (scope is strictly the 12 chromatic C4–B4 pitch cue tones).
- Modifying SQLite schema migrations or schema version numbers beyond existing database definitions.
- Publishing builds to Google Play Store or external third-party app stores in this phase.
- Interactive audio editing or MIDI synthesis at runtime.

---

### Fallback Behaviors
- **Missing or Unsupported Audio Output:** If the device cannot play audio cues (e.g., audio session cannot be acquired or asset is missing), `CueBar` disables the play button with tooltip / hint: `"Pitch cue unavailable on this device"`.
- **Content Validation Failures:** When `tool/build_content.dart` finds syntax or verse ordering errors, it generates `build/content-report.md` highlighting failing hymns and lines before exiting, rather than failing silently.

---

### Resolved Ambiguities
- **App Icon Palette:** Resolved via approved Design Draft 1 — Pure white background (`#FFFFFF`), solid `#004AAD` blue cross, radiant yellow sunburst rays, and yellow "PRESBYTERIAN HYMNS" banner text.
- **Audio Tone Set & Format:** Standardized on 12 equal-temperament tones (C4 to B4) in `.ogg` format generated via `tool/render_cue_tones.dart`.
- **Distribution Model:** Firebase App Distribution dropped in favor of GitHub Actions CI APK build artifacts (`presby-hymns-apk`) and GitHub Releases.
- **Chord Validation Syntax:** Resolved via BUG-008 regex (`^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$`), discarding structural tags (`[Verse]`, `[Chorus]`).

---

### Open Questions
None. All questions settled in design grill.
