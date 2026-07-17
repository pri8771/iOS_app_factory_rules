# Reuse-First Workflow

Use this workflow whenever a task introduces or changes a cross-cutting capability.

## 1. Classify the capability

Determine whether the work is:

- product-specific behavior;
- a product-specific adapter around generic infrastructure;
- a generic capability that may already exist;
- a generic edge case in an existing shared library.

Do not generalize product logic merely to satisfy an architectural preference.

## 2. Search the local catalog

Read:

```text
.factory/library-catalog.json
docs/REUSABLE_COMPONENTS.md
```

Search by capability, platform, package manager, and maturity. The local catalog is a snapshot of the central registry and is available even when the central repository cannot be reached.

## 3. Evaluate candidates

For every plausible library, verify:

- supported platforms and minimum versions;
- latest stable version;
- package manager and installation method;
- public API fit;
- license and dependency policy;
- maintenance status;
- known limitations;
- whether an adapter is sufficient.

Do not use a library solely because its name resembles the task.

## 4. Reuse through an adapter

Prefer a thin product-owned adapter that translates product models into the library's generic types. This keeps branding and business rules out of the shared package and reduces future replacement cost.

Do not copy library source into the app for ordinary customization.

## 5. When no library fits

Implement a focused app-local module with:

- explicit interfaces;
- injected configuration and dependencies;
- no unnecessary product branding;
- tests for success and failure;
- a documented extraction boundary.

Record the candidate in `docs/REUSABLE_COMPONENTS.md` with its current status and evidence.

## 6. Promote proven reuse

Use `playbooks/PROMOTE_CODE_TO_SHARED_LIBRARY.md` when the capability is needed by another product or clearly qualifies as shared infrastructure.

Promotion is complete only after:

- generic API review;
- independent tests;
- package documentation;
- a dedicated repository;
- a versioned release;
- central catalog registration;
- at least one product consuming the released package.

## 7. Feed generic edge cases upstream

When a product exposes a missing generic edge case:

1. Add a regression test that proves the behavior.
2. Confirm the behavior is not product-specific.
3. Patch the shared-library repository in a separate change.
4. Release the library.
5. Update `registry/libraries.json` if version or capability metadata changed.
6. Update universal standards only when the discovery changes the general engineering rule.
7. Upgrade the product dependency and remove temporary workarounds.

An app agent must not silently contaminate a shared package with app-specific behavior.