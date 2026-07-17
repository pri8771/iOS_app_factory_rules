# Claude Code Instructions

This repository is registered with the App Factory.

Before editing:

1. Read `.factory/project-context.json`.
2. Read `.factory/standard-lock.json`.
3. Read `.factory/AGENTS.factory.md`.
4. Read `.factory/library-catalog.json`.
5. Read `quality/quality-manifest.json`.
6. Read the relevant project documentation, feature contracts, and `docs/REUSABLE_COMPONENTS.md`.

The `projectType` field is authoritative:

- `new`: establish scope, architecture, contracts, and reusable-library review before broad implementation.
- `existing`: inventory and preserve the current codebase before restructuring.

Search the catalog before implementing cross-cutting infrastructure. Prefer released shared packages plus thin product adapters. Keep new generic local modules extraction-ready and document them.

Do not claim `done` when platform checks or human review remain. Record actual verification and limitations.
