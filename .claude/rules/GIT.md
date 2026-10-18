# Git Push and Verification Rules

> Applies to all agents and automated sessions working on presby-hymns.

## Remote Push Authorization Guard
- **NEVER push to remote (`git push`) without explicit user permission.**
- Commit and stage changes locally only.
- The user must test and live-verify changes on a running instance or device before any push to remote PR branches occurs.
- Pushing unverified or bugged commits pollutes PR history and is strictly prohibited.

## PR and Main Merge Workflow Guard
- **DEFAULT MERGE WORKFLOW IS VIA PULL REQUEST TO MAIN ON GITHUB.**
- The standard path is: push the feature branch (once approved), create a Pull Request targeting `main`, and merge through GitHub PR (`gh pr merge`).
- **NEVER merge feature branches directly into local `main` without an explicit manual override from the user** (e.g. "merge locally to main").
- **ALWAYS assign PRs to `@me` (`--assignee "@me"`) upon creation.**

## Working Tree & Scope Isolation Guard
- **Create or switch to a work branch before editing tracked files** (do not edit directly on `main`).
- **Stage only files belonging to your task.** Leave unrelated modified or untracked files untouched in the working tree.
- **NEVER run `git checkout <file>`, `git restore`, or `git reset` on files you did not modify in the current session**, as parallel sessions may have active work in the tree.

## Android APK Verification & Release Tag Gate
- This Mac has no local Android SDK installed; do not run `flutter build apk` or `flutter doctor` locally.
- Standard Android verification is via the `presby-hymns-apk` artifact built on PRs by `.github/workflows/release.yml`.
- **NEVER create or push a `v*` release tag without separate, explicit user confirmation** after the PR is tested on device and merged.
