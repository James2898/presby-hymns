# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0-m1] — 2026-10-17

### Added
- **Milestone 1 Core Screens (`TASK-20261017-8b2`)**:
  - **Home Screen**: Presbyterian Blue hero branding (`#002F6C`), 150ms debounced search with exact numeric matching and FTS5 full-text lookup, grouped English and Tagalog search results dropdown, and live catalog counts.
  - **Index Screen**: Comprehensive hymn index with "All Hymns", "English", and "Tagalog" filtering tabs; numeric and title alphabetical sorting; sticky A-Z jump rail on title sort; "EN ONLY" badges for untranslated hymns; and dedicated "Unnumbered Songs" section for liturgical items.
  - **Hymn Reader Screen**: Reader canvas with language-based background tinting (`#FBF9F5` for English, `#F5EFE6` for Tagalog); synchronized ChordPro chord-over-lyric layout; collapsible song controls toolbar with semitone transposition, Capo selector (0–7), CAGED voicings, font resizing (default 19px), and "Hide Chords" toggle; bottom slim pitch cue bar sounding tonic pitch; screen wake lock management via `wakelock_plus`; and empty state fallback view.
  - **Test Suite**: Widget and integration test suite covering Home, Index, and Reader screen criteria in `test/features/screens_test.dart`.
