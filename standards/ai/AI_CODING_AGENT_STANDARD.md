# AI Coding Agent Standard

## Before editing

1. Read `AGENTS.md`.
2. Read `.factory/project-context.json` and `.factory/standard-lock.json` when present.
3. Read `quality/quality-manifest.json`.
4. Read the relevant feature contract, architecture, status, bugs, decisions, and `docs/REUSABLE_COMPONENTS.md`.
5. Identify which checks can run in the current environment.
6. For cross-cutting capabilities, inspect `.factory/library-catalog.json` before designing a new implementation.

## Existing projects

- Inventory the current codebase, targets, build system, persistence, dependencies, tests, shared modules, and known behavior before restructuring.
- Do not replace working code with a new scaffold without an approved decision.
- Preserve behavior not explicitly removed from scope.
- Establish baseline build and test status before attributing failures to new work.
- Identify reusable candidates without performing an unsolicited package extraction.

## New projects

- Confirm the user outcome, MVP boundary, platforms, persistence, backend policy, privacy constraints, and monetization assumptions before broad implementation.
- Establish architecture and feature contracts before producing many screens.
- Search the reusable-library catalog before implementing networking, persistence, StoreKit, export, logging, accessibility helpers, permissions, notifications, or test infrastructure.
- Implement one vertical feature slice with real behavior and tests before expanding breadth.

## Reuse-first behavior

When a suitable shared library exists:

- verify platform and version compatibility;
- consume a released version;
- isolate product-specific mapping in a thin adapter;
- do not copy the library source into the app for ordinary customization.

When no suitable library exists:

- implement a narrow app-local module with explicit boundaries;
- avoid app branding and hardcoded product configuration in generic internals;
- add deterministic tests;
- record the module in `docs/REUSABLE_COMPONENTS.md`;
- recommend promotion only when genericity is evidenced.

When an app discovers a generic edge case in a shared library:

- add regression evidence;
- separate product, library, and central-registry changes;
- update the shared library rather than maintaining a permanent app fork;
- never add app-specific concepts to the shared API;
- do not claim completion until the app consumes and verifies the released fix.

## During implementation

- Do not use fake production data.
- Do not create empty controls or cosmetic-only settings.
- Model non-happy states explicitly.
- Prevent duplicates, stale results, and silent data loss.
- Update documentation and contracts when behavior changes.
- Do not silently weaken acceptance criteria.
- Do not silently push changes to another repository merely because access is available.

## Completion reporting

Report:

- implemented behavior;
- files changed;
- shared libraries considered and the adoption decision;
- app-local reusable candidates created;
- upstream library or registry changes required;
- checks run and actual results;
- checks not run and why;
- known issues;
- remaining placeholders;
- documentation updated;
- recommended next verification.

Never invent test results. Use `code_complete` or `verification_pending` when platform verification remains.
