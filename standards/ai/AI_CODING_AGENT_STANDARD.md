# AI Coding Agent Standard

## Before editing

1. Read `AGENTS.md`.
2. Read `.factory/project-context.json` and `.factory/standard-lock.json` when present.
3. Read `quality/quality-manifest.json`.
4. Read the relevant feature contract, architecture, status, bugs, and decisions.
5. Identify which checks can run in the current environment.

## Existing projects

- Inventory the current codebase, targets, build system, persistence, dependencies, tests, and known behavior before restructuring.
- Do not replace working code with a new scaffold without an approved decision.
- Preserve behavior not explicitly removed from scope.
- Establish baseline build and test status before attributing failures to new work.

## New projects

- Confirm the user outcome, MVP boundary, platforms, persistence, backend policy, privacy constraints, and monetization assumptions before broad implementation.
- Establish architecture and feature contracts before producing many screens.
- Implement one vertical feature slice with real behavior and tests before expanding breadth.

## During implementation

- Do not use fake production data.
- Do not create empty controls or cosmetic-only settings.
- Model non-happy states explicitly.
- Prevent duplicates, stale results, and silent data loss.
- Update documentation and contracts when behavior changes.
- Do not silently weaken acceptance criteria.

## Completion reporting

Report:

- implemented behavior;
- files changed;
- checks run and actual results;
- checks not run and why;
- known issues;
- remaining placeholders;
- documentation updated;
- recommended next verification.

Never invent test results. Use `code_complete` or `verification_pending` when platform verification remains.
