# Agent Project Detection

## Detection order

When an IDE or coding agent opens a repository:

1. Read root `AGENTS.md` if present.
2. Check for `.factory/project-context.json`.
3. Check for `.factory/standard-lock.json`.
4. Read `quality/quality-manifest.json`.
5. Read app-specific status, architecture, bugs, decisions, and feature contracts.

## Registered repository

A repository is registered when `.factory/project-context.json` exists and validates against the central schema.

The following field is authoritative:

```json
"projectType": "new"
```

or:

```json
"projectType": "existing"
```

Do not infer project type from how much code or documentation exists.

## Unregistered repository

If the marker is absent, classify the repository before changing it:

- Existing indicators: commits, application source, project files, production data models, releases, deployed environments, or functioning tests.
- New indicators: intentionally empty repository or explicit instruction that implementation has not begun.

When classification is uncertain, do not scaffold over existing files. Use the existing-project onboarding path because it is non-destructive.

## Why both root and hidden files exist

Root `AGENTS.md` is discoverable by IDE agents. `.factory/project-context.json` is machine-readable. `.factory/AGENTS.factory.md` carries the minimum local standard even if the central repository is temporarily unavailable.
