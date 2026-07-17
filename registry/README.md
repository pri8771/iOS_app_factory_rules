# Reusable Library Registry

`libraries.json` is the App Factory's discovery index for real, versioned shared packages.

## Registration requirements

A library may be added only when it has:

- a dedicated accessible repository;
- a stable public API;
- independent automated tests;
- installation instructions;
- a released semantic version;
- supported platform and minimum-version declarations;
- a maintenance status and owner;
- documented limitations;
- a license decision.

Do not add aspirational or placeholder packages.

## Updating an entry

Update the entry when:

- the latest stable version changes;
- capabilities expand or contract;
- supported platforms or minimum versions change;
- known limitations change;
- maintenance status changes;
- the repository is deprecated or archived.

Increase `catalogVersion` whenever catalog content changes. Registered projects receive a local snapshot at `.factory/library-catalog.json` and lock its version in `.factory/standard-lock.json`.

## Source ownership

The registry contains metadata only. Package source belongs in the library's dedicated repository. Product-specific adapters belong in the consuming product repository.
