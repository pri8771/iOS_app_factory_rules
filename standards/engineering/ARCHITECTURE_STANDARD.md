# Architecture Standard

## Default feature flow

```text
UI
→ Feature State / View Model
→ Use Case or Domain Operation
→ Repository Interface
→ Local Store, System Framework, File System, Shared Library, or Approved Network Service
```

The exact names may vary, but responsibilities must remain separable and testable.

## Product and library boundaries

- Keep product-specific user flows, branding, copy, and business rules in the product repository.
- Put cross-cutting behavior behind explicit interfaces so it can be tested and replaced.
- Before implementing infrastructure, inspect `.factory/library-catalog.json` for an existing shared package.
- Use a thin product adapter to translate product models into generic library types.
- When no shared library fits, create a focused app-local module that is library-ready but not prematurely published.
- Promote proven reusable modules through the shared-library playbook rather than copying files across products.

See `standards/engineering/MODULAR_LIBRARY_STANDARD.md` and `standards/engineering/REUSE_FIRST_WORKFLOW.md`.

## Rules

- UI code renders state and sends user intent; it should not directly own persistence, networking, entitlement checks, or substantial business logic.
- Business behavior must be testable without launching the full UI.
- External systems are accessed behind protocols or interfaces where failure injection and deterministic tests are useful.
- State ownership must be clear.
- Complex workflows should use explicit state machines.
- Long-running operations need cancellation and stale-result protection.
- Production, preview, and test data must be structurally separated.
- Dependencies must have a documented purpose, license, maintenance risk, version, compatibility range, and removal cost.
- Architecture may be simpler for small features, but simplicity must not mean hidden coupling, fake behavior, or permanent copy-paste reuse.

## Existing projects

Do not rewrite an existing architecture merely to match this default. First document the current architecture, identify concrete risks, inventory existing reusable modules and dependencies, and introduce boundaries incrementally through an approved decision record.
