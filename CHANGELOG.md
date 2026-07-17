# Changelog

All notable changes to the App Factory Rules are recorded here.

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
