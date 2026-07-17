# Agent Instructions — App Factory Rules

## Repository identity

This repository is the central standards, registry, and automation control plane. It is not an application repository and must not be scaffolded as one.

Application implementations belong in one repository per product. Mature reusable library implementations belong in dedicated versioned repositories. This repository may contain package templates and catalog metadata, but not a collection of unrelated app or package source trees.

## Mandatory reading order

Before changing this repository, read:

1. `governance/STUDIO_PRINCIPLES.md`
2. `governance/REPOSITORY_MODEL.md`
3. `governance/PROJECT_LIFECYCLE.md`
4. `governance/DEFINITION_OF_DONE.md`
5. The standard, registry, template, or workflow being changed
6. `CHANGELOG.md`

## Change rules

- Preserve backward compatibility unless a major standard version is intentionally introduced.
- Update `VERSION` and `CHANGELOG.md` when released behavior changes.
- Keep universal rules here and app-specific facts in the product repository.
- Keep mature reusable implementation code in dedicated library repositories.
- Do not register a library until a real repository and usable stable release exist.
- Do not put secrets, credentials, app-specific customer data, signing assets, or production configuration in this repository.
- Templates must be usable without pretending placeholder behavior is complete.
- Schemas, templates, bootstrap output, tests, and documentation must agree.
- Bootstrap scripts must not overwrite user files silently.
- Cross-repository product, library, and central changes must have separate scope and evidence.

## Project detection contract

In a product repository, agents must check for `.factory/project-context.json` before coding.

- If present, treat its `projectType`, `lifecycleStatus`, platforms, constraints, and library-discovery configuration as authoritative.
- Read `.factory/library-catalog.json` before implementing cross-cutting infrastructure.
- If the project marker is absent, the repository is unregistered. Do not assume it is new merely because documentation is missing.
- An existing repository must be inventoried before restructuring or replacing code.
- A new repository must establish product scope, architecture, feature contracts, and reusable-library review before broad implementation.

## Reusable-library contributions

When an app exposes a generic missing edge case:

1. protect the product with a regression test;
2. prove the behavior is generic;
3. contribute the fix to the library repository in a separate change;
4. release a new library version;
5. update `registry/libraries.json` when metadata changes;
6. upgrade the product and remove temporary duplication.

Do not silently promote app-specific behavior into a shared package.

## Completion language

Use the following states precisely:

`planned → ready → in_progress → code_complete → verification_pending → verified → human_review_required → done`

`code_complete` never means `done`.
