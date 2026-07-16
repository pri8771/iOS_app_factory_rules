# Architecture Standard

## Default feature flow

```text
UI
→ Feature State / View Model
→ Use Case or Domain Operation
→ Repository Interface
→ Local Store, System Framework, File System, or Approved Network Service
```

The exact names may vary, but responsibilities must remain separable and testable.

## Rules

- UI code renders state and sends user intent; it should not directly own persistence, networking, entitlement checks, or substantial business logic.
- Business behavior must be testable without launching the full UI.
- External systems are accessed behind protocols or interfaces where failure injection and deterministic tests are useful.
- State ownership must be clear.
- Complex workflows should use explicit state machines.
- Long-running operations need cancellation and stale-result protection.
- Production, preview, and test data must be structurally separated.
- Dependencies must have a documented purpose, license, maintenance risk, and removal cost.
- Architecture may be simpler for small features, but simplicity must not mean hidden coupling or fake behavior.

## Existing projects

Do not rewrite an existing architecture merely to match this default. First document the current architecture, identify concrete risks, and introduce boundaries incrementally through an approved decision record.
