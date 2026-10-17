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
