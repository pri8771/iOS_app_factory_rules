# Agent Instructions — App Factory Rules

## Repository identity

This repository is the central standards repository. It is not an application and must not be scaffolded as one.

## Mandatory reading order

Before changing this repository, read:

1. `governance/STUDIO_PRINCIPLES.md`
2. `governance/PROJECT_LIFECYCLE.md`
3. `governance/DEFINITION_OF_DONE.md`
4. The standard or template being changed
5. `CHANGELOG.md`

## Change rules

- Preserve backward compatibility unless a major standard version is intentionally introduced.
- Update `VERSION` and `CHANGELOG.md` when released behavior changes.
- Keep universal rules here and app-specific facts in the app repository.
- Do not put secrets, credentials, app-specific customer data, or production configuration in this repository.
- Templates must be usable without pretending placeholder behavior is complete.
- Schemas and examples must agree.
- Bootstrap scripts must not overwrite user files silently.

## Project detection contract

In an application repository, agents must check for `.factory/project-context.json` before coding.

- If present, treat its `projectType`, `lifecycleStatus`, platforms, and constraints as authoritative.
- If absent, the repository is unregistered. Do not assume it is new merely because documentation is missing.
- An existing repository must be inventoried before restructuring or replacing code.
- A new repository must establish product scope and architecture before broad implementation.

## Completion language

Use the following states precisely:

`planned → ready → in_progress → code_complete → verification_pending → verified → human_review_required → done`

`code_complete` never means `done`.
