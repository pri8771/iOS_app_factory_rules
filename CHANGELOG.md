# Changelog

All notable changes to the App Factory Rules are recorded here.

## 0.5.0 — 2026-07-17

### Added

- `scripts/upgrade-project.sh`: safe, idempotent, non-destructive upgrade for an already-registered product repository. Refreshes central-controlled files (`.factory/standard-lock.json`, `.factory/library-catalog.json`), forward-fills any required registration file the project is missing, appends the App Factory managed block to entry files that predate it, and warns (without overwriting) when a product's `.factory/repository-map.json` schema version is behind the current template. Supports `--dry-run`.
- `remote-init.sh --mode upgrade`: runs the same upgrade remotely, so the one documented `curl | bash` entry point now covers register and upgrade.
- `playbooks/UPGRADE_REGISTERED_PROJECT.md`: playbook for the upgrade workflow.
- `schemas/standard-lock.schema.json`: the one core `.factory/*.json` file that previously had no schema now has one; `templates/project/.factory/standard-lock.json` references it via `$schema`.
- `scripts/validate-schemas.py`: dependency-free structural validator that checks central templates and the registry against their declared JSON schemas; wired into CI.
- `tests/test-upgrade.sh`: integration test covering upgrade of a stale registration, `--dry-run` (no writes), preservation of product-authored content, forward-fill of a missing required doc, and idempotency on re-run.
- Central self-describing `.factory/repository-map.json` at the repository root (`repositoryType: "central-control-plane"`), giving the central repository the same machine-readable navigation map it requires of product repositories.
- `locations.waivers` field on the repository-map schema and product template, matching the `quality/waivers/` directory bootstrap already installs.
- Document metadata (`id`, `canonicalFor`, `readWhen`, `related`) on the five core governance documents and the LLM documentation standard itself.

### Changed

- `scripts/verify-project-registration.sh` now checks the complete product registration contract (all `docs/*.md` files and all `quality/` subdirectories bootstrap installs), not a subset. A correctly bootstrapped project is unaffected; a project with files removed after registration will now fail verification and should be brought current with `scripts/upgrade-project.sh`.
- `templates/project/CLAUDE.md`, `templates/project/GEMINI.md`, and `templates/project/.github/copilot-instructions.md` are now wrapped in the same `<!-- APP-FACTORY:BEGIN/END -->` managed block as `templates/project/AGENTS.md`. Previously only `AGENTS.md` used the marker convention that `bootstrap-project.sh` and the new upgrade script rely on to detect whether App Factory content is already present, which would have caused a duplicate append the first time either script re-ran against an existing file.
- `standards/engineering/MODULAR_LIBRARY_STANDARD.md` states the "library-ready by default, not necessarily a standalone library immediately" principle explicitly.
- `governance/REPOSITORY_MODEL.md` lists `.factory/repository-map.json` among a product's local registration layer; it was previously omitted despite being required by the verifier and bootstrap.

### Fixed

- `templates/project/quality/quality-manifest.json` declared `qualityStandardVersion: "0.2.0"`, two releases behind the actual current standard. `bootstrap-project.sh` always generates this file fresh from `VERSION` rather than copying the template, so no registered project was affected, but the checked-in template contradicted the current version everywhere else it is stated.

### Migration impact

No product repository is confirmed registered against this standard within this repository's visibility. Any that are should run `scripts/upgrade-project.sh` (or `remote-init.sh --mode upgrade`) once; it is backward compatible, non-destructive, and idempotent.

## 0.4.0 — 2026-07-17

### Added

- `LLM_START_HERE.md` as the shortest central-repository context path.
- LLM-first documentation standard with canonical ownership, metadata, stable headings, status vocabulary, and retrieval rules.
- Machine-readable repository-map schema and product template.
- Product-local `docs/README.md` documentation index with task-based reading routes.
- Repository-map version locking and registration verification.

### Changed

- Project bootstrap now installs an LLM navigation layer before detailed documentation.
- All supported agent templates now use the repository map and documentation index before deep repository reading.
- Bootstrap and CI tests now validate the LLM context path for both new and existing projects.
- Documentation guidance now requires one canonical owner per durable topic and explicit separation of facts, decisions, assumptions, and proposals.

## 0.3.0 — 2026-07-17

### Added

- One-repository-per-product and one-repository-per-mature-library governance.
- Modular library engineering standard and reuse-first implementation workflow.
- Reusable-library promotion and generic edge-case contribution playbook.
- Machine-readable reusable-library registry and schema.
- Project-local library-catalog snapshot and reusable-component tracking document.
- Automatic remote project initialization through `scripts/remote-init.sh`.
- Library-catalog search helper.
- Swift package extraction checklist and shared-library README template.

### Changed

- Project bootstrap now installs and locks a reusable-library catalog snapshot.
- Agent entry files now require library discovery before new cross-cutting infrastructure.
- Existing-project onboarding now inventories internal reusable modules and dependency overlap.
- New-project onboarding now reviews reusable packages before infrastructure implementation.
- Registration verification and CI now validate library-catalog files and versions.

## 0.2.0 — 2026-07-16

### Added

- Tool-specific project entry templates for Claude Code, Gemini, Cursor, and GitHub Copilot.
- Central IDE and agent setup guide.
- Machine-readable `agentEntryPoints` in the project context.
- Product, design, business, legal, shared-design, and release-standard indexes.

### Changed

- The project bootstrap now installs cross-agent entry files without silently replacing existing instructions.
- Project registration verification and local standards remain centralized through `.factory/project-context.json` and `.factory/AGENTS.factory.md`.

## 0.1.0 — 2026-07-16

### Added

- Central repository structure.
- New-versus-existing project registration protocol.
- Project context, standard lock, quality manifest, feature contract, and completion report schemas.
- Initial quality, architecture, platform, and AI-agent standards.
- Safe project bootstrap and registration verification scripts.
- Templates for project documentation and quality evidence.
