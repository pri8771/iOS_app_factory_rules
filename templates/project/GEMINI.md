# Gemini Agent Instructions

This repository is registered with the App Factory.

Read these files before changing code:

- `.factory/project-context.json`
- `.factory/standard-lock.json`
- `.factory/AGENTS.factory.md`
- `.factory/library-catalog.json`
- `quality/quality-manifest.json`
- relevant files in `docs/` and `quality/feature-contracts/`
- `docs/REUSABLE_COMPONENTS.md`

Treat `projectType` as authoritative. Existing projects require a baseline inventory before restructuring; new projects require defined scope, architecture, and reusable-library review before broad implementation.

Search the catalog before implementing generic infrastructure. Prefer released shared packages plus product adapters. Record any new library-ready local module or upstream edge case.

Report actual checks run, checks not run, known issues, and remaining placeholders. `code_complete` is not `done`.
