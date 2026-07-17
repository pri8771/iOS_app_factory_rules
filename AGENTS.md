# Agent Instructions — App Factory Rules

## Repository identity

This repository is the central standards, registry, documentation, and automation control plane. It is not an application repository and must not be scaffolded as one.

Application implementations belong in one repository per product. Mature reusable library implementations belong in dedicated versioned repositories. This repository may contain package templates and catalog metadata, but not a collection of unrelated app or package source trees.

## Fast reading order

Before changing this repository:

1. Read `LLM_START_HERE.md`.
2. Follow its task-routing table.
3. Read only the governance, standard, schema, template, script, or playbook relevant to the current task.
4. Read `CHANGELOG.md` when behavior or compatibility may change.

Do not recursively read the entire repository by default.

## Documentation rules

- Follow `standards/documentation/LLM_DOCUMENTATION_STANDARD.md`.
- Maintain one canonical owner per durable topic.
- Use stable document IDs and descriptive headings.
- Put current truth before history.
- Separate facts, decisions, assumptions, and proposals.
- Mark superseded documents explicitly.
- Do not create a new document when an existing canonical document owns the topic.
- Keep indexes and machine-readable maps synchronized with repository changes.

## Change rules

- Preserve backward compatibility unless a major standard version is intentionally introduced.
- Update `VERSION` and `CHANGELOG.md` when released behavior changes.
- Keep universal rules here and app-specific facts in the product repository.
- Keep mature reusable implementation code in dedicated library repositories.
- Do not register a library until a real repository and usable stable release exist.
- Do not put secrets, credentials, app-specific customer data, signing assets, or production configuration in this repository.
- Templates must be usable without pretending placeholder behavior is complete.
- Schemas, templates, bootstrap output, tests, documentation indexes, and repository maps must agree.
- Bootstrap scripts must not overwrite user files silently.
- Cross-repository product, library, and central changes must have separate scope and evidence.

## Product repository detection contract

In a product repository, agents must follow:

```text
AGENTS.md
→ .factory/repository-map.json
→ .factory/project-context.json
→ docs/README.md
→ task-relevant canonical documents
```

- Treat `projectType`, lifecycle status, platforms, constraints, and library-discovery configuration as authoritative.
- Use the repository map for navigation rather than scanning every file.
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
