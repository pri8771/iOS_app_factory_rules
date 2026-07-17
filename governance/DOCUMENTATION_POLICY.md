# Documentation Policy

## Central rules repository

Store universal governance, standards, documentation rules, playbooks, schemas, project and package templates, bootstrap tooling, reusable-library registry metadata, validation workflows, and standard version history here.

Do not store app-specific PRDs, product source code, signing material, secrets, or the implementation source of mature reusable libraries here.

## Product repository

Store product-specific requirements, architecture, feature contracts, status, bugs, decisions, risks, assumptions, test plans, release records, evidence, product adapters, and reusable-candidate tracking in the product repository.

Each product should maintain `docs/REUSABLE_COMPONENTS.md` to record shared libraries reviewed, packages adopted, app-local reusable candidates, rejected candidates, and upstream edge cases.

## Shared-library repository

Store the package source, public API documentation, tests, changelog, semantic versions, compatibility matrix, license decision, migration notes, and release evidence in the library's own repository.

The central `registry/libraries.json` entry is discovery metadata, not a substitute for the library's own documentation.

## Authority

- Code is authoritative for current implemented behavior.
- Feature contracts are authoritative for required product behavior.
- Shared-library tests and released API documentation are authoritative for package behavior.
- Decision records explain intentional tradeoffs.
- Completion reports describe verification status.
- The central standard defines minimum expectations.
- The central registry identifies approved, versioned reusable packages and their declared capabilities.

## Maintenance

Documentation must be updated in the same change that alters the behavior it describes. Agents must not create duplicate documents with overlapping authority when an existing document can be updated.

Product, library, and central documentation changes must remain separated by repository and scope. A product task may identify a central or library update, but it must not silently make unrelated cross-repository changes.
